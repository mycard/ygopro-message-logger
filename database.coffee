{ Pool } = require 'pg'
config = require('./config.json').database
moment = require 'moment'

pool = new Pool config

CREATE_TABLE_SQL = 'CREATE TABLE IF NOT EXISTS public.message_history (
    time TIMESTAMP,
    sender VARCHAR,
    content VARCHAR,
    level INT,
    match VARCHAR
);'

ADD_MESSAGE_SQL = 'INSERT INTO message_history VALUES ($1, $2::text, $3::text, $4::integer, $5::text, $6::text)'

createTables = ->
  pool.query CREATE_TABLE_SQL, ->
createTables()

module.exports.saveMessage = (sender, content, level, match, ip, callback) ->
  pool.query ADD_MESSAGE_SQL, [moment().format('YYYY-MM-DD HH:mm:ss'), sender, content, level, match, ip], (err, result) ->
    if err
      console.log err
      callback.call this, null
    else
      callback.call this, result