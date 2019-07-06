{ Pool } = require 'pg'
config = require('./config.json').database
moment = require 'moment'

mycardPool = new Pool config.mycard
ygoproPool = new Pool config.ygopro

CREATE_TABLE_SQL = 'CREATE TABLE IF NOT EXISTS public.message_history (
    time TIMESTAMP,
    sender VARCHAR,
    content VARCHAR,
    level INT,
    match VARCHAR
);'

ADD_MESSAGE_SQL = 'INSERT INTO message_history VALUES ($1, $2::text, $3::text, $4::integer, $5::text, $6::text)'

createTables = ->
  ygoproPool.query CREATE_TABLE_SQL, ->
createTables()

module.exports.saveMessage = (sender, content, level, match, ip, callback) ->
  ygoproPool.query ADD_MESSAGE_SQL, [moment().format('YYYY-MM-DD HH:mm:ss'), sender, content, level, match, ip], (err, result) ->
    if err
      console.log err
      callback.call this, null
    else
      callback.call this, result

SEARCH_USER_IS_BANNED_SQL = 'SELECT * from user_ban_history where id = $1::integer and until > $2'
SEARCH_USER_ID = 'SELECT id from users where username = $1'

module.exports.queryBan = (user) ->
    id = await mycardPool.query SEARCH_USER_ID, [user]
    return [] unless id.rows
    id = id.rows[0].id
    res = await ygoproPool.query SEARCH_USER_IS_BANNED_SQL, [id, moment().format('YYYY-MM-DD HH:mm:ss')]
    res.rows