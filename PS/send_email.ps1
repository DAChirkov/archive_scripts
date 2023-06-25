$Username = "";
$Password = "";
$date = Get-Date -UFormat "%d/%m/%Y_%R";
$checkpoint = "";

function Send-ToEmail([string]$email){
    $message = new-object Net.Mail.MailMessage;
    $message.From = "";
    $message.To.Add($email);
    $message.Subject = "Check_Email_$date";
    $message.Body = "Check_Email_$date";
    $smtp = new-object Net.Mail.SmtpClient("", "588");
    $smtp.EnableSSL = $false;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
 }

      Send-ToEmail -email "" -wait