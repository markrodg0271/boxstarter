<#
	Copy this file to the machine with base install of Windows 10 and execute.
	Executing the START command requires Interne Explorer to be the default browser and will fail if it is not.

	TODO: [mrodgers 6-14-2015]: Look for alternatives to one-click to initiate the intall
#>

#TODO [mrodgers 6-14-2015]: the nuget package does not yet work.  Boxstarter fails with encoding problem so I'm using a private Gist for now.
$boxStarterScriptLocation = "https://raw.githubusercontent.com/markrodg0271/boxstarter/master/BoxstarterRepository/Win10Pro/tools/ChocolateyInstall.ps1"

#Set Internet Explorer to allow boxstarter.org without interrupting
# Set-Location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains"
# if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\boxstarter.org"))
# {
# 	New-Item boxstarter.org -Force
# 	New-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\boxstarter.org" -Name http -Value 2 -Type DWORD -Force
# }

#Kick off Boxstarter
START http://boxstarter.org/package/url?$boxStarterScriptLocation