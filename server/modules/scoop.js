const scoop = {}
const config = require('../../config/config.json')
const Sections = require('../repo/sections')
const Database = require('./database')
const Stories = require('../repo/stories')

if (process.env.SCOOP_DB_PASS) {
  config.database.password = process.env.SCOOP_DB_PASS
}
if (process.env.SCOOP_DB_USER) {
  config.database.user = process.env.SCOOP_DB_USER
}
if (process.env.SCOOP_DB_NAME) {
  config.database.database = process.env.SCOOP_DB_NAME
}
if (process.env.SCOOP_DB_HOST) {
  config.database.host = process.env.SCOOP_DB_HOST
}

scoop.name = config.site.name
scoop.sections = new Sections(config.sections)
scoop.database = new Database(config.database)
scoop.stories = new Stories(scoop)

module.exports = scoop
