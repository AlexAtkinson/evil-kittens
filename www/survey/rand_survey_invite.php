<?php
//***START SURVEY INVITATION FUNCTIONS****************************************************************
$a_date = date("F d, Y");
// $tkt_client = Ticket User
// $kill_the_general = General
// $techid = Technician working on ticket
// $os_client = Users first name
// $client_email = Users email
// $otsurvey and $tkt_id = Ticket Number
// TROUBLESHOOTING
//    Set random number array to (1,1). This will generate an email for every ticket.
//    Change ($to = "$client_email";) to ($to = "your.email@email.com";) to send all invitations to you.
//    For issues with the General or the client name enter the variables in the body of the email to verify their values..

$kill_the_general = 'General';
if ($tkt_client == $kill_the_general){
} else {
if ($_POST['btnClose']) {
//PULL CLIENT INFO
require $_SERVER['DOCUMENT_ROOT'] . "/com/connect.inc.php";
require $_SERVER['DOCUMENT_ROOT'] . "/com/auth.inc.php";
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }
mysql_select_db("offtech", $con);

$techid = mysql_query("SELECT emp_tso, emp_firstname, emp_lastname from emp where emp_tso='$tkt_tso'");
while($row = mysql_fetch_array($techid))
{
$os_technician = $row['emp_firstname'] . " " . $row['emp_lastname'];
}
$os_clientid = mysql_query("SELECT emp_id, emp_firstname from emp where emp_id='$tkt_client'");
while($row2 = mysql_fetch_array($os_clientid))
{
$os_client = $row2['emp_firstname'];
}
//LINE BELOW - emp_id IS THE TICKET CLIENT TKT_CLIENT - USER YOUR EMP_ID FOR TROUBLESHOOTING
$c_email = mysql_query("SELECT emp_id, emp_email FROM emp where emp_id='$tkt_client'");
while($row = mysql_fetch_array($c_email))
{
$client_email = $row['emp_email'];
}
$otsurvey = $tkt_id;
//SURVEY INVITATION FUNCTIONS
//RANDOM NUMBER GENERATOR - (1, 5) = 20% (1, 10) = 10% ETC - USE (1, 1) FOR TROUBLESHOOTING - USE (2, 5) TO DISABLE
srand ((double) microtime( )*1000000);
$rand_n = rand(1,5);
if ($rand_n=="1"){
  $ots_start = mysql_query("insert into ot_survey (os_survey_id) values ('$tkt_id')");
  //SEND MAIL FUNCTION
  $to = "$client_email";
  $subject = "Office Technologies Satisfaction Survey";
  //EDIT THE BODY TO CHANGE THE INVITATION
  $body = "Dear $os_client,\n\nYou have been randomly selected to participate in the Office Technologies Satisfaction Survey in regards to ticket #$tkt_id, resolved on $a_date.\n\nThank you for your past and present feedback. It is actively utilized towards the improvement of our department and the services we provide to you. Your continuing participation in the survey is greatly appreciated.\n\nTo launch the survey, please use the link below.\n\nhttp://www.urltoticket.com DETAILS:\nTicket: $tkt_id\nDate: $a_date\nSubject: $tkt_subject\nTechnician: $os_technician\n\n\nRegards,\n\nOffice Technologies";
  $headers = "MINE-Version: 1.0\r\n";
  $headers .= "From: email@email.com\r\n";
  mail($to, $subject, $body, $headers);}
  mysql_close($con);
}
}
//***END SURVEY INVITATION FUNCTIONS********************************************************************
?>
