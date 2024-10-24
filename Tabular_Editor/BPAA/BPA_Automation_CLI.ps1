﻿# =================================================================================================================================================
# Best Practice Analyzer Automation (BPAA)
# 
# Rafael Barbosa
# https://github.com/rafaelxkr/Power-BI/tree/master/Tabular_Editor/BPAA
# https://www.linkedin.com/in/rafael-barbosa2
# =================================================================================================================================================

# O poder deste script está, obviamente, no Best Practice Analyzer que faz parte do Tabular Editor!
# Essa automação nada mais é do que um orquestrador.

# Se você quiser modificar as regras de práticas recomendadas ou adicionar as suas próprias, contribua com as regras no GitHub:
# https://github.com/TabularEditor/BestPracticeRules#contributing.

# O script faz um loop nos espaços de trabalho nos quais a entidade de serviço determinada.
# O script produzirá os resultados de cada análise no diretório fornecido como arquivos .trx, um resultado VSTEST padrão (JSON).
# O script baixa a versão portátil do Tabular Editor para uma nova pasta chamada TabularEditorPortable no diretório deste .ps1.

# =================================================================================================================================================

# Settings
# Link configuração UTF-8 para o Powershell --> https://stackoverflow.com/a/57134096

# Install in cmd
# npm i -g @powerbi-cli/powerbi-cli

# PARAMETERS


# Directories
$OutputDirectory = "C:\PowerBI_BPAA_output"
$TRXFilesOutputSubfolderName = "BPAA_output"

# Download URL for Tabular Editor portable (you can leave this default, or specify another version):
$TabularEditorUrl = "https://github.com/TabularEditor/TabularEditor/archive/refs/tags/2.24.1.zip"

# URL to the BPA rules file
#$BestPracticesRulesUrl = "https://raw.githubusercontent.com/TabularEditor/BestPracticeRules/master/BPARules-PowerBI.json"
$BestPracticesRulesUrl = "https://raw.githubusercontent.com/rafaelxkr/Power-BI/master/Tabular_Editor/BPARules.json"

# Service Principal values
$PowerBIServicePrincipalClientId = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" #Read-Host -Prompt 'Specify the Application (Client) Id of the Service Principal'
$PowerBIServicePrincipalSecret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" #Read-Host -Prompt 'Specify the secret of the Service Principal'
# $PowerBIServicePrincipalSecret = Read-Host -Prompt 'Specify the secret of the Service Principal' -AsSecureString 
$PowerBIServicePrincipalTenantId = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" #Read-Host -Prompt 'Specify the tenantid of the Service Principal'



# Download URL for Tabular Editor portable (you can leave this default, or specify another version):
$BPAATemplateReportDownloadUrl = "https://github.com/rafaelxkr/Power-BI/raw/master/Tabular_Editor/BPAA/BPA%20do%20Power%20BI%20Premium.pbit"

# =================================================================================================================================================

# TODO:

# - Check if TE is already installed and available via program files
# - Add option to start/suspend A sku
# - Add option to move workspace to Premium capacity during script execution
# - Add a switch for the BPA results file
# - Add support to specify a local BPA rules file (instead of Url)

# =================================================================================================================================================
# =================================================================================================================================================

function Get-ScriptDirectory {
    #if ($psise) {
    #    Split-Path $psise.CurrentFile.FullPath
    #}
    #else {
    #    $global:PSScriptRoot
    #}
    $OutputDirectory
}

