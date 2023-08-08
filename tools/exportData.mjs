import { processExport, start, end } from './saveData.mjs'

const thisStart = async () => {
  await start()
}

const thisEnd = async () => {
  await end()
}

export const myStorySql = 'SELECT sid,u.nickname as author,title,time,introtext,bodytext,displaystatus,commentstatus FROM stories s INNER JOIN users u ON s.aid = u.uid WHERE aid = ? ORDER BY time DESC'
export const myCommentSql = 'SELECT sid,cid,pid,u.nickname as user,date,subject,comment,points,sig_status,sig FROM comments c INNER JOIN users u ON c.uid = u.uid WHERE c.uid = ? ORDER BY date DESC'
export const myDMsSqlSent = 'SELECT message_id, u1.nickname as from_nick, u2.nickname as to_nick, sent_date, subject, message, "0" as msg_read, "0" as inbox_delete, sent_delete FROM private_message pm INNER JOIN users u1 on pm.from_uid = u1.uid INNER JOIN users u2 on pm.to_uid = u2.uid WHERE pm.from_uid = ? ORDER BY sent_date DESC'
export const myDMsSqlGot = 'SELECT message_id, u1.nickname as from_nick, u2.nickname as to_nick, sent_date, subject, message, msg_read, inbox_delete, "0" as sent_delete FROM private_message pm INNER JOIN users u1 on pm.from_uid = u1.uid INNER JOIN users u2 on pm.to_uid = u2.uid WHERE pm.to_uid = ? ORDER BY sent_date DESC'

const processMyStories = async (uid, outputFileName) => {
  return await processExport(myStorySql, uid, true, outputFileName)
}
const processMyComments = async (uid, outputFileName) => {
  return await processExport(myCommentSql, uid, true, outputFileName)
}
const processMyDMs = async (uid, outputFileName) => {
  return await processExport([myDMsSqlGot, myDMsSqlSent], uid, false, outputFileName)
}

const saveData = {
  start,
  end,
  processMyStories,
  processMyComments,
  processMyDMs
}

export { thisStart as start, thisEnd as end, processMyStories, processMyComments, processMyDMs }

export default saveData
