const scoop = require('../modules/scoop')
const Section = require('../modules/section')
module.exports = (req, res) => {
  if (req.params.sectionId === '__all__') {
    scoop.section = new Section()
    scoop.section.sectionId = '__all__'
    scoop.section.title = 'All Stories'
  } else {
    scoop.section = new Section()
    scoop.section = scoop.sections.getSection(req.params.sectionId)
    if (scoop.section.sectionid === '') {
      scoop.section = new Section()
      scoop.section.title = 'Front Page'
    }
  }
  scoop.stories.getStoryList('').then(values => {
    console.log(values)
    res.render('index.ejs', { scoop: scoop, storylist: values })
  })
}
