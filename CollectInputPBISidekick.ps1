#When path is too long:
#https://www.howtogeek.com/266621/how-to-make-windows-10-accept-file-paths-over-260-characters/

$pathSearchDir = 
#   'C:\DemoFiles\'
   "$($env:USERPROFILE)\"

$pbiInstances = Get-Process PBIDesktop
$runningPBIXfiles = $pbiInstances.MainWindowTitle.Replace(' - Power BI Desktop', '.pbix')
$allPbiFiles = (Get-ChildItem -Path $pathSearchDir -Recurse -Include '*.pbix').FullName


if ( $args[0] -eq "pbiazure://api.powerbi.com" )
{
    Write-Host "This PBIX file is connected live to a Power BI dataset. Premium or Premium per User is required to make it work"
	$workspaceName = Read-Host "Please enter the Premium (per User) workspace name (see right bottom in Power BI Desktop)"
	$serverName = 'powerbi://api.powerbi.com/v1.0/myorg/' + $workspaceName
	$DatabaseName = Read-Host "Please enter the Power BI dataset name (see right bottom in Power BI Desktop)"
}
else
{
	$serverName = $args[0]
	$DatabaseName = $args[1]
}

$openPBIXfilesWithPath = 
foreach ( $pbixfile in $allPbiFiles )
{
    foreach ( $openFile in $runningPBIXfiles )
    {
        if ($pbixfile.EndsWith('\'+$openFile) ) 
        {
            $pbixfile
        }
    }
}

Write-Host 'These .pbix files are currently opened:'	
$listNr = 1
foreach ($i in $openPBIXfilesWithPath )
{
	Write-Host $listNr":   "$i
	$listNr++
}
[int]$correctFileNr = Read-Host "Please enter the number with the path of this file"
$PathFile = if ( $openPBIXfilesWithPath.Count -eq 1 ) { $openPBIXfilesWithPath } else { $openPBIXfilesWithPath[$correctFileNr-1] }
Write-Host "`nThanks, you picked:`n" $PathFile

Write-Host "`nSimulate a live connection scenario by running Power BI Sidekick from the dataset-pbix and putting the thin reports in the same folder."
Write-Host "`nFor reviewing this file only, return 1"
[int]$fileOrFolderChoice = Read-Host "For reviewing all pbix-files in this folder, return 2"


$DetailsOutputFile = 'C:\PBISidekickTemp\PBIXConnectionDetails.csv'
$fileOrFolder = if ( $fileOrFolderChoice -eq 1 ) { 'File' } else { 'Folder' }

$serverName + ',' + $DatabaseName + ',' + $PathFile + ',' + $fileOrFolder  | Out-File $DetailsOutputFile

$returnText = if ( $fileOrFolderChoice -eq 1 ) { "`nThanks, only this file will be evaluated." } else { "`nThanks, all (model and thin) reports will be included in the evaluation." }
Write-Host "`n$($returnText)`n"

$powerbiPBIT = 'C:\PBISidekickTemp\PowerBI Sidekick.pbit'

Write-Host "`nFor opening a separate Power BI template file, return 1"
[int]$openPBITorNot = Read-Host "For refreshing an already open PBI Sidekick file, return 2"
if ( $openPBITorNot -eq 1 ) { Invoke-Item $powerbiPBIT } else {  }
