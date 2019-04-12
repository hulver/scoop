const scoop = {}
const config = require('../../config/config.json')
const sections = require('./sections')

scoop.name = config.site.name;
scoop.sections = new sections(config.sections)

module.exports = scoop;