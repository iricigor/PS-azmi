#
#  Publish the code as dll module
#

function Set-OnlyOne([ref]$Obj, [string]$explanation, [string]$filter) {

	if ($null -eq $Obj.Value) {
		Write-Warning "We did not find proper $explanation to import, display troubleshooting information"
		Get-ChildItem -Filter $filter -Recurse -ea 0
		throw "Did not find proper $explanation to import"
	}

	elseif ($Obj.Value.Count -gt 1) {
		Write-Warning "Found more than one suitable $explanation, using first one"
		$Obj.Value
		$Obj.Value = $Obj.Value[0]

	} else {
		Write-Output "Using $explanation without modifications as $Obj"
	}
}


Write-Output "dotnet publish"

# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish
$runtime = (($IsLinux -or $IsMacOS) ? "linux-x64" : "win-x64")
dotnet publish 'src/azmi/azmi.csproj'  --runtime $runtime

# Find proper dll to import
# idea taken from https://www.michev.info/Blog/Post/1722/use-powershell-to-list-all-directories-that-contain-both-file1-and-file2
$files = @('azmi.dll', 'System.Management.Automation.dll')
$publishDir = (Get-ChildItem -Include $files -Recurse | Group Directory | ? Count -eq 2).Name

Set-OnlyOne ([ref]$publishDir) 'azmi.dll' 'azmi.dll|System.Management.Automation.dll'
# if ($null -eq $publishDir) {
# 	Write-Warning 'We did not find proper dll to import, display troubleshooting information'
# 	$files | % {
# 		$_
# 		gci $_ -Recurse
# 	}
# 	throw "Did not find proper dll to import"
# }

# if ($publishDir.Count -gt 1) {
# 	Write-Warning "Found more than one suitable azmi.dll, using first one"
# 	$publishDir
# 	$publishDir = $publishDir[0]
# }

# module manifest setup
$moduleManifest = Get-ChildItem 'azmi.psd1' -Recurse
Set-OnlyOne ([ref]$moduleManifest) 'module manifest' 'azmi.psd1'
# if ($null -eq $moduleManifest) {
# 	Write-Warning 'We did not find module manifest to import, display troubleshooting information'
# 	gci 'azmi.psd1' -Recurse
# 	throw "Did not find proper psd1 to import"
# }
# if ($moduleManifest.Count -gt 1) {
# 	Write-Warning "Found more than one module manifest, using first one"
# 	$moduleManifest
# 	$moduleManifest = $moduleManifest[0]
# }
# copy manifest to publish folder
$modulePath = Join-Path $publishDir $moduleManifest.Name
Copy-Item -Path $moduleManifest.FullName -Destination $modulePath

# copy XML help file to publish folder
$helpFile = Get-ChildItem 'azmi.dll-Help.xml' -Recurse
Set-OnlyOne ([ref]$helpFile) 'module XML help' 'azmi.dll-Help.xml'
# if ($null -eq $helpFile) {
# 	Write-Warning 'We did not find module XML help file to publish, display troubleshooting information'
# 	gci 'azmi.psd1' -Recurse
# 	throw "Did not find proper xml to import"
# }
# if ($helpFile.Count -gt 1) {
# 	Write-Warning "Found more than one module help file, using first one"
# 	$helpFile
# 	$helpFile = $helpFile[0]
# }
$helpFileDir = Join-Path $publishDir 'en-US'
New-Item $helpFileDir -ItemType Directory -Force | Out-Null
Copy-Item -Path $helpFile.FullName -Destination $helpFileDir

# verify content of the folder
Write-Output "Verify content of folder: $publishDir"
Get-ChildItem $publishDir | Select -Expand Name

# Import and check module
Write-Output "Importing $modulePath"
Import-Module $modulePath
Get-Command -Module 'azmi' | Select Name, Version
Get-Module -Name 'azmi' | Format-List
