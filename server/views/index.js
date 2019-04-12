const scoop = require('../modules/scoop')
module.exports = (req ,res) => {
    scoop.section = scoop.sections.getSection(req.params.sectionId)
    console.log(scoop)
    if (scoop.section.sectionid === "") {
        scoop.section.title = "Front Page"
    }
    res.render('index.ejs',{scoop: scoop})
}