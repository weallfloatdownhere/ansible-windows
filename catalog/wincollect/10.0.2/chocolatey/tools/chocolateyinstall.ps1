# Chocolatey parameters
$filename              = "wincollect-1.0.0.exe"
$ErrorActionPreference = 'Stop'
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation          = Join-Path $toolsDir $filename
$url                   = ''
$url64                 = ''

# Installation parameters
$INSTALLDIR                       = "C:\Program Files\IBM\WinCollect\"
$HEARTBEAT_INTERVAL               = 6000
$LOG_SOURCE_AUTO_CREATION_ENABLED = 'True'

# Chocolatey package arguments
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  url64bit       = $url64
  file           = $fileLocation
  softwareName   = 'wincollect*'
  checksum       = ''
  checksumType   = 'sha256'
  checksum64     = ''
  checksumType64 = 'sha256'

  # MSI
  silentArgs     = '/s /v" /qn INSTALLDIR="' + $INSTALLDIR  + '" HEARTBEAT_INTERVAL=' + $HEARTBEAT_INTERVAL + ' LOG_SOURCE_AUTO_CREATION_ENABLED=' + $LOG_SOURCE_AUTO_CREATION_ENABLED
  validExitCodes = @(0, 3010, 1641)
}

# Installation
Install-ChocolateyPackage @packageArgs
