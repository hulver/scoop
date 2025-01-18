import { processExport, start, end } from './saveData.mjs'

await start()

try {
  const exportSql = 'select uid, passwd from users where perm_group in ("Permanent TU", "Superuser", "Users", "Editors", "Subscribers", "Gold_Subscribers", "no_ip_users", "New_users");'
  const rowcount = await processExport(exportSql, 0, false, 'output/userPwHash.json')
  console.log(rowcount)
} finally {
  await end()
}
