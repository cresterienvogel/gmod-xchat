<?php
include_once("../cfg.php");


if ($language == "polish") {
include_once("polish.php");
} elseif ($language == "german") {
include_once("german.php");
} elseif ($language == "english") {
include_once("english.php");
}
?>