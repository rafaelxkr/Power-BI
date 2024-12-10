# =================================================================================================================================================
# Best Practice Analyzer Automation (BPAA)
# Version 0.01 alpha 2
# 
# Dave Ruijter
# https://moderndata.ai/
# =================================================================================================================================================

# README

# The power of this script is of course in the Best Practice Analyzer that is part of Tabular Editor! 
# This automation is nothing but a fancy orchestrator.
# Please visit https://tabulareditor.com/ and reach out Daniel Otykier and thank him!

# If you want to modify the best-practices rules, or add your own, contribute to the rules on GitHub:
# https://github.com/TabularEditor/BestPracticeRules#contributing. 

# The script loopts the workspaces that the given service principal has the admin role membership in.
# The script will output the results of each analysis in the given directory as .trx files, a standard VSTEST result (JSON).
# The script downloads the portable version of Tabular Editor to a new folder called TabularEditorPortable in the directory of this .ps1.
# The script installs the PowerShell Power BI management module (MicrosoftPowerBIMgmt).


# Also credits and thanks to https://mnaoumov.wordpress.com/ for the functions to help call the .exe.
# =================================================================================================================================================

# Settings
# Link configuração UTF-8 para o Powershell --> https://stackoverflow.com/a/57134096

# PARAMETERS


# Directories
$OutputDirectory = "C:\PowerBI_BPAA_output"
$TRXFilesOutputSubfolderName = "BPAA_output"

# Download URL for Tabular Editor portable (you can leave this default, or specify another version):
$TabularEditorUrl = "https://github.com/TabularEditor/TabularEditor/releases/latest/download/TabularEditor.Portable.zip"

# URL to the BPA rules file

#Versão Standard
$BestPracticesRulesUrl = "https://raw.githubusercontent.com/rafaelxkr/Power-BI/master/Tabular_Editor/BPARules_Standard.json"

# Service Principal values

#---------Principal Service ------------------
$PowerBIServicePrincipalClientId = "XXXXXXXXXXXXXXXXXXXXXXXXXXX" #Read-Host -Prompt 'Specify the Application (Client) Id of the Service Principal'
$PowerBIServicePrincipalSecret =   "XXXXXXXXXXXXXXXXXXXXXXXXXXX"
$PowerBIServicePrincipalTenantId = "XXXXXXXXXXXXXXXXXXXXXXXXXXX" #Read-Host -Prompt 'Specify the tenantid of the Service Principal'
#---------------------------------


# Download URL for Tabular Editor portable (you can leave this default, or specify another version):
$BPAATemplateReportDownloadUrl = "https://github.com/rafaelxkr/Power-BI/blob/master/Tabular_Editor/BPAA/BPA%20do%20Power%20BI%20Premium.pbit"

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


$WorkspacesFilter = "Administração de Vendas - Area","Administração de Vendas [Test]","Analytics_Controladoria_Financeiro","Auditoria Interna","BRACE PHARMA","COMERCIAL VAREJO","CyberSecurity","Dashboards Grupo NC","Data Warehouse","Embalagem de Solidos","EMS - Intel. Com. (MEU PDV)","EMS_QUALIDADE","EMS_Regulatórios (SAC)","Equipe Dados","Excelência Fábrica Manaus (NVM)","EXCELÊNCIA OPERACIONAL HORTO E JAGUA","Fabric Admin","Farmacotécnica","Galênico P&D","Gestão da Rotina","Gestão de Riscos Corporativos","Governança","GX","GX - Feiras","GX - Mercanet","GX - Sell Out Disty","IM Corporativo","IPP - AREA","IPP - HOMOLOGACAO","LBP - Legal Business Partner","Manutenção","Manutenção Elétrica","Martech","Médico Científico","MercadoFarma","MercadoFarma - Interno","Microsoft Fabric Capacity Metrics 06/12/2023 18:10:43","Multilab Marketing","Multilab SJ","NC TECH","NC+ à vista","NCTECH - Historico Uso Capacidade","OPERACIONAL BRASILIA","PCP e Diretoria Fabrica","Personal","Planejamento Estratégico Pro","Polaris Workspace","Portal Snellog","Portifolio&Inovação","Premium Capacity Utilization And Metrics OUT/2022","Primavera Cloud","Primeiros Passos - EMS Marcas","PRODUÇÃO","QA Dashboards Grupo NC","RBBL","Relacionamento e Solução","Relatórios Unificados  ","Segurança Patrimonial","SEN - DATAFLOW | EFETIVIDADE","SEN - DATAFLOW | IM","SEN - DATAFLOW | PE","SEN - DATAFLOW | RAWDATA","SEN+","Testec","TRADE MARKETING","SEN | CUBO"
$Contador_iteração = 1

