// Generated by CoffeeScript 2.0.0-beta3
(function() {
  var ADD_MESSAGE_SQL, CREATE_TABLE_SQL, Pool, config, createTables, pool;

  ({Pool} = require('pg'));

  config = require('./config.json').database;

  pool = new Pool(config);

  CREATE_TABLE_SQL = 'CREATE TABLE IF NOT EXISTS public.message_history ( time TIMESTAMP, sender VARCHAR, content VARCHAR, level INT, match VARCHAR );';

  ADD_MESSAGE_SQL = 'INSERT INTO message_history VALUES (now(), $1::text, $2::text, $3, $4::text)';

  createTables = function() {
    return pool.query(CREATE_TABLE_SQL, function() {});
  };

  createTables();

  module.exports.saveMessage = function(sender, content, level, match, callback) {
    return pool.query(ADD_MESSAGE_SQL, [sender, content, level, match], function(err, result) {
      if (err) {
        console.log(err);
        return callback.call(this, null);
      } else {
        return callback.call(this, result);
      }
    });
  };

}).call(this);

//# sourceMappingURL=database.js.map
