#When path is too long:
#https://www.howtogeek.com/266621/how-to-make-windows-10-accept-file-paths-over-260-characters/

$pathSearchDir = 
	   'C:\DemoFiles\'

$pbiInstances = Get-Process PBIDesktop
$runningPBIXfiles = $pbiInstances.MainWindowTitle.Replace(' - Power BI Desktop', '.pbix')
$allPbiFiles = (Get-ChildItem -Path $pathSearchDir -Recurse -Include '*.pbix').FullName

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
$introtext = "------------------------------------------------------------------------------`nWelcome to Power BI Sidekick!`nSee https://andreasjongenburger.com/power-bi-sidekick/ for more information.`n------------------------------------------------------------------------------"
Write-Host $introtext
Write-Host "`nThe exact path and name of the current pbix-file is required."
Write-Host "To prevent typos, a list of files with filenames currently running is provided here:"
#Write-Host "At present - from the provided folders - these Power BI files are detected:"
$listNr = 1
foreach ($i in $openPBIXfilesWithPath )
{
	Write-Host $listNr":   "$i
	$listNr++
}

[int]$correctFileNr = Read-Host "Please enter the number with the current filename and path"
$PathFile = if ( $openPBIXfilesWithPath.Count -eq 1 ) { $openPBIXfilesWithPath } else { $openPBIXfilesWithPath[$correctFileNr-1] }
$step1result = $introtext + "`n`n  1) Path and filename: " + $PathFile
clear
Write-Host $step1result "`n____"


Write-Host "`nNext, choose one of the available scenario's:"
Write-Host "1: For reviewing this local file only"
Write-Host "2: For reviewing all pbix-files in this folder (simulating a live connection scenario)"
Write-Host "3: For this file being a thin report connected to a Premium (per User) dataset"
Write-Host "4: For reviewing multiple thin reports online - current file should be the dataset-file (also for Pro)"
[int]$scenarioNumber = Read-Host "Please enter the number with the relevant scenario"

$scenarioText = if ( $scenarioNumber -eq 1 ) { 'Only current file' } elseif ( $scenarioNumber -eq 2 ) { 'Live connection simulation' } elseif ( $scenarioNumber -eq 3 ) { 'Thin report connected to Premium (per user) dataset' } else { 'Local dataset file with thin reports in Power BI Service (Api connection)' }


$step2result = $step1result + "`n  2) Scenario: " + $scenarioText
clear
Write-Host $step2result "`n____"


if ( $scenarioNumber -eq 3  )
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

if ( $scenarioNumber -eq 4  )
{
    Write-Host "`nFor this scenario, a bit extra input is required."
	Write-Host "A connection to the Power BI Service will be built using the Rest API."
	Write-Host "To retrieve all thin reports that user has access to (cross-workspace) the dataset ID is needed."
	$datasetID = Read-Host "Please enter the dataset id"
	clear
	$step3bresult = $step2result + "`n  3) Dataset ID: " + $datasetID
	Write-Host $step3bresult "`n____"
}
else
{
	$datasetID = "n/a"
}

# Specify the path to tokenfile
$tokenFile = 	'C:\PBISidekickTemp\token.txt'

if ( $scenarioNumber -eq 4  )
{
    Set-Content $tokenFile "Paste bearer token in this file. Get it here: https://learn.microsoft.com/en-us/rest/api/power-bi/datasets/get-datasets#code-try-0. `n`nUse copy button on top right of code snippet, then here Ctrl+A and Ctrl+V`n`nIt will look like this:`nGET https://api.powerbi.com/v1.0/myorg/datasets `nAuthorization: Bearer <long tokenstring>"
	Write-Host "`nFurthermore, a bearer token is required to connect to the API."
	Read-Host "After hitting enter, a text file will open where the bearer token can be pasted into"
	start $tokenFile
	Read-Host "Is the file with the bearer token saved and closed? Hit enter to continue"
	clear
	$step4bresult = $step3bresult + "`n  4) The bearer token is pasted into 'token.txt'"
	Write-Host $step4bresult "`n____"
}
else { Set-Content $tokenFile "n/a" }

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
	elseif ( $scenarioNumber -eq 4 ) 
	{ 
		clear
		Write-Host $step5bresult "`n____"
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
$fileOrFolderOrApi = if ( $scenarioNumber -eq 2 ) { 'Folder' } elseif ( $scenarioNumber -eq 4 ) { 'Api' } else { 'File' }
$serverName + ',' + $DatabaseName + ',' + $PathFile + ',' + $fileOrFolderOrApi + ',' + $datasetID  | Out-File $DetailsOutputFile