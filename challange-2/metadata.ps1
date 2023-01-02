$allMetadata = Get-GceMetadata -Recurse -Path "instance/" | % { [System.Text.RegularExpressions.Regex]::Unescape($_) }
$allMetadata | Out-File "C:\test\allMetadata1.json" 
$FilePath = "C:\test\allMetadata1.json"
$FileContent = Get-Content -Path $FilePath
$UTF8Only = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($FilePath, @($FileContent), $UTF8Only)
write-host "JSON formatted output is:" `n $allMetadata
write-host `n`n
#$Key = Read-Host "Please enter key to fetch value"
#$x = $allMetadata | ConvertFrom-Json
#$name="windows-keys"
#foreach ($obj in $x) {

 #   $options = $obj.$Key
   # $propertyNames = $options.psobject.Properties.Name

  #  foreach ($name in $propertyNames) {
  #
   #     $output=$options.$name # will give you the value of the property.
   #     write-host "value for key :" `n $output

          
    #}
#}