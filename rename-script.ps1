# 
# PowerShell script which parses Cadmus XML, renames supplementary material
# assets accordingly, and ZIPs up the result.
#
# Copyright (c) 2017 Glencoe Software, Inc. All rights reserved.

# This program and the accompanying materials
# are licensed and made available under the terms and conditions of the BSD
# License which accompanies this distribution.  The full text of the license
# may be found at http://opensource.org/licenses/bsd-license.php
#
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
# WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED.
#

Param(
    [Parameter(Position=0,mandatory=$true)]
    [string]$path
)

$Version = "0.1.0"

# If there is an error fail fast
$ErrorActionPreference = "Stop"

Write-Host "Cadmus XML asset rename script version: $version"
Write-Host

# Do a filesystem lookup, will fail if the path does not exist
$root = Get-Item $path
if (-not ($root -is [System.IO.DirectoryInfo])) {
    throw "Provided path '$root' is not a directory"
}

Write-Host "Processing path '$root'"

# Make Sure we only have one XML file
$xmlFiles = @(Get-ChildItem -Path $root *.xml)
if ($xmlFiles.Length -ne 1) {
    throw "One XML file required, found: " + $xmlFiles.Length
}
$xmlFile = $xmlFiles[0]

Write-Host ("Using Cadmus XML '{0}'" -f $xmlFile.FullName)

[xml]$xml = Get-Content -Path $xmlFile.FullName

$doi = $xml.metadata.articleid.doi
Write-Host "Found DOI: '$doi'"

# Parse the XML document looking for "supplemental-data" tags in the XPath
# /metadata/digitalinfo and extract our required metadata to attempt
# renaming.  This consists of:
#   * Source filename
#   * Destination filename
#   * Whether or not the source filename exists
$prefix = $xmlFile.Name.Substring(0, $xmlFile.Name.IndexOf("_"))
$rows = @()
Foreach ($supplementalData in $xml.metadata.digitalinfo."supplemental-data") {
    $description = $supplementalData.Attributes["description"]."#text"
    $originalName = $supplementalData.Attributes["originalname"]."#text"
    $extension = $originalName.Substring($originalName.LastIndexOf("."))
    $source = "{0}_{1}{2}" -f
        $prefix, $description.Replace(" ", "_"), $extension
    $destination = $supplementalData."#text"
    $exists = Test-Path (Join-Path -Path $root -ChildPath $source)

    $row = New-Object PSObject
    $row | Add-Member NoteProperty Source $source
    $row | Add-Member NoteProperty Destination $destination
    $row | Add-Member NoteProperty Exists $exists
    $rows += $row
}

$rows | Format-List

# Rename the assets we have found, if they exist
$assets = @()
Foreach ($row in $rows) {
    $source = $row.Source
    $destination = $row.Destination
    if (-not $row.Exists) {
        Write-Host (
            "Skipping rename of '{0}', doesn't exist!" -f $source
        ) -ForegroundColor Red
        continue
    }

    $sourcePath = Join-Path -Path $root -ChildPath $source
    $destinationPath = Join-Path -Path $root -ChildPath $destination
    Rename-Item $sourcePath $destinationPath
    $assets += $destinationPath
    
    Write-Host (
        "Successfully renamed '{0}' to '{1}'" -f $source, $destination
    ) -ForegroundColor Green
}

# Create a ZIP file with all the assets we found and the XML file
$assets += $xmlFile.FullName
$zipPath = Join-Path -Path $root -ChildPath ("{0}.zip" -f $prefix)
Compress-Archive -Path $assets -DestinationPath $zipPath

Write-Host
Write-Host "Successfully created ZIP '$zipPath'" -ForegroundColor Green
