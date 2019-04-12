const config = require('./config/config.json')
const bodyParser = require('body-parser')
const express = require('express')
const session = require('express-session')
const app = express()

app.set('views','./server/views')

app.use(bodyParser.urlencoded({extended: false}))
app.use(express.static('./server/public'))
app.use(session(config.session))

app.get('/', require('./server/views/index'))
app.get('/section/:sectionName', require('./server/views/index'))

app.listen(config.server.port)

module.exports = app
