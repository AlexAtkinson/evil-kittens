<?php
header("Content-Type:  application/vnd.ms-excel");
header("Expires: 0");
header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
require $_SERVER['DOCUMENT_ROOT'] . "/com/connect.inc.php";
require $_SERVER['DOCUMENT_ROOT'] . "/com/auth.inc.php";
mysql_select_db("offtech", $con);
$query="SELECT * FROM offtech.ot_survey ORDER BY os_date;";
$result = mysql_query($query);
$result_q1 = mysql_query("SELECT avg(os_question_1) FROM offtech.ot_survey ORDER BY os_date;");
while ($q1_avger = mysql_fetch_array ($result_q1)) {$q1_avg = $q1_avger[0];}
$result_q2 = mysql_query("SELECT avg(os_question_2) FROM offtech.ot_survey ORDER BY os_date;");
while ($q2_avger = mysql_fetch_array ($result_q2)) {$q2_avg = $q2_avger[0];}
$result_q3 = mysql_query("SELECT avg(os_question_3) FROM offtech.ot_survey ORDER BY os_date;");
while ($q3_avger = mysql_fetch_array ($result_q3)) {$q3_avg = $q3_avger[0];}
$result_q4 = mysql_query("SELECT avg(os_question_4) FROM offtech.ot_survey ORDER BY os_date;");
while ($q4_avger = mysql_fetch_array ($result_q4)) {$q4_avg = $q4_avger[0];}
$result_q5 = mysql_query("SELECT avg(os_question_5) FROM offtech.ot_survey ORDER BY os_date;");
while ($q5_avger = mysql_fetch_array ($result_q5)) {$q5_avg = $q5_avger[0];}
$result_q6 = mysql_query("SELECT avg(os_question_6) FROM offtech.ot_survey ORDER BY os_date;");
while ($q6_avger = mysql_fetch_array ($result_q6)) {$q6_avg = $q6_avger[0];}
$result_overall = mysql_query("SELECT avg(os_question_6) FROM offtech.ot_survey ORDER BY os_date;");
$qs_add = ($q1_avg + $q2_avg + $q3_avg + $q4_avg + $q5_avg + $q6_avg);
while ($qs_adder = mysql_fetch_array ($qs_add)) {$qs_avg = $qs_adder[0];}
$qs_avgraw = ($qs_add / 6);
$qs_avg = round($qs_avgraw, 2);
$qs_avgpercentraw = ($qs_avgraw / 6 * 100);
$qs_avgpercent = round($qs_avgpercentraw, 2);
$qs_goalraw = ($qs_avg + ((6 - $qs_avgraw) *.05));
$qs_goal = round($qs_goalraw, 2);
$qs_goalpercentraw = ($qs_goalraw / 6 * 100);
$qs_goalpercent = round($qs_goalpercentraw, 2);
echo "<table border=\"0\">";
echo "<tr><td><table border=\"3\"><tr><td colspan=10 bgcolor=bcc62e align=center><font size=4 style=bold>Office Technologies Satisfaction Survey Results - Full";
echo "</font></td></tr></table></td></tr>";
echo "<table border=\"1\">";
echo "<tr>
<td bgcolor=#cccccc align=left valign=top><strong>ID</strong></td><td bgcolor=#cccccc align=left><strong>Date</strong></td>
<td bgcolor=#cccccc align=left><strong>Question 1</strong></td><td bgcolor=#cccccc align=left><strong>Question 2</strong></td>
<td bgcolor=#cccccc align=left><strong>Question 3</strong></td><td bgcolor=#cccccc align=left><strong>Question 4</strong></td>
<td bgcolor=#cccccc align=left><strong>Question 5</strong></td><td bgcolor=#cccccc align=left><strong>Question 6</strong></td>
<td bgcolor=#cccccc align=left><strong>Question 7</strong><td bgcolor=#cccccc align=left><strong>Ticket</strong></td></tr>";
$j=true;
while ($row = mysql_fetch_row($result))
{
if($j)
$j=false;
else 
$j=true;        
echo "<tr>";
for ($i=0;$i<mysql_num_fields($result);$i++){
if ($j){
echo "<td align=left valign=top bgcolor=\"#CCCCCC\">";
}
if (!$j){
echo "<td align=left valign=top bgcolor=\"#EEEEEE\">";
}
echo $row[$i];
echo "</td>";
}
}
echo "</table>";
echo "<table border=\"0\">";
echo "<tr></tr>";
echo "</table>";
echo "<table border=\"1\">";
echo "<tr>
<td bgcolor=#cccccc colspan=2 valign=top><strong>Averages and Goals</td></tr>";
echo "</table>";
echo "<table border=\"1\">";
echo "<tr>
<td align=left><strong>Question 1</strong></td><td align=left><strong>Question 2</strong></td>
<td align=left><strong>Question 3</strong></td><td align=left><strong>Question 4</strong></td>
<td align=left><strong>Question 5</strong></td><td align=left><strong>Question 6</strong></td>
<td align=left><strong>Overall</strong></td><td align=left><strong>Goal</strong></td></tr>";
echo "<tr>
<td align=left>$q1_avg</td><td align=left>$q2_avg</td>
<td align=left>$q3_avg</td><td align=left>$q4_avg</td>
<td align=left>$q5_avg</td><td align=left>$q6_avg</td>
<td align=left>$qs_avg ($qs_avgpercent%)</td><td align=left>$qs_goal ($qs_goalpercent%)</td>
</tr>";
echo "</table>";
echo "<table border=\"0\">";
echo "<tr></tr>";
echo "</table>";
echo "<table border=\"1\">";
echo "<tr><td bgcolor=#cccccc colspan=2 valign=top><strong>Question Summary</td></tr>";
echo "</table>";
echo "<table border=\"1\">";
echo "<tr><td valign=top>Question 1</td><td colspan=9 align=left valign=top>The skill and technical knowledge of the technician met or exceeded my expectations.</td></tr>";
echo "<tr><td valign=top>Question 2</td><td colspan=9 align=left valign=top>The issue was resolved to my expectations.</td></tr>";
echo "<tr><td valign=top>Question 3</td><td colspan=9 align=left valign=top>Office Technologies responds to my requests in a timely fashion.</td></tr>";
echo "<tr><td valign=top>Question 4</td><td colspan=9 align=left valign=top>Office Technologies has a thorough overall understanding of the technologies I use on a daily basis.</td></tr>";
echo "<tr><td valign=top>Question 5</td><td colspan=9 align=left valign=top>I am confident Office Technologies will be able to resolve my issues.</td></tr>";
echo "<tr><td valign=top>Question 6</td><td colspan=9 align=left valign=top>Office Technologies treats me as a professional and with the respect I deserve.</td></tr>";
echo "<tr><td valign=top>Question 7</td><td colspan=9 align=left valign=top>Please feel free to submit any additional comments or concerns you have.</td></tr>";
echo "</table>";
mysql_close($db1);
?>