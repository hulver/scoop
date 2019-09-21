const Story = require("../models/story")
const queries = require('./queries.json')
class StoryCollection {
    constructor (database) {
        this.database = database;
    }
    async GetStoryList(section) {
        const rows = await this.database.RunQuery(queries.storylist)
        const result = rows.map(element => {
            let _story = new Story()
            _story.sid = element.sid
            _story.aid = element.aid
            _story.title = element.title
            return _story
        })
        return result
    }
}

module.exports = StoryCollection