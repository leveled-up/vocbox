# VocBox Utility & Useful Functions
# (c) 2017 RunStorage Technologies
# ----------------------------------------

# Imports
filesystem = require 'fs'

# Read File to String
exports.file_get_contents = (file_path) ->
  filesystem.readFileSync file_path, "utf8"

# Make Page from Template
exports.tpl2html = (template_file, values) ->
  # Load Template File
  tpl = file_get_contents "./" + template_file + ".tpl"

  # Render it
  values.forEach (item, index) ->
    tpl_index = index +1
    tpl = tpl.replace "$" + new_index, item

  # Return
  return tpl
