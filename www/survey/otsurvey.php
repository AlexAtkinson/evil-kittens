<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Expires" content="0">
<meta name="Resource-Type" content="Document">
<meta name="Distribution" content="Global">
<meta name="Author" content="Alex Atkinson">
<meta name="Keywords" content="Office Technologies, Office Tech, ">
<meta name="Description" content="Office Technologies intranet home page.">
<meta name="Rating" content="General">
<meta name="Generator" content="HTML-Kit">
<link href="../css/survey.css" rel="stylesheet" type="text/css" />
<title>Office Technologies - Satisfaction Survey</title>
</head>
<body>
<div id="container">
	<div id="headerContainer">
		 <div id="headerLeft"></div>
		 <div id="headerRight"></div>
  </div>
	<div id="menuBar">
		 <div id="menuLeft">Office Technologies Satisfaction Survey</div>
		 <div id="menuRight">
		 <script type="text/javascript">
		 var monthNames = new Array( "January","February","March","April","May","June","July","August","September","October","November","December");
		 var now = new Date();
		 thisYear = now.getYear();
		 if(thisYear < 1900) {thisYear += 1900};
		 document.write(monthNames[now.getMonth()] + " " + now.getDate() + ", " + thisYear);
		 </script>
		 </div>
	</div>
	<div id="mainContainer">
  <div id="mainContent">

<?php
$a_date = date("Y-m-d");
?>
<form action="otsurvsub.php" method="post">
<input type="hidden" name="a_date" value="<?php print $a_date ?>">
<table align="center"><tr><td>
<div class="qDesc">Please rate your satisfaction with each of the following statements.</div>

<div class="allHead">
<div id="question_1" class="question" style="margin:0 0 0 0;">
<div class="qContent"><h3 class="qHeader">1. The skill and technical knowledge of the technician met or exceeded my expectations.</h3>
<div class="qBody">
<table cellspacing="0" cellpadding="0" border="0">
<tbody>
<tr class="rowone">
<th scope="row" align="left" width=110px;>Select One</th>
<td align="left"><div class="qOption">
<select name="question_1">
<option name="Skill and Knowledge"  value="6" />Extremely Satisfied</option>
<option name="Skill and Knowledge"  value="5" />Very Satisfied</option>
<option name="Skill and Knowledge"  value="4" />Satisfied</option>
<option name="Skill and Knowledge"  value="3" />Neutral</option>
<option name="Skill and Knowledge"  value="2" />Dissatisfied</option>
<option name="Skill and Knowledge"  value="1" />Very Dissatisfied</option>
<option name="Skill and Knowledge"  value="0" />Extremely Dissatisfied</option>
</select>
</div></td>
</tr></tbody></table>
</div></div></div></div>

<div class="allHead">
<div id="question_2" class="question" style="margin:0 0 0 0;">
<div class="qContent"><h3 class="qHeader">2. The issue was resolved to my expectations.</h3>
<div class="qBody">
<table cellspacing="0" cellpadding="0" border="0">
<tbody>
<tr class="rowone">
<th scope="row" align="left" width=110px;>Select One</th>
<td align="left"><div class="qOption">
<select name="question_2">
<option name="Resolve Satisfaction"  value="6" />Extremely Satisfied</option>
<option name="Resolve Satisfaction"  value="5" />Very Satisfied</option>
<option name="Resolve Satisfaction"  value="4" />Satisfied</option>
<option name="Resolve Satisfaction"  value="3" />Neutral</option>
<option name="Resolve Satisfaction"  value="2" />Dissatisfied</option>
<option name="Resolve Satisfaction"  value="1" />Very Dissatisfied</option>
<option name="Resolve Satisfaction"  value="0" />Extremely Dissatisfied</option>
</select>
</div></td>
</tr></tbody></table>
</div></div></div></div>

<div class="allHead">
<div id="question_3" class="question" style="margin:0 0 0 0;">
<div class="qContent"><h3 class="qHeader">3. Office Technologies responds to my requests in a timely fashion.</h3>
<div class="qBody">
<table cellspacing="0" cellpadding="0" border="0">
<tbody>
<tr class="rowOne">
<th scope="row" align="left" width=110px;>Select One</th>
<td align="left"><div class="qOption">
<select name="question_3">
<option name="Response Time"  value="6" />Extremely Satisfied</option>
<option name="Response Time"  value="5" />Very Satisfied</option>
<option name="Response Time"  value="4" />Satisfied</option>
<option name="Response Time"  value="3" />Neutral</option>
<option name="Response Time"  value="2" />Dissatisfied</option>
<option name="Response Time"  value="1" />Very Dissatisfied</option>
<option name="Response Time"  value="0" />Extremely Dissatisfied</option>
</select>
</div></td>
</tr></tbody></table>
</div></div></div></div>

