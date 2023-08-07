import db from 'mariadb'
import fs from 'fs/promises'
import dotenv from 'dotenv'

dotenv.config()
const scoop = {}

const uid = 2
const qSql = 'SELECT sid,aid,title,time,introtext,bodytext,displaystatus,commentstatus FROM stories WHERE aid = ? ORDER BY time DESC'

const config = {
  host: '172.17.0.1',
  database: 'scoop',
  user: 'scoop',
  password: 'scoop'
}

const archiveConfig = {}

if (process.env.SCOOP_DB_PASS) {
  config.password = process.env.SCOOP_DB_PASS
}
if (process.env.SCOOP_DB_USER) {
  config.user = process.env.SCOOP_DB_USER
}
if (process.env.SCOOP_DB_NAME) {
  config.database = process.env.SCOOP_DB_NAME
}
if (process.env.SCOOP_DB_HOST) {
  config.host = process.env.SCOOP_DB_HOST
}

if (process.env.SCOOP_DB_ARCHIVE_HOST) {
  archiveConfig.host = process.env.SCOOP_DB_ARCHIVE_HOST
  if (process.env.SCOOP_DB_ARCHIVE_PASS) {
    archiveConfig.password = process.env.SCOOP_DB_ARCHIVE_PASS
  }
  if (process.env.SCOOP_DB_ARCHIVE_USER) {
    archiveConfig.user = process.env.SCOOP_DB_ARCHIVE_USER
  }
  if (process.env.SCOOP_DB_ARCHIVE_NAME) {
    archiveConfig.database = process.env.SCOOP_DB_ARCHIVE_NAME
  }
  scoop.hasArchive = 1
  scoop.archiveDatabase = archiveConfig
} else {
  scoop.hasArchive = 0
  scoop.archiveDatabase = null
}

console.log(config)
console.log(archiveConfig)

// Clear out the result file

let storyCount = 0
const processStories = async (connection) => {
  const queryStream = connection.queryStream(qSql, uid)
  try {
    for await (const row of queryStream) {
      let output = ''
      if (storyCount > 0) {
        output = ',\n'
      }
      storyCount++
      await outputFile.appendFile(output + JSON.stringify(row))
    }
  } catch (e) {
    queryStream.close()
  }
}

const outputFile = await fs.open('stories.json', 'w')

try {
  const conn = await db.createConnection(config)
  try {
    await outputFile.appendFile('[')

    await processStories(conn)
  } finally {
    conn.end()
  }

  console.log(`Processed main database (total ${storyCount} entries)`)

  if (scoop.hasArchive) {
    const archivedb = await db.createConnection(scoop.archiveDatabase)
    try {
      await processStories(archivedb)
    } finally {
      archivedb.end()
    }
    console.log(`Processed archive database (total ${storyCount} entries)`)
  }

  if (storyCount > 0) await outputFile.appendFile(']\n')
} finally {
  await outputFile.close()
}
console.log(`Wrote ${storyCount} entries total`)
