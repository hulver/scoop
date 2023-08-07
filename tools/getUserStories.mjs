import fs from 'fs/promises'
import saveData from './saveData.mjs'

const uid = 2

let rowCount = 0

await saveData.start()
try {
  const myStoryFile = await fs.open('output/myStories.json', 'w')
  try {
    console.log('Writing my stories')
    rowCount = await saveData.processMyStories(uid, myStoryFile)
  } finally {
    await myStoryFile.close()
  }
  console.log(`Wrote ${rowCount} entries total`)
  const myCommentsFile = await fs.open('output/myComments.json', 'w')
  try {
    console.log('Writing my comments')
    rowCount = await saveData.processMyComments(uid, myCommentsFile)
  } finally {
    await myCommentsFile.close()
  }
  console.log(`Wrote ${rowCount} entries total`)
  const myDMFile = await fs.open('output/myDMs.json', 'w')
  try {
    console.log('Writing my private messages')
    rowCount = await saveData.processMyDMs(uid, myDMFile)
  } finally {
    await myDMFile.close()
  }
  console.log(`Wrote ${rowCount} entries total`)
} finally {
  await saveData.end()
}
