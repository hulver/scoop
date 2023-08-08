import exportData from './exportData.mjs'

const uid = 2

let rowCount = 0

await exportData.start()
try {
  console.log('Writing my stories')
  rowCount = await exportData.processMyStories(uid, 'output/myStories.json')
  console.log(`Wrote ${rowCount} entries total`)
  console.log('Writing my comments')
  rowCount = await exportData.processMyComments(uid, 'output/myComments.json')
  console.log(`Wrote ${rowCount} entries total`)
  console.log('Writing my private messages')
  rowCount = await exportData.processMyDMs(uid, 'output/myDMs.json')
  console.log(`Wrote ${rowCount} entries total`)
} finally {
  await exportData.end()
}
