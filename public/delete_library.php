<?php
include("core/core.inc.php");

// Get Parameter
$id = $_GET["library"];
if(!is_numeric($id))
  exit("You must provide a numeric ID.");

// Database Query
$delete_library_query = query_library_delete($id, $user);
$delete_library = query($delete_library_query);

// Redirect Back
redirect("/");
