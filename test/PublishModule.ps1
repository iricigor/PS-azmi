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

$moduleName = Get-Item '*.psd1' | Select -Expand BaseName
$modulePath = Join-Path $dirs $moduleName
#$azmiPath = Join-Path $dirs 'azmi.dll'


# Import and check module
Write-Output "Importing $modulePath"
Import-Module $modulePath
Get-Command -Module azmi | Select Name, ParameterSets
Get-Module -Name $moduleName
