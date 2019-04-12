const scoop = require('../modules/scoop')
const sec = require('../modules/section')
const stories = require('../modules/stories')
module.exports = (req ,res) => {
    if (req.params.sectionId === "__all__") {
        scoop.section = new sec()
        scoop.section.sectionId = "__all__"
        scoop.section.title = "All Stories"
    } else {
        scoop.section = new sec()
        scoop.section = scoop.sections.getSection(req.params.sectionId)
        if (scoop.section.sectionid === "") {
            scoop.section = new sec()
            scoop.section.title = "Front Page"
        }
    }
    stories.GetStoryList('').then(values => {
        console.log(values)
        res.render('index.ejs',{scoop: scoop, storylist: values})
    
    })
}