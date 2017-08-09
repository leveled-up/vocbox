# Index Handler

exports.app = (req, res) ->
  res.send "Hi from <code>index_handler</code>!" +
        "<script src=\"init.js\"></script><script src=\"auth.js\"></script>"
