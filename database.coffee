{ Pool } = require 'pg'
config = require('./config.json').database

pool = new Pool config

CREATE_TABLE_SQL = 'CREATE TABLE IF NOT EXISTS public.message_history (
    time TIMESTAMP,
    sender VARCHAR,
    content VARCHAR,
    level INT,
    match VARCHAR
);'

ADD_MESSAGE_SQL = 'INSERT INTO message_history VALUES (now(), $1::text, $2::text, $3::integer, $4::text, $5::text)'

createTables = ->
  pool.query CREATE_TABLE_SQL, ->
createTables()

module.exports.saveMessage = (sender, content, level, match, ip, callback) ->
  pool.query ADD_MESSAGE_SQL, [sender, content, level, match, ip], (err, result) ->
    if err
      console.log err
      callback.call this, null
    else
      callback.call this, result