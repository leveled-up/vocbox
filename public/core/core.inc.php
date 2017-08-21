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
if(!isset($_SESSION["user"]))
  redirect("/auth?redirect=$request_url_encoded");
$user = $_SESSION["user"];

// Connect Database
database_connect();
