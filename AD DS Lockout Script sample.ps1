# The following script emails the most recent Account Lockout Event
# Best used in conjuction with Event-Viewer (i.e create Task Scheduler to run based off Event trigger)

$AccountLockOutEvent = Get-EventLog -LogName "Security" -InstanceID 4740 -Newest 1
$LockedAccount = $($AccountLockOutEvent.ReplacementStrings[0]) 
$AccountLockOutEventTime = $AccountLockOutEvent.TimeGenerated.ToLongDateString() + " " + $AccountLockOutEvent.TimeGenerated.ToLongTimeString()
$AccountLockOutEventMessage = $AccountLockOutEvent.Message

if ( $LockedAccount -ne "Guest" )
{
    $messageParameters = @{ 
    Subject = "Account Locked Out: $LockedAccount" 
    Body = "Account $LockedAccount was locked out on $AccountLockOutEventTime.`n`nEvent Details:`n`n$AccountLockOutEventMessage"
    From = "lockout@company.com" 
    To = "it@company.com"
    SmtpServer = "exchangeserver" 
    } 
    Send-MailMessage @messageParameters
}