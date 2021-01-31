#
#  Publish the code as dll module
#

Write-Output "dotnet publish"

# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish
$runtime = (($IsLinux -or $IsMacOS) ? "linux-x64" : "win-x64")
dotnet publish 'src/azmi/azmi.csproj'  --runtime $runtime

# Find proper dll to import
# idea taken from https://www.michev.info/Blog/Post/1722/use-powershell-to-list-all-directories-that-contain-both-file1-and-file2
$files = @('azmi.dll', 'System.Management.Automation.dll')
$dirs = (Get-ChildItem -Include $files -Recurse | Group Directory | ? Count -eq 2).Name

if ($null -eq $dirs) {
	Write-Warning 'We did not find proper dll to import, display troubleshooting information'
	$files | % {
		$_
		gci $_ -Recurse
	}
	throw "Did not find proper dll to import"
}

if ($Dirs.Count -gt 1) {
	Write-Warning "Found more than one suitable azmi.dll, using first one"
	$dirs
	$dirs = $dirs[0]
}

# module manifest setup
$moduleManifest = Get-ChildItem 'azmi.psd1' -Recurse
if ($null -eq $moduleManifest) {
	Write-Warning 'We did not find module manifest to import, display troubleshooting information'
	gci 'azmi.psd1' -Recurse
	throw "Did not find proper dll to import"
}
if ($moduleManifest.Count -gt 1) {
	Write-Warning "Found more than one module manifest, using first one"
	$moduleManifest
	$moduleManifest = $moduleManifest[0]
}
# copy manifest to publish folder
$modulePath = Join-Path $dirs $moduleManifest.BaseName
Copy-Item -Path $moduleManifest.FullName -Destination $modulePath


# Import and check module
Write-Output "Importing $modulePath"
Import-Module $modulePath
Get-Command -Module azmi | Select Name, ParameterSets
Get-Module -Name $moduleName | Format-List
