#Get public and private function definition files.
[cmdletbinding()]
param()
Write-Verbose $PSScriptRoot

Write-Verbose 'Import everything in sub folders public, private folder'
$functionFolders = @('Public', 'Private')

ForEach ($folder in $functionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    If (Test-Path -Path $folderPath) {
        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1'
        ForEach ($function in $functions) {
            Write-Verbose -Message "  Importing $($function.BaseName)"
            try {
                . $($function.FullName)
            }
            catch {
                Write-Verbose ('Failed to import "{0}". Reason: "{1}"' -f $function.FullName, $_.Exception.Message)
            }
        }
    }
}

Export-ModuleMember -Function $(@( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction Stop )).Basename
