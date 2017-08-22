<?php
// Library Manager
include("core/core.inc.php");

// Read Parameter
$current_library = $_GET["library"];
if(!is_numeric($current_library))
  exit("Error 404: The library ID provided cannot exist.");

// Get Info from Database
$library_info_query = query_library_info($current_library, $user);
$library_info = query($library_info_query);
if(!isset($library_info["id"]))
  exit("Error 404: The library {$current_library} was not found this user.");

// If Data is Sent to Script from Add.js, Proccess it
if(isset($_GET["action:insert"])) {

  $insert = $_GET["action:insert"];
  $insert = json_decode($insert, true);
  if($insert[0] == "" or $insert[1] == "")
    exit("1");

  if(count($insert) > 3 or count($inser) < 2)
    exit("2");

  if(isset($insert[2]))
    if($insert[2] == "")
      unset($insert[2]);

  $insert_query = query_words_create($library_info["id"], $user, $insert);
  $insert_result = query($insert_query);

  // exit
  exit("0");
}

// Show Page
basic_template();
?>
<h2>Add words</h2>

<!-- Prepared HTML -->
<div id="add_" style="display: none;">

</div>

<!--<div class=\"col-sm-3\">
  <div class=\"panel panel-default\">
    <div class=\"panel-body\">
      <center>
        <h3>$info</h3>
        <span>$label</span>
      </center>
    </div>
  </div>
</div>-->

<!-- Scripts -->
<script>
  // Library ID for add.js
  var library_id;
  library_id = <?=$library_info["id"]?>;
</script>
<script src="/util.js"></script>
<script src="/add.js"></script>
