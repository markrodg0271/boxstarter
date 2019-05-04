<#
	Copy this file to the machine with base install of Windows 2012 R2 and execute.
	Executing the START command requires Interne Explorer to be the default browser and will fail if it is not.

	TODO: [mrodgers 6-14-2015]: Look for alternatives to one-click to initiate the intall
#>

#TODO [mrodgers 6-14-2015]: the nuget package does not yet work.  Boxstarter fails with encoding problem so I'm using a private Gist for now.
#$boxStarterScriptLocation = "https://www.myget.org/F/test-of-dev-build/api/v2/package/LyricCameraDevBuild/1.0.0"
$boxStarterScriptLocation = "https://gist.githubusercontent.com/markrodg0271/dc75182a4d65e900c293/raw/6c614fc9cda16a0bd45adea78955e4951a1eba05/bstarter"

#Set Internet Explorer to allow boxstarter.org without interrupting
Set-Location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains"
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\boxstarter.org"))
{
	New-Item boxstarter.org -Force
	New-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\boxstarter.org" -Name http -Value 2 -Type DWORD -Force
}

#Kick off Boxstarter
START http://boxstarter.org/package/url?$boxStarterScriptLocation