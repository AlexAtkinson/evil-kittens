<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<script language="javascript" src="ots_calendarPopup.js"></script>
<script language="javascript">
	document.write(getCalendarStyles());
	var cal1 = new CalendarPopup("ots_reportcal");
</script>
<title>Office Technologies Satisfaction Survey - Reporting</title>
<style tyle="text/css">
<!--
body {background:#ffffff;margin:0px;padding:0px;}
.qOption {position:relative;width:99%;}
TR.rowTwo {background:#ffffff;}
TR.rowOne {background:#ffffff;}
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
.qBody, .qBody td, .qBody th, input.open, textarea.open {margin-left:50px;font:small/1.5 Arial,sans-serif;text-decoration:none;color:#000000;}
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
<!-- THIS SCRIPT SUPPORTS DROPDOWN MENUS -->
<SCRIPT TYPE="text/javascript">
<!--
function dropdown(mySel)
{
var myWin, myVal;
myVal = mySel.options[mySel.selectedIndex].value;
if(myVal)
   {
   if(mySel.form.target)myWin = parent[mySel.form.target];
   else myWin = window;
   if (! myWin) return true;
   myWin.location = myVal;
   }
return false;
}
//-->
</SCRIPT>
<script language="javascript"> 
function toggle() {
	var ele = document.getElementById("customReport");
	var text = document.getElementById("displayText");
	if(ele.style.display == "block") {
    		ele.style.display = "none";
		text.innerHTML = "Show Custom";
  	}
	else {
		ele.style.display = "block";
		text.innerHTML = "Hide Custom";
	}
} 
</script>
</head>

<body>
<div>
<div><div class="bigTitle"><div>Broadridge</div>
<a class="topExit" target="_self" href="#" onclick="window.close();">Exit</a>&nbsp;<br class="full" />
</div>
<div class="conTitle"><h2>Office Technologies Satisfaction Survey - Reporting</h2>&nbsp;<br class="full" /></div>
<table align="center" width="700px">
<tr><td><br>
<div class="qDesc">Please select a report:<p />

<!-- THIS DROPDOWN MENU REQUIRES THE JAVASCRIPT FROM INSIDE THE HEADER -->
<form 
     action="../cgi-bin/redirect.pl" 
     method=post onsubmit="return dropdown(this.gourl)">
<select name="gourl">
<option value="">-
<option value="http://www3.toronto.bis.adp.com/offtech/ots_report_full.php/ots_report_full.xls">Full
<option value="http://www3.toronto.bis.adp.com/offtech/ots_report_thismonth.php/ots_report_thismonth.xls">Current Month
<!-- <option onclick=document.getElementById("ost_report_custom")>Custom-->
<option id="displayText" value="javascript:toggle();"><a id="displayText" href="javascript:toggle();">Show Custom</a>
</select>
<input type=submit value="Go">
</div></form>
<div id="customReport" style="display: none" class="qDesc">
<table>
<form name="customReportform" action="ots_report_custom.php/ots_report_custom.xls" method="post">
<tr><td colspan=2>This report allows you to view survey results for a specific date range.</td></tr>
<tr><td> </td></tr>
<tr><td>From:</td><td>To:</td></tr>
<tr>
<td width="200" align="left" valign="top">
<input maxlength="10" size="10" name="startDate" type="text" id="startDate" value="YYYY-MM-DD">&nbsp; <img align=absmiddle src=images/ots_reportCalendar.jpg style="cursor:hand" NAME="anchor_p" ID="anchor_p"
				onClick="cal1.select(document.customReportform.startDate,'anchor_p','yyyy-MM-dd'); return false;"></td>
<td align="left">
<input maxlength="10" size="10" name="endDate" type="text" id="endDate" value="YYYY-MM-DD">&nbsp; <img align=absmiddle src=images/ots_reportCalendar.jpg style="cursor:hand" NAME="anchor_w" ID="anchor_w"
				onClick="cal1.select(document.customReportform.endDate,'anchor_w','yyyy-MM-dd'); return false;"></td>
</tr>
<tr><td><input type="submit" name="customSub" value="Submit" /></td></tr></table>
</div>
</table>
</div></div></div></div>

<br /></td></tr></table>
</div>
</td></tr></table>
<DIV ID="ots_reportcal" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;"></DIV>
</body> 
</html>