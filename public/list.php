<?php
// List Words Handler for library.js
include("core/core.inc.php");

// Read Parameter
$current_library = $_GET["library"];
if(!is_numeric($current_library))
  exit("Error 404: The library ID provided cannot exist.");

// Get Words from Database
$words_list_query = query_words_list($current_library, $user);
$words_list = query($words_list_query, false);

if(count($words_list) < 1)
  exit("
  <tr>
    <td>No words found.</td>
    <td></td>
    <td></td>
    <td></td>
  </tr>");

foreach ($words_list as $word)
  echo "
    <tr>
      <td>".htmlentities($word["word_f"])."".(json_decode($word["info"], true)["comment"] != "" ? "&nbsp; <i class=\"fa fa-exclamation-circle\"></i>" : "")."</td>
      <td>".htmlentities($word["word_m"])."</td>
      <td>".($word["category"] > 1? round($word["category"]/2):$word["category"])."</td>
      <td>
        <span id=\"info_{$word[id]}\" style=\"display:none;\">".json_encode(array(
                        // workaround double-submit
                        "category" => ($word["category"] > 1? round($word["category"]/2):$word["category"]),
                        "info" => json_decode($word["info"]) ))."
        </span>
        <div class=\"btn-group btn-group-xs\">
          <a href=\"#info_{$word[id]}\" id=\"btn_info_{$word[id]}\" onclick=\"return btn_info_word_click('{$word[id]}');\" class=\"btn btn-default\">
            <i class=\"fa fa-info\"></i>
          </a>
          <a href=\"#info_{$word[id]}\" onclick=\"speech_synthesis('".addslashes($word["word_f"])."', forein_lang[1], function(){}); return false;\" class=\"btn btn-default\">
            <i class=\"fa fa-volume-up\"></i>
          </a>
          <a href=\"/delete_word?word={$word[id]}&library=$current_library\" id=\"btn_delete_word_{$word[id]}\" onclick=\"return btn_delete_word_click('{$word[id]}');\" class=\"btn btn-danger\">
            <i class=\"fa fa-times\"></i>
          </a>
        </div>
      </td>
    </tr>";
