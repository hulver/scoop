import saveData from './saveData.mjs'

const uid = 2

let rowCount = 0

await saveData.start()
try {
  console.log('Writing my stories')
  rowCount = await saveData.processMyStories(uid, 'output/myStories.json')
  console.log(`Wrote ${rowCount} entries total`)
  console.log('Writing my comments')
  rowCount = await saveData.processMyComments(uid, 'output/myComments.json')
  console.log(`Wrote ${rowCount} entries total`)
  console.log('Writing my private messages')
  rowCount = await saveData.processMyDMs(uid, 'output/myDMs.json')
  console.log(`Wrote ${rowCount} entries total`)
} finally {
  await saveData.end()
}
