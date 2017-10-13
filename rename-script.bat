@REM @file
@REM   Windows batch file to invoke PowerShell script
@REM
@REM Copyright (c) 2017 Glencoe Software, Inc. All rights reserved.

@REM This program and the accompanying materials
@REM are licensed and made available under the terms and conditions of the
@REM BSD License which accompanies this distribution.  The full text of the
@REM license may be found at http://opensource.org/licenses/bsd-license.php
@REM
@REM THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR
@REM IMPLIED.
@REM

@ECHO OFF

@REM Execute PowerShell indirectly due to the default Execution Policy
@REM employed on Windows.
@REM
@REM Reference:
@REM   "http://go.microsoft.com/fwlink/?LinkID=135170"
@REM
PowerShell.exe -ExecutionPolicy bypass -File "%~dpn0.ps1" %1

PAUSE