<div class="allHead">
<div id="question_4" class="question" style="margin:0 0 0 0;">
<div class="qContent"><h3 class="qHeader">4. Office Technologies has a thorough overall understanding of the technologies I use on a daily basis.</h3>
<div class="qBody">
<table cellspacing="0" cellpadding="0" border="0">
<tbody>
<tr class="rowOne">
<th scope="row" align="left" width=110px;>Select One</th>
<td align="left"><div class="qOption">
<select name="question_4">
<option name="Understanding"  value="6" />Extremely Satisfied</option>
<option name="Understanding"  value="5" />Very Satisfied</option>
<option name="Understanding"  value="4" />Satisfied</option>
<option name="Understanding"  value="3" />Neutral</option>
<option name="Understanding"  value="2" />Dissatisfied</option>
<option name="Understanding"  value="1" />Very Dissatisfied</option>
<option name="Understanding"  value="0" />Extremely Dissatisfied</option>
</select>
</div></td>
</tr></tbody></table>
</div></div></div></div>

<div class="allHead">
<div id="question_5" class="question" style="margin:0 0 0 0;">
<div class="qContent"><h3 class="qHeader">5. I am confident Office Technologies will be able to resolve my issues.</h3>
<div class="qBody">
<table cellspacing="0" cellpadding="0" border="0">
<tbody>
<tr class="rowOne">
<th scope="row" align="left" width=110px;>Select One</th>
<td align="left"><div class="qOption">
<select name="question_5">
<option name="Client Confidence"  value="6" />Extremely Satisfied</option>
<option name="Client Confidence"  value="5" />Very Satisfied</option>
<option name="Client Confidence"  value="4" />Satisfied</option>
<option name="Client Confidence"  value="3" />Neutral</option>
<option name="Client Confidence"  value="2" />Dissatisfied</option>
<option name="Client Confidence"  value="1" />Very Dissatisfied</option>
<option name="Client Confidence"  value="0" />Extremely Dissatisfied</option>
</select>
</div></td>
</tr></tbody></table>
</div></div></div></div>

<div class="allHead">
<div id="question_6" class="question" style="margin:0 0 0 0;">
<div class="qContent"><h3 class="qHeader">6. Office Technologies treats me as a professional and with the respect I deserve.</h3>
<div class="qBody">
<table cellspacing="0" cellpadding="0" border="0">
<tbody>
<tr class="rowOne">
<th scope="row" align="left" width=110px;>Select One</th>
<td align="left"><div class="qOption">
<select name="question_6">
<option name="Respects Clients"  value="6" />Extremely Satisfied</option>
<option name="Respects Clients"  value="5" />Very Satisfied</option>
<option name="Respects Clients"  value="4" />Satisfied</option>
<option name="Respects Clients"  value="3" />Neutral</option>
<option name="Respects Clients"  value="2" />Dissatisfied</option>
<option name="Respects Clients"  value="1" />Very Dissatisfied</option>
<option name="Respects Clients"  value="0" />Extremely Dissatisfied</option>
</select>
</div></td>
</tr></tbody></table>
</div></div></div></div>

<div class="allHead">
<div id="question_7" class="question" style="margin:0 0 0 0;">
<div class="qContent"><h3 class="qHeader">7. Please feel free to submit any additional comments or concerns you have.</h3>
<div class="qBody">
<table cellspacing="0" cellpadding="0" border="0">
<textarea name="question_7" rows="7" cols="50">

</textarea>

</table>
</div></div></div></div>

<div id="finButton"> 
<table align="center" cellpadding="0" cellspacing="0" border="0"> 
<tr><td>&nbsp;&nbsp;&nbsp;
<input type="submit" name="btnSubmit" value="Submit" /><br /> 
<br /></td></tr></table>
</div>
</td></tr></table>
</form>
</div>
</div>
</div>
	
	
  </div>
  <div id="bottomSpacer"></div>
	</div>
</div>
</body>
</html>
