# Index Handler

exports.app = (req, res) ->
  res.send "Hi from <code>index_handler</code>!" +
        "<script src=\"https://www.gstatic.com/firebasejs/4.2.0/firebase.js\"></script>"+
        "<script src=\"https://www.gstatic.com/firebasejs/4.2.0/firebase-app.js\"></script>"
        "<script src=\"https://www.gstatic.com/firebasejs/4.2.0/firebase-auth.js\"></script>"+
        "<script src=\"init.js\"></script><script src=\"auth.js\"></script>"
