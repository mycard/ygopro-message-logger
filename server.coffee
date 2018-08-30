database = require './database'
express = require 'express'
bodyParser = require 'body-parser'
moment = require 'moment'

server = express()

server.use bodyParser.urlencoded { extended: false }

server.post '/', (req, res) ->
  sender = req.body.sender || '神秘骇客'
  level = req.body.level || 999
  content = req.body.content || '神秘消息'
  match = req.body.match || '神奇对决'
  ip = req.body.ip || '0.0.0.0'
  database.saveMessage sender, content, level, match, ip, (result) ->
    res.statusCode = if result then 200 else 500
    res.end 'ok'



server.get '/ban', (req, res) ->
  username = req.query.user || req.query.username || "神秘骇客"
  record = await database.queryBan req.query.user
  if record and record.length > 0
    res.json
      banned: true
      level: record[0].level
      until: moment(record[0].until).format()
  else res.json
    banned: false

server.listen 1984
