#
#  Publish the code as dll module
#

Write-Output "dotnet publish"

# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish
$runtime = " --runtime " + (($IsLinux -or $IsMacOS) ? "linux-x64" : "win-x64")
dotnet publish src/azmi/azmi.csproj $runtime

# Find proper dll to import
# idea taken from https://www.michev.info/Blog/Post/1722/use-powershell-to-list-all-directories-that-contain-both-file1-and-file2
$dirs = (Get-ChildItem -Include 'azmi.dll', 'System.Management.Automation.dll' -Recurse | Group Directory | ? Count -eq 2).Name

if ($null -eq $dirs) {
	# We did not find proper dll to import
	# Display troubleshooting information
	@('azmi.dll', 'System.Management.Automation.dll') | % {
		$_
		gci $_ -Recurse
	}
	throw "Did not find proper dll to import"
}

if ($Dirs.Count -gt 1) {
	Write-Warning "Found more than one suitable azmi.dll."
	$dirs
}

$azmiPath = Join-Path $dirs 'azmi.dll'


# Import and check module
Write-Output "Importing $path"
Import-Module $path
Get-Command -Module azmi | Select Name, ParameterSets



