#
# This script should be executed if
#   - new parameters are added to existing commands, or
#   - new commands are added


Write-Output "dotnet publish"
$runtime = (($IsLinux -or $IsMacOS) ? "linux-x64" : "win-x64")
dotnet clean 'src/azmi/azmi.csproj'  --runtime $runtime
dotnet publish 'src/azmi/azmi.csproj'  --runtime $runtime  --output 'src/azmi/bin/publish'

Write-Output "import module"
import-module .\src\azmi\bin\publish\azmi.dll

Write-Output "update docs"
Update-MarkdownHelp -Path ./Docs

Write-Output "check git diff and commit!"
