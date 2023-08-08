import db from 'mariadb'
import dotenv from 'dotenv'
import fs from 'fs/promises'
dotenv.config()

const scoop = {}
scoop.config = {
  host: '172.17.0.1',
  database: 'scoop',
  user: 'scoop',
  password: 'scoop'
}
scoop.archiveConfig = {}

const JsonString = (obj) => {
  return JSON.stringify(obj, (_, v) => typeof v === 'bigint' ? v.toString() : v)
}

const start = async () => {
  if (process.env.SCOOP_DB_PASS) {
    scoop.config.password = process.env.SCOOP_DB_PASS
  }
  if (process.env.SCOOP_DB_USER) {
    scoop.config.user = process.env.SCOOP_DB_USER
  }
  if (process.env.SCOOP_DB_NAME) {
    scoop.config.database = process.env.SCOOP_DB_NAME
  }
  if (process.env.SCOOP_DB_HOST) {
    scoop.config.host = process.env.SCOOP_DB_HOST
  }

  if (process.env.SCOOP_DB_ARCHIVE_HOST) {
    scoop.archiveConfig.host = process.env.SCOOP_DB_ARCHIVE_HOST
    if (process.env.SCOOP_DB_ARCHIVE_PASS) {
      scoop.archiveConfig.password = process.env.SCOOP_DB_ARCHIVE_PASS
    }
    if (process.env.SCOOP_DB_ARCHIVE_USER) {
      scoop.archiveConfig.user = process.env.SCOOP_DB_ARCHIVE_USER
    }
    if (process.env.SCOOP_DB_ARCHIVE_NAME) {
      scoop.archiveConfig.database = process.env.SCOOP_DB_ARCHIVE_NAME
    }
    scoop.hasArchive = 1
  } else {
    scoop.hasArchive = 0
  }

  if (scoop.poolCluster) {
    scoop.poolCluster.end()
    scoop.poolCluster = null
  }
  scoop.poolCluster = db.createPoolCluster()

  scoop.poolCluster.add('main', scoop.config)
  if (scoop.hasArchive) {
    scoop.poolCluster.add('archive', scoop.archiveConfig)
  }
}

const end = async () => {
  if (scoop.poolCluster) {
    scoop.poolCluster.end()
    scoop.poolCluster = null
  }
}

const processExport = async (query, uid, useArchive, outputFileName) => {
  let rowCount = 0

  const outputFile = await fs.open(outputFileName, 'w')
  try {
    const processSingleQuery = async (conn, query, uid) => {
      if (Array.isArray(query)) {
        for (const q of query) {
          rowCount = await processQuery(conn, outputFile, rowCount, q, uid)
        }
      } else {
        rowCount = await processQuery(conn, outputFile, rowCount, query, uid)
      }
      return rowCount
    }

    const conn = await scoop.poolCluster.getConnection('main')
    try {
      await outputFile.appendFile('[')
      rowCount = await processSingleQuery(conn, query, uid)
    } catch (err) {
      console.log(err)
    } finally {
      conn.end()
    }
    if (scoop.hasArchive && useArchive) {
      const archivedb = await scoop.poolCluster.getConnection('archive')
      try {
        rowCount = await processSingleQuery(archivedb, query, uid)
      } catch (err) {
        console.log(err)
      } finally {
        archivedb.end()
      }
    }
    if (rowCount > 0) await outputFile.appendFile(']\n')
  } finally {
    await outputFile.close()
  }
  return rowCount
}

const processQuery = async (connection, outputFile, rowCount, query, parameters) => {
  const queryStream = connection.queryStream(query, [parameters])
  try {
    for await (const row of queryStream) {
      let output = ''
      if (rowCount > 0) {
        output = ',\n'
      }
      await outputFile.appendFile(output + JsonString(row))
      rowCount++
    }
  } catch (e) {
    console.log(e)
    queryStream.close()
  }
  return rowCount
}

export { start, end, processExport }
