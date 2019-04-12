sec = require('./section')

class SectionCollection {
    constructor(sections){
        this._sections = sections.map(element => {
            let x = new sec()
            x.title = element.title;
            x.sectionid = element.sectionid
            x.view_roles = element.view_roles
            return x
        });
    }
    add(section) {
        _sections.push(section)
    }
    getSection(sectionid) {
        let section = {}
        section = this._sections.find(x => x.sectionid === sectionid)
        if (typeof section == "undefined")
        {
            section = new sec()
        }
        return section
    }
}

module.exports = SectionCollection