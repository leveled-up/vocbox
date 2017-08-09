# VocBox Utility & Useful Functions
# (c) 2017 RunStorage Technologies
# ----------------------------------------

# Read File to String
file_get_contents = (file_path) ->
  fs.readFileSync file_path, "utf8"