# Couple of functions to help call the .exe
# Author: https://mnaoumov.wordpress.com/
function Invoke-NativeApplication
{
    param
    (
        [ScriptBlock] $ScriptBlock,
        [int[]] $AllowedExitCodes = @(0),
        [switch] $IgnoreExitCode
    )
 
    $backupErrorActionPreference = $ErrorActionPreference
 
    $ErrorActionPreference = "Continue"
    try
    {
        if (Test-CalledFromPrompt)
        {
            $lines = & $ScriptBlock
        }
        else
        {
            $lines = & $ScriptBlock 2>&1
        }
 
        $lines | ForEach-Object -Process `
            {
                $isError = $_ -is [System.Management.Automation.ErrorRecord]
                "$_" | Add-Member -Name IsError -MemberType NoteProperty -Value $isError -PassThru
            }
        if ((-not $IgnoreExitCode) -and ($AllowedExitCodes -notcontains $LASTEXITCODE))
        {
            throw "Execution failed with exit code $LASTEXITCODE"
        }
    }
    finally
    {
        $ErrorActionPreference = $backupErrorActionPreference
    }
}
 
function Test-CalledFromPrompt
{
    (Get-PSCallStack)[-2].Command -eq "prompt"
}

Set-Alias -Name exec -Value Invoke-NativeApplication
# ==================================================================================================================================

$CurrentDateTime = (Get-Date).tostring("yyyyMMdd-HHmmss")

# Start transcript
$Logfile = Join-Path -Path $OutputDirectory -ChildPath "\$CurrentDateTime\BPAA_LogFile.txt"
new-item $(Join-Path -Path $OutputDirectory -ChildPath "\$CurrentDateTime") -itemtype directory -Force | Out-Null
Start-Transcript -Path $Logfile

# ==================================================================================================================================

Clear-Host

<#

# Verifying if the PowerShell Power BI management module is installed
Write-Host "=================================================================================================================================="
Write-Host 'Verifying if the PowerShell Power BI management module is installed...'
if (Get-Module -ListAvailable -Name MicrosoftPowerBIMgmt) {
    Write-Host "MicrosoftPowerBIMgmt already installed."
} 
else {
    try {
        Install-Module -Name MicrosoftPowerBIMgmt -AllowClobber -Confirm:$False -Force  
        Write-Host "MicrosoftPowerBIMgmt installed."
    }
    catch [Exception] {
        $_.message 
        exit
    }
}
#>

Write-Host "=================================================================================================================================="

# Specify download destination of Tabular Editor:
$TabularEditorPortableRootPath = Join-Path -Path $(Get-ScriptDirectory) -ChildPath "\TabularEditorPortable"
new-item $TabularEditorPortableRootPath -itemtype directory -Force | Out-Null
$TabularEditorPortableDownloadDestination = Join-Path -Path $TabularEditorPortableRootPath -ChildPath "\TabularEditor.zip"
$TabularEditorPortableExePath = Join-Path -Path $TabularEditorPortableRootPath -ChildPath "\TabularEditor.exe"

# Download portable version of Tabular Editor from GitHub:
Write-Host 'Downloading the portable version of Tabular Editor from GitHub...'
Invoke-WebRequest -Uri $TabularEditorUrl -OutFile $TabularEditorPortableDownloadDestination

# Unzip Tabular Editor portable, and then delete the zip file:
Expand-Archive -Path $TabularEditorPortableDownloadDestination -DestinationPath $TabularEditorPortableRootPath -Force
Remove-Item $TabularEditorPortableDownloadDestination
Write-Host 'Done.'

# Download BPA rules file
Write-Host 'Downloading the standard Best Practice Rules of Tabular Editor from GitHub...'
$TabularEditorBPARulesPath = Join-Path -Path $TabularEditorPortableRootPath -ChildPath "\BPARules-PowerBI.json"
Invoke-WebRequest -Uri $BestPracticesRulesUrl -OutFile $TabularEditorBPARulesPath
Write-Host 'Done.'

# Specify download destination of the Power BI template report:
$TemplateReportRootPath = Join-Path -Path $(Get-ScriptDirectory) -ChildPath "\"
new-item $TemplateReportRootPath -itemtype directory -Force | Out-Null
$TemplateReportDownloadDestination = Join-Path -Path $TemplateReportRootPath -ChildPath "\BPAA insights.pbit"

# Download BPAA Template report from GitHub:
Write-Host 'Downloading the template Power BI report from GitHub...'
Invoke-WebRequest -Uri $BPAATemplateReportDownloadUrl -OutFile $TemplateReportDownloadDestination

Write-Host "=================================================================================================================================="

# Connect to the Power BI Service
Write-Host 'Creating credential based on Service Principal and connecting to the Power BI Service...'
#$credential = New-Object System.Management.Automation.PSCredential($PowerBIServicePrincipalClientId, $PowerBIServicePrincipalSecret)
#Connect-PowerBIServiceAccount -ServicePrincipal -Credential $credential -Tenant $PowerBIServicePrincipalTenantId
pbicli login --service-principal -p $PowerBIServicePrincipalClientId -s $PowerBIServicePrincipalSecret -t $PowerBIServicePrincipalTenantId
Write-Host "Done. (details about the environment should be posted above)"

Write-Host "=================================================================================================================================="

# Create a new array to hold the dataset info of all datasets over all workspaces
$biglistofdatasets = [System.Collections.ArrayList]::new()

# Prepare the output directory (it needs to exist)
$OutputDir = Join-Path -Path $OutputDirectory -ChildPath "\$CurrentDateTime"
new-item $OutputDir -itemtype directory -Force | Out-Null # the Out-Null prevents this line of code to output to the host

# Retrieving all workspaces
Write-Host 'Retrieving all Premium Power BI workspaces (that the Service Principal has the admin role membership in)...'
#$workspaces = Get-PowerBIWorkspace -All #-Include All -Scope Organization (commented this, I'm getting an 'Unauthorized' for this approach) # Need Fabric Admin 
$workspaces = pbicli workspace list | ConvertFrom-Json 
if ($workspaces) {
    Write-Host 'Outputting all workspace info to disk...'
    $workspacesOutputPath = Join-Path -Path $OutputDirectory -ChildPath "\$CurrentDateTime\BPAA_workspaces.json"
    $workspaces | ConvertTo-Json -Compress | Out-File -FilePath $workspacesOutputPath

    Write-Host 'Done. Now iterating the workspaces...'
    # Ignora os workspaces que contém "HML","Quarentena","Teste" ou "Modelo" no nome ou se é igual a Deploy
    $workspaces | Where-Object {$_.IsOnDedicatedCapacity -eq $True -and -not ($_.Name -like "*Hml*") -and -not ($_.Name -like "*Quarentena*") -and -not ($_.Name -like "*Teste*") -and -not ($_.Name -like "*Modelo*") -and $_.Name -ne "Deploy"} | ForEach-Object {
        Write-Host "=================================================================================================================================="
        $workspaceName = $_.Name
        $worskpaceId = $_.Id
        Write-Host "Found Premium workspace: $workspaceName.`n"

        Write-Host "Now retrieving all datasets in the workspace..."
        # Added a filter to skip datasets called "Report Usage Metrics Model"
        #$datasets = Get-PowerBIDataset -WorkspaceId $_.Id | Where-Object {$_.Name -ne "Report Usage Metrics Model" -and $_.Name -ne "Usage Metrics Report"} # Need Fabric Admin 
        $datasets = pbicli dataset list --workspace $_.Name | Where-Object {$_.Name -ne "Report Usage Metrics Model" -and $_.Name -ne "Usage Metrics Report"} | ConvertFrom-Json 
        #$dataset = Invoke-PowerBIRestMethod -Url 'groups/44aa6959-fd30-4971-974b-081b66ab192c/datasets' -Method Get | Where-Object {$_.Name -ne "Report Usage Metrics Model" -and $_.Name -ne "Usage Metrics Report"}
        $datasets | Add-Member -MemberType NoteProperty -Name "WorkspaceId" -Value $worskpaceId
        $biglistofdatasets += $datasets
        #$datasets
        
        if ($datasets) {
            Write-Host 'Done. Now iterating the datasets...'
            $datasets | ForEach-Object {
                $datasetName = $_.name
                Write-Host "Found dataset: $datasetName.`n"

                # Prepare the output directory (it needs to exist)
                $DatasetTRXOutputDir = Join-Path -Path $OutputDirectory -ChildPath "\$CurrentDateTime\$TRXFilesOutputSubfolderName\$workspaceName\"
                new-item $DatasetTRXOutputDir -itemtype directory -Force | Out-Null # the Out-Null prevents this line of code to output to the host
                $DatasetTRXOutputPath = Join-Path -Path $DatasetTRXOutputDir -ChildPath "\BPAA - $workspaceName - $datasetName.trx"

                # Call Tabular Editor BPA!
                Write-Host "Performing Best Practice Analyzer on dataset: $datasetName."
                Write-Host "Output will be saved in file: $DatasetTRXOutputPath."
                exec { cmd /c """$TabularEditorPortableExePath"" ""Provider=MSOLAP;Data Source=powerbi://api.powerbi.com/v1.0/myorg/$workspaceName;User ID=app:$PowerBIServicePrincipalClientId@$PowerBIServicePrincipalTenantId;Password=$PowerBIServicePrincipalSecret"" ""$datasetName"" -A ""$TabularEditorBPARulesPath"" -TRX ""$DatasetTRXOutputPath""" } @(0, 1) $True #| Out-Null

                Write-Host """$TabularEditorPortableExePath"" ""Provider=MSOLAP;Data Source=powerbi://api.powerbi.com/v1.0/myorg/$workspaceName;User ID=app:$PowerBIServicePrincipalClientId@$PowerBIServicePrincipalTenantId;Password=$PowerBIServicePrincipalSecret"" ""$datasetName"" -A ""$TabularEditorBPARulesPath"" -TRX ""$DatasetTRXOutputPath"""
            }
        }
        Write-Host "=================================================================================================================================="
    }
    
    Write-Host "Finished on workspace: $workspaceName."
    Write-Host "=================================================================================================================================="
}

Write-Host 'Outputting all metadata of the datasets to disk...'
$datasetsOutputPath = Join-Path -Path $OutputDirectory -ChildPath "\$CurrentDateTime\BPAA_datasets.json"
$biglistofdatasets | ConvertTo-Json -Compress | Out-File -FilePath $datasetsOutputPath

# Open Power BI template file
Write-Host "Open Power BI template file..."
Invoke-Item $TemplateReportDownloadDestination

Write-Host "Script finished."

# Stop tracing
Stop-Transcript
