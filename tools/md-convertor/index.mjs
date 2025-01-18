import { readFileSync, writeFileSync } from 'node:fs'
import { convert, returnInvalidMacros } from './converthtml.mjs'

const storyData = readFileSync('output/allStories.json')
const stories = JSON.parse(storyData)

stories.forEach((story) => {
  const introtext = convert(story.introtext)
  // console.log(story.introtext)
  // console.log(introtext)
  story.introtext = introtext

  const bodytext = convert(story.bodytext)
  // console.log(story.bodytext)
  // console.log(bodytext)
  story.bodytext = bodytext
})

console.log('Invalid macros follow')
console.log(returnInvalidMacros())

writeFileSync('output/myStoriesMD.json', JSON.stringify(stories))
