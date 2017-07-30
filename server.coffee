database = require './database'
express = require 'express'
bodyParser = require 'body-parser'

server = express()

jsonParser = bodyParser.json()

server.post '/', jsonParser, (req, res) ->
  sender = req.body.sender || '神秘骇客'
  level = req.body.level || 999
  content = req.body.content || '神秘消息'
  match = req.body.match || '神奇对决'
  database.saveMessage sender, content, level, match, (result) ->
    res.statusCode = if result then 200 else 500
    res.end 'ok'

server.listen 1984