<?php
// VocBox Backend Include Script
// Include RSCORE
include("core/rscore.inc.php");

// get request info
$request_url = $_SERVER["REQUEST_URI"];
$request_url_encoded = urlencode($request_url);
$request_time = time();

// Check Session
session_start();
if($request_url == "/" and !isset($_SESSION["user"]))
  exit(file_get_contents("template/index.html"));
elseif(!isset($_SESSION["user"]))
  redirect("/auth?redirect=$request_url_encoded");
$user = (object)$_SESSION["user"];

// Connect Database
database_connect();
include("core/database.inc.php");

// Localization & Languages
include("core/languages.inc.php");

// Templates
$contact_us = "<a href=\"mailto:{$error_setup[mail_address]}\">contact us</a>";

function basic_template() {
  echo file_get_contents("template/basic.tpl");
}

// Greeting
$greetings = shuffle(array(
  "Howdy", "Hi", "Hello", "Hey", "Greetings"
));

function greeting() {
  echo $greetings[0];
}