$workspaces = pbicli workspace list | ConvertFrom-Json 
if ($workspaces) {
    Write-Host 'Outputting all workspace info to disk...'
    $workspacesOutputPath = Join-Path -Path $OutputDirectory -ChildPath "\$CurrentDateTime\BPAA_workspaces.json"
    $workspaces | ConvertTo-Json -Compress | Out-File -FilePath $workspacesOutputPath

    Write-Host 'Done. Now iterating the workspaces...'
    # Ignora os workspaces que contém "HML","Quarentena","Teste" ou "Modelo" no nome ou se é igual a Deploy
    #$workspaces | Where-Object {$_.IsOnDedicatedCapacity -eq $True -and $_.Name -in $WorkspacesFilter   } | ForEach-Object {
    #$workspaces | Where-Object {$_.IsOnDedicatedCapacity -eq $True -and -not ($_.Name -like "*Hml*") -and -not ($_.Name -like "*Quarentena*") -and -not ($_.Name -like "*Teste*") -and -not ($_.Name -like "*Modelo*") -and $_.Name -ne "Deploy"} | ForEach-Object {
    $workspaces | Where-Object {$_.IsOnDedicatedCapacity -eq $True   } | ForEach-Object {
        Write-Host "=================================================================================================================================="
        $workspaceName = $_.Name
        $workspaceNameCorrigido = $workspaceName -replace '(?:\||\\|\/|\*|\?|\"|\:|<|>)', ''
        $worskpaceId = $_.Id
        Write-Host "Found Premium workspace: $workspaceName.`n"
        Write-Host "Now retrieving all datasets in the workspace..."
        
        $datasets = pbicli dataset list --workspace $worskpaceId | ConvertFrom-Json 



        #realiza o login a cada 10 iterações de Workspace
        if ($Contador_iteração % 10 -eq 0 ) 
        { 
            pbicli login --service-principal -p $PowerBIServicePrincipalClientId -s $PowerBIServicePrincipalSecret -t $PowerBIServicePrincipalTenantId 
            Write-Host 'Update. Credential based on Service Principal'
        }
        $Contador_iteração++


        $biglistofdatasets += $datasets
        #$datasets
        
         
        if ($datasets) {
            Write-Host 'Done. Now iterating the datasets...'
            # Added a filter to skip datasets called "Report Usage Metrics Model" e "Usage Metrics Report"
            $datasets | Where-Object {$_.Name -ne "Report Usage Metrics Model" -and $_.Name -ne "Usage Metrics Report" } | ForEach-Object {

                $datasetName = $_.name 
                $datasetNameCorrigido = $datasetName -replace '(?:\||\\|\/|\*|\?|\"|\:|<|>)', ''
                Write-Host "Found dataset: $datasetName.`n"

                
                # Prepare the output directory (it needs to exist)
                $DatasetTRXOutputDir = Join-Path -Path $OutputDirectory -ChildPath "\$CurrentDateTime\$TRXFilesOutputSubfolderName\$workspaceNameCorrigido\" 
                new-item $DatasetTRXOutputDir -itemtype directory -Force | Out-Null # the Out-Null prevents this line of code to output to the host 
                $DatasetTRXOutputPath = Join-Path -Path $DatasetTRXOutputDir -ChildPath "\BPAA - $workspaceNameCorrigido - $datasetNameCorrigido.trx" 

                # Call Tabular Editor BPA!
                Write-Host "Performing Best Practice Analyzer on dataset: $datasetName."
                Write-Host "Output will be saved in file: $DatasetTRXOutputPath."


               
                 
                try{ 
                exec { cmd /c """$TabularEditorPortableExePath"" ""Provider=MSOLAP;Data Source=powerbi://api.powerbi.com/v1.0/myorg/$workspaceName;User ID=app:$PowerBIServicePrincipalClientId@$PowerBIServicePrincipalTenantId;Password=$PowerBIServicePrincipalSecret"" ""$datasetName"" -A ""$TabularEditorBPARulesPath"" -TRX ""$DatasetTRXOutputPath"" -ERR" }  @(0, 1) $True  #| Out-Null 
                }
                catch {}

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
