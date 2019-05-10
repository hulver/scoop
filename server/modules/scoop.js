const scoop = {}
const config = require('../../config/config.json')
const sections = require('./sections')
const queries = require('./queries.json')
const database = require('./database')
const stories = require('./stories')

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

scoop.name = config.site.name;
scoop.sections = new sections(config.sections)
scoop.queries = queries
scoop.database = new database(config.database)
scoop.stories = new stories(scoop)

module.exports = scoop;