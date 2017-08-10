# Index Handler

exports.app = (req, res) ->
  values = [
    "Home",
    "<section class="page-header">
      <h1 class="project-name">RunStorage Support</h1>
      <h2 class="project-tagline">On this page we are guiding you through all features of the different RunStorage products.</h2>
    </section>",
    ""
  ]
  res.send util.tpl2html "index", values
