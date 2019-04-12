const scoop = {}
const config = require('../../config/config.json')
const sections = require('./sections')
const queries = require('./queries.json')
const database = require('./database')

scoop.name = config.site.name;
scoop.sections = new sections(config.sections)
scoop.queries = queries
scoop.database = new database(config.database)

module.exports = scoop;