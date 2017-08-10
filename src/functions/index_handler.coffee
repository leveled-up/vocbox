# Index Handler

exports.app = (req, res) ->
  values = [
    "Home",
    "<section class=\"page-header\">
      <h1 class=\"project-name\">Test</h1>
      <h2 class=\"project-tagline\">Hello world!</h2>
    </section>",
    ""
  ]
  res.send util.tpl2html "index", values
