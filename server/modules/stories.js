const scoop = require("./scoop")
const Story = require("./story")
class StoryCollection {
    constructor (scoop) {
        this.scoop = scoop;
    }
    async GetStoryList(section) {
        const rows = await this.scoop.database.RunQuery(this.scoop.queries.storylist)
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