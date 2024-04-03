$filename              = "wincollect-1.0.0.exe"
$ErrorActionPreference = 'Stop'
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation          = Join-Path $toolsDir $filename
$url                   = ''
$url64                 = ''

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64
  file          = $fileLocation
  softwareName  = 'wincollect*'
  checksum      = ''
  checksumType  = 'sha256'
  checksum64    = ''
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
  # OTHERS
  #silentArgs   = '/S'                                            # NSIS
  #silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  #silentArgs   = '/s'                                            # InstallShield
  #silentArgs   = '/s /v"/qn"'                                    # InstallShield with MSI
  #silentArgs   = '/s'                                            # Wise InstallMaster
  #silentArgs   = '-s'                                            # Squirrel
  #silentArgs   = '-q'                                            # Install4j
  #silentArgs   = '-s'                                            # Ghost
  validExitCodes= @(0)                                            #please insert other valid exit codes here
}

Install-ChocolateyPackage @packageArgs
