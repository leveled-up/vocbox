# Index Handler

exports.app = (req, res) ->
  res.send "Hi from <code>index_handler</code>!" +
        "<script src=\"/__/firebase/4.2.0/firebase-app.js\"></script>" +
        "<script src=\"/__/firebase/4.2.0/firebase-auth.js\"></script>"+
        "<script src=\"/__/firebase/init.js\"></script>" +
        "<script src=\"init.js\"></script><script src=\"auth.js\"></script>"
