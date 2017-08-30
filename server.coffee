database = require './database'
express = require 'express'
bodyParser = require 'body-parser'

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

server.listen 1984
