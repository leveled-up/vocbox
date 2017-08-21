# Main.js Client Script
console.log "Init main.js"
console.warn "For VocBox to work Properly, Further Includes are Required."
console.warn "Some features require a WebKit browser."

# Libraries
# Deletion of a Library
confirm_library_deletion = () ->
  console.log "User is about to delete an entire library"
  confirm_text = "This library will be deleted. It can't be restored."
  result = confirm confirm_text
  console.warn "User deleting libary"
  return result
