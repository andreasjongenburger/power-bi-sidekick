#When path is too long:
#https://www.howtogeek.com/266621/how-to-make-windows-10-accept-file-paths-over-260-characters/

#Add paths of where to find pbix or pbip reports that you want to include in the search step:
$pathSearchDir = @(
    'C:\DemoFiles\'
    "$env:USERPROFILE\Documents\"
)

$runningNames = Get-Process PBIDesktop -ErrorAction SilentlyContinue |
    Where-Object MainWindowTitle |
    ForEach-Object {
        $_.MainWindowTitle -replace ' - Power BI Desktop$',''
    } |
    Select-Object -Unique

$allPbiFiles = Get-ChildItem -Path $pathSearchDir -Recurse -File -Include '*.pbix','*.pbip' -ErrorAction SilentlyContinue

$openPbiFilesWithPath = $allPbiFiles |
    Where-Object { $_.BaseName -in $runningNames } |
    Select-Object -ExpandProperty FullName



$introtext = "------------------------------------------------------------------------------`nWelcome to Power BI Sidekick!`nSee https://andreasjongenburger.com/power-bi-sidekick/ for more information.`n------------------------------------------------------------------------------"
Write-Host $introtext
Write-Host "`nThe exact path and name of the current pbix or pbip file is required."
Write-Host "To prevent typos, a list of files with filenames currently running is provided here:"
#Write-Host "At present - from the provided folders - these Power BI files are detected:"
$listNr = 1
foreach ($i in $openPbiFilesWithPath )
{
	Write-Host $listNr":   "$i
	$listNr++
}

[int]$correctFileNr = Read-Host "Please enter the number with the current filename and path"
$PathFile = if ( $openPbiFilesWithPath.Count -eq 1 ) { $openPbiFilesWithPath } else { $openPbiFilesWithPath[$correctFileNr-1] }
$step1result = $introtext + "`n`n  1) Path and filename: " + $PathFile
clear
Write-Host $step1result "`n____"


Write-Host "`nNext, choose one of the available scenario's:"
Write-Host "1: For reviewing this local file only"
Write-Host "2: For reviewing all pbix-files OR pbip-files (not combined) in this folder (simulating a live connection scenario)"
Write-Host "3: For this file being a thin report connected to a Premium (per User) dataset"
Write-Host "4: For this file being a thin report connected through a SSAS tabular live connection"
Write-Host "5: For reviewing all pbix-files OR pbip-files (not combined) in this folder being thin reports connected through a SSAS tabular live connection"

[int]$scenarioNumber = Read-Host "Please enter the number with the relevant scenario"

$scenarioText = if ( $scenarioNumber -eq 1 ) { 'Only current file' } elseif ( $scenarioNumber -eq 2 ) { 'Live connection simulation' } elseif ( $scenarioNumber -eq 3 ) { 'Thin report connected to Premium (per user) dataset' } elseif ( $scenarioNumber -eq 4 ) { 'Not one of the options provided' }


$step2result = $step1result + "`n  2) Scenario: " + $scenarioText
clear
Write-Host $step2result "`n____"


if ( $scenarioNumber -in 4, 5  )
{
    $serverName = Read-Host "`nPlease enter the SSAS serverName"
	clear
	$StepSsasLiveConnResultServer = $step2result + "`n  5) Live SSAS connection server: " + $serverName
	Write-Host $StepSsasLiveConnResultServer "`n____"
	$DatabaseName = Read-Host "Please enter SSAS databasename"
	clear
	$StepSsasLiveConnResultDatabase = $StepSsasLiveConnResultServer + "`n  4) Dataset name: " + $DatabaseName
	Write-Host $StepSsasLiveConnResultDatabase "`n____"
}
elseif ( $scenarioNumber -eq 3  )
{
    $workspaceName = Read-Host "`nPlease enter the Premium (per User) workspace name (see right bottom in Power BI Desktop)"
	$serverName = 'powerbi://api.powerbi.com/v1.0/myorg/' + $workspaceName
	clear
	$step3aresult = $step2result + "`n  3) Premium (per user) server: " + $serverName
	Write-Host $step3aresult "`n____"
	$DatabaseName = Read-Host "Please enter the Power BI dataset name (see right bottom in Power BI Desktop)"
	clear
	$step4aresult = $step3aresult + "`n  4) Dataset name: " + $DatabaseName
	Write-Host $step4aresult "`n____"
}
else
{
	$serverName = $args[0]
	$DatabaseName = $args[1]
}

$datasetID = "n/a"


$powerbiPBIT = 'C:\PBISidekickTemp\PowerBI Sidekick.pbit'

Write-Host "`nYou don't always want to open a PBI Sidekick template-file."
Write-Host "If an instance of PBI Sidekick is already opened, it is quicker to refresh that file after this walk-through."
Write-Host "1: Open a Power BI template file (always when used first time)"
Write-Host "2: No template. I will refresh an instance of PBI Sidekick that is already opened"
[int]$openPBITorNot = Read-Host "Please enter the number of your choice"

$openPBITorNotText = if ( $openPBITorNot -eq 2 ) { 'Manual refresh in opened Power BI Sidekick instance' } else { 'Open template file to run Power BI Sidekick' }
$step3cresult = $step2result + "`n  3) Running mode: " + $openPBITorNotText
$step5bresult = $step4bresult + "`n  5) Running mode: " + $openPBITorNotText
$step5aresult = $step4aresult + "`n  5) Running mode: " + $openPBITorNotText

$stepLastResult = 
	if ( $scenarioNumber -eq 3 ) 
	{ 
		clear
		Write-Host $step5aresult "`n____"
	} 
	else 
	{ 
		clear
		Write-Host $step3cresult "`n____"
	}


if ( $openPBITorNot -eq 1  )
	{
		Read-Host "`nHit enter and start running Power BI Sidekick"
	}
	else
	{
		Read-Host "`nHit enter and manually refresh Power BI Sidekick"
	}	


if ( $openPBITorNot -eq 1 ) { Invoke-Item $powerbiPBIT } else {  }


# Write input parameters to file
$DetailsOutputFile = 'C:\PBISidekickTemp\PBIXConnectionDetails.csv'
$fileOrFolder = if ( $scenarioNumber -in 2, 6 ) { 'Folder' } else { 'File' }
$serverName + ',' + $DatabaseName + ',' + $PathFile + ',' + $fileOrFolder + ',' + $datasetID  | Out-File $DetailsOutputFile