<?php
// Language & Localization Module
$languages_supported = array("en", "de", "fr", "es", "it");
$languages_supported_text = array(
  "en" => "English",
  "de" => "German",
  "fr" => "French",
  "es" => "Spanish",
  "it" => "Italian"
 );

// Return all Supported Languages as Codes
function languages_supported() {

  global $languages_supported;
  return $languages_supported;
}

// Return all Supported Languages as Text
function languages_supported_text() {

  global $languages_supported_text;
  return $languages_supported_text;
}

// Return a Language Name from Code
function language_code_to_text($code) {

  global $languages_supported_text;

  if(isset($languages_supported_text[$code]))
    return $languages_supported_text[$code];
  else
    return false;
}

// Returns Text from Language Pair Array or String
function language_pair_to_text($pair) {

  global $languages_supported_text;

  if(gettype($pair) != "array" and gettype($pair) == "string")
    $pair = explode("-", $pair);
  elseif(gettype($pair) != "array" and gettype($pair) != "string")
    return false;

  foreach($pair as $value)
    if(isset($languages_supported_text[$value]))
      $result[] = $languages_supported_text[$value];
    else
      return false;

  return join(" - ", $result);

}
