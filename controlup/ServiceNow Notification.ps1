# ************************
# CREATE SERVICENOW TICKET
# ************************

# ServiceNow Instance and Credentials
# Update the arguments ([n]) with the corresponding argument from the Arguments tab in CU (best practice)
# Or you can replace the $args[n] part with the correct ServiceNow information (instance ID, username and password)
$SNinstance = $args[n]
$SNuser = $args[n]
$SNpassword = $args[n]

# Build auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SNuser, $SNpassword)))

# Set ServiceNow API Call headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Content-Type','application/json')

# Create the body for the ServiceNow API Call
# This uses the output from the ALD section and formats it for use
$DomainUser = $args[0]
$domain,$caller = $DomainUser.split('\')

# This requires the $Output parameter to be defined
# Since this script originates from a different script, the $output was the output from the Analyze Logon Duration script
# 
$SNdescription = ($Output | Out-String | ConvertTo-Json)
$body = "{ 'short_description':'Logon Duration threshold exceeded at $($Output[0].Split([Environment]::NewLine)[-1].split(":")[-1])', 'caller_id':'$caller', 'cmdb_ci':'$($env:computername)', 'description':$SNdescription}"

# Sample line
# $body = "{ 'short_description':'Description for ticket', 'caller_id':'joels', 'description':'Details for ticket'}"
    
# Specify endpoint uri
$uri = "https://$SNinstance.service-now.com/api/now/table/incident"
	
# Specify HTTP method
$method = "POST"

# API Call
$SNresponse = Invoke-RestMethod -Headers $headers -ContentType "application/json" -Method $method -Uri $uri -Body $body 

# Store Incident ID and URL
# Only needed if you want to expand the script with for example a Slack notification
# $IncidentNumber = $SNresponse.result.number
# $SystemID = $SNresponse.result.sys_id
# $IncidentURL = "https://$sninstance.service-now.com/incident.do?sys_id=$SystemID"
