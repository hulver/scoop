const Section = require('../models/section')

class SectionCollection {
  constructor (sections) {
    this._sections = sections.map(element => {
      const x = new Section()
      x.title = element.title
      x.sectionid = element.sectionid
      x.story_view_roles = element.story_view_roles
      return x
    })
  }
  add (section) {
    this._sections.push(section)
  }
  getSection (sectionid) {
    let section = {}
    section = this._sections.find(x => x.sectionid === sectionid)
    if (typeof section === 'undefined') {
      section = new Section()
    }
    return section
  }
}

module.exports = SectionCollection
