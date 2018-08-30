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

SEARCH_USER_IS_BANNED_SQL = 'SELECT * from user_ban_history where username = $1::text and until > $2'

module.exports.queryBan = (user) ->
    res = await pool.query SEARCH_USER_IS_BANNED_SQL, [user, moment().format('YYYY-MM-DD HH:mm:ss')]
    res.rows