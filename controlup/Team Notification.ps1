# Work In Progress

# Teams Notification
$TeamsIncomingWebhookUri = $args[5]
$UserFullName = $args[6]
[int]$TotalLogonInSecs = $args[7]

$teamsbody = @"
{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "themeColor": "FF0000",
    "summary": "New Excessive Logon Time Event",
    "sections": [{
        "activityTitle": "Excessive Logon Duration",
        "activitySubtitle": "User Experience Event Notification",
        "facts": [{
            "name": "User",
            "value": "$caller ($UserFullName)"
        }, {
            "name": "Logon duration",
            "value": "$TotalLogonInSecs seconds"
        }, {
            "name": "ServiceNow Ticket",
            "value": "Ticket $IncidentNumber has been created"
        }],
        "markdown": true
    }],
  "potentialAction": [
    {
      "@type": "OpenUri",
      "name": "View Ticket",
      "targets": [
        { "os": "default", "uri": "$IncidentURL" }
      ]
    }
  ]
}
"@


# This section will send the API call using Powershell to Slack and Slack will process the request and send the notification
Invoke-RestMethod -uri $TeamsIncomingWebhookUri -Method Post -body $teamsbody -ContentType 'application/json'

