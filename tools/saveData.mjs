import db from 'mariadb'
import dotenv from 'dotenv'
dotenv.config()

const scoop = {}
scoop.config = {
  host: '172.17.0.1',
  database: 'scoop',
  user: 'scoop',
  password: 'scoop'
}
scoop.archiveConfig = {}

const myStorySql = 'SELECT sid,u.nickname as author,title,time,introtext,bodytext,displaystatus,commentstatus FROM stories s INNER JOIN users u ON s.aid = u.uid WHERE aid = ? ORDER BY time DESC'
const myCommentSql = 'SELECT sid,cid,pid,u.nickname as user,date,subject,comment,points,sig_status,sig FROM comments c INNER JOIN users u ON c.uid = u.uid WHERE c.uid = ? ORDER BY date DESC'
const myDMsSqlSent = 'SELECT message_id, u1.nickname as from_nick, u2.nickname as to_nick, sent_date, subject, message, "0" as msg_read, "0" as inbox_delete, sent_delete FROM private_message pm INNER JOIN users u1 on pm.from_uid = u1.uid INNER JOIN users u2 on pm.to_uid = u2.uid WHERE pm.from_uid = ? ORDER BY sent_date DESC'
const myDMsSqlGot = 'SELECT message_id, u1.nickname as from_nick, u2.nickname as to_nick, sent_date, subject, message, msg_read, inbox_delete, "0" as sent_delete FROM private_message pm INNER JOIN users u1 on pm.from_uid = u1.uid INNER JOIN users u2 on pm.to_uid = u2.uid WHERE pm.to_uid = ? ORDER BY sent_date DESC'

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

const processSql = async (uid, query, outputFile) => {
  let rowCount = 0
  const conn = await scoop.poolCluster.getConnection('main')
  try {
    await outputFile.appendFile('[')

    rowCount = await processQuery(conn, outputFile, rowCount, query, uid)
  } catch (err) {
    console.log(err)
  } finally {
    conn.end()
  }

  console.log(`Processed main database (total ${rowCount} entries)`)

  if (scoop.hasArchive) {
    const archivedb = await scoop.poolCluster.getConnection('archive')
    try {
      rowCount = await processQuery(archivedb, outputFile, rowCount, query, uid)
    } finally {
      archivedb.end()
    }
    console.log(`Processed archive database (total ${rowCount} entries)`)
  }

  if (rowCount > 0) await outputFile.appendFile(']\n')

  return rowCount
}

const processMyStories = async (uid, outputFile) => {
  return await processSql(uid, myStorySql, outputFile)
}

const processMyComments = async (uid, outputFile) => {
  return await processSql(uid, myCommentSql, outputFile)
}

const processMyDMs = async (uid, outputFile) => {
  let rowCount = 0
  const conn = await scoop.poolCluster.getConnection('main')
  try {
    await outputFile.appendFile('[')

    rowCount = await processQuery(conn, outputFile, rowCount, myDMsSqlGot, uid)
    rowCount = await processQuery(conn, outputFile, rowCount, myDMsSqlSent, uid)
  } catch (err) {
    console.log(err)
  } finally {
    conn.end()
  }
  console.log(`Processed main database (total ${rowCount} entries)`)
  if (rowCount > 0) await outputFile.appendFile(']\n')
  return rowCount
}

const processQuery = async (connection, outputFile, rowCount, query, parameters) => {
  const queryStream = connection.queryStream(query, parameters)
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

const saveData = {
  start,
  end,
  processMyStories,
  processMyComments,
  processMyDMs
}

export { start, end, processMyStories, processMyComments, processMyDMs }

export default saveData
