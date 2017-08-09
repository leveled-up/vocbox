# VocBox Utility & Useful Functions
# (c) 2017 RunStorage Technologies
# ----------------------------------------

# Imports
filesystem = require 'fs'

# Read File to String
exports.file_get_contents = (file_path) ->
  filesystem.readFileSync file_path, "utf8"
