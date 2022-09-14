#az login and set Sunscription if it's not set

#az account set --subscription ""
#az account show

#Set Tags Variables and Values
$createdBy= "Manually Created (Old Resource)"
$managedBy= "Dirico DevOps Team"
$environment = "Prod"
$lastUpdatedOn= (Get-Date).ToUniversalTime().ToString('dd-MM-yyyy HH:mm:ss UTC')
$colorBand= "Green"

#to get all resources Ids and store in an array
$groups=$(az resource list --query [].id --output tsv)

#Set some variables to support the execution
$Count=0
$tags = $null

#Set an array for those resources which you don't wanna tag
$arrayExclude = @("actiongroups", "domainNames", "extensions", "reservedIps", "networkWatchers","activityLogAlerts","restorePointCollections", "smartDetectorAlertRules", "certificates", "autoscalesettings", "metricalerts","scheduledqueryrules", "solutions")

#loop through all resources and tag those resources which don't have any tags
foreach ($resource in $groups)
{
   $exclude = $resource.split("/")[7]
   $tags=az tag list --resource-id $resource --output json | ConvertFrom-Json
   if  (!($tags.properties.tags -ne $null)-and !($arrayExclude -contains $exclude))
   {
   az tag create --resource-id $resource --tags CreatedBy=$createdBy ManagedBy=$managedBy Environment=$environment LastUpdatedOn=$lastUpdatedOn ColorBand=$colorBand
   #$resource
   $count=$count+1
   }
   
}
Write-Host "Total Resources Updated: $count"
