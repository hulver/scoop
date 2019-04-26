const scoop = {}
const config = require('../../config/config.json')
const sections = require('./sections')
const queries = require('./queries.json')
const database = require('./database')
const stories = require('./stories')

scoop.name = config.site.name;
scoop.sections = new sections(config.sections)
scoop.queries = queries
scoop.database = new database(config.database)
scoop.stories = new stories(scoop)

module.exports = scoop;