const scoop = require("./scoop")
const Story = require("./story")
class StoryCollection {
    static async GetStoryList(section) {
        const rows = await scoop.database.RunQuery(scoop.queries.storylist)
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