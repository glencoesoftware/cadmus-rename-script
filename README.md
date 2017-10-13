Cadmus XML Asset Renaming Script
================================

Renames exported supplementary material assets based on Cadmus XML metadata.

License
=======

This program and the accompanying materials
are licensed and made available under the terms and conditions of the BSD License
which accompanies this distribution.  The full text of the license may be found at
http://opensource.org/licenses/bsd-license.php

Requirements
============

* PowerShell 5.0+ (Windows 10)

Workflow
========

The renaming script is distributed using two files:

 * `rename-script.bat` batch file for bootstrapping PowerShell
 * `rename-script.ps1` PowerShell profile script

These two files should be downloaded, placed in the same folder, and **not**
renamed.  Both files are required for appropriate function of the script.
Moving after initial download is fine as long as both files are moved
together.  It is **strongly** suggested that the files be placed in a
convenient location for use with Windows Explorer drag and drop.

To initiate renaming, simply drag and drop a folder using Windows Explorer
containing the Cadmus XML and exported assets to the `rename-script.bat`
batch file.  A command prompt will pop up giving you real time output as
to what it is doing.

The script performs the following tasks:

1. Collect declared supplementary material asset metadata via evaluation of
Cadmus XML.

1. Renaming of assets based on collected metadata.

1. Creation of a composite ZIP file containing the Cadmus XML itself and
all available renamed assets.

Reference
=========
