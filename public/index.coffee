# Index.js (Client Script for /index.php)
console.log "Init index.js"

# Deletion of a Library
confirm_library_deletion = () ->
  console.log "User is about to delete an entire library"
  confirm_text = "This library will be deleted. It can't be restored."
  result = confirm confirm_text
  console.warn "User deleting libary" if result
  return result
