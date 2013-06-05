<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<?php
require $_SERVER['DOCUMENT_ROOT'] . "/com/connect.inc.php";
require $_SERVER['DOCUMENT_ROOT'] . "/com/auth.inc.php";
$sql="INSERT INTO ot_survey (date, question_1, question_2, question_3, question_4, question_5, question_6, question_7)
VALUES
('$_POST[a_date]','$_POST[question_1]','$_POST[question_2]','$_POST[question_3]','$_POST[question_4]','$_POST[question_5]','$_POST[question_6]','$_POST[question_7]')";
if (!mysql_query($sql,$con))
  {
  die('Error: ' . mysql_error());
  }
mysql_close($con)
?>
<html>
<head>
<title>Office Technologies Client Satisfaction Questionnaire</title>
<style tyle="text/css">
<!--
body {background:#ffffff;margin:0px;padding:0px;}
.qOption {position:relative;width:99%;}
TR.rowTwo {background:#ffffff;}
TR.rowOne {background:#bcc62e;}
.allHead{margin:5px;padding:5px; margin-left:10px}
.conTitle {background-color:#bcc62e;padding:0px;margin:0px;width:100%;}
.bigTitle {background-color:#490a04;padding:0px;margin:0px;width:100%;}
.bigTitle div {float:left;padding:0px 10px; font:large Arial,sans-serif;text-decoration:none;color:#ffffff;}
.conTitle h2 {float:left;margin:0px;padding:5px 10px;font: bold medium Arial,sans-serif;text-decoration:none;color:#333333;}
.bigTitle .topExit, .conTitle .topExit {float:right;padding:3px 7px 3px 3px;}
br.full {height:0px;width:0px;line-height:0px;overflow:hidden;clear:both;}
.qDesc {margin-bottom:10px; padding:10px; font:medium Arial,sans-serif;text-decoration:none;color:#000000;}
.qHeader {margin-bottom:5px; font: bold small/1.4 Arial,sans-serif;text-decoration:none;color:#000000;}
h3 {margin:0px;}
.qBody, .qBody td, .qBody th, input.open, textarea.open {font:small/1.5 Arial,sans-serif;text-decoration:none;color:#000000;}
.qContent {margin-bottom:25px; margin-left:16.5px;}
.qOption label {display:block;cursor:pointer;padding:4px;}
.qOption {padding:0px;border:1px solid #ffffff;margin-right:4px;cursor:pointer;}
div.selected label {outline:1px dotted #000000;}
.rowOne .qOption, .rowTwo .qOption {border:0;padding:3px;width:auto;}
.rowTwo div label, .rowOne div label {margin:0px;padding:2px;}
.rowTwo .rowOne {outline:1px dotted #000000;}
.qOption .qLabel {margin:0px;padding:0px;}
.rowOne .qLabel, .rowTwo .qLabel {position:absolute;width:0px;height:0px;line-height:0px;overflow:hidden;left:-5000px;}
.rowTwo th, .rowOne th {padding-left:4px;}
.topExit {padding:3px;padding-right:10px;font: bold small Arial,sans-serif;text-decoration:underline;color:#ffffff;}
-->
</style>
</head>
<body>

<div>
<div><div class="bigTitle"><div>Broadridge</div>
<a class="topExit" target="_self" href="#" onclick="window.close();">Exit</a>&nbsp;<br class="full" />
</div>

<div class="conTitle"><h2>Client Satisfaction Questionnaire</h2>&nbsp;<br class="full" /></div>
<div class="qContent">
<p align="center">
<br />
<br />
Thank You 
<br />
</p> 
</div>
</body>
</html>