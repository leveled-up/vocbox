<?php
// Delete Word
include("core/core.inc.php");

// Get Parameter
$library = $_GET["library"];
if(!is_numeric($library))
  exit("You must provide a numeric library ID.");

$id = $_GET["word"];
if(!is_numeric($id))
  exit("You must provide a numeric word ID.");

// Database Query
$delete_word_query = query_words_delete($library, $user, $id);
$delete_word = query($delete_word_query);

// Redirect Back
redirect("/library/$library");
