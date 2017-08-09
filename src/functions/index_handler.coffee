# Index Handler

exports.app = (req, res) ->
  console.log "Triggered index.app"
  res.send "Hi from <code>index_handler</code>!"
