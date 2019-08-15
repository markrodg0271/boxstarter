
	#**********CUSTOM INSTALLERS FOR ADDITION TO A CUSTOM CHOCOLATEY FEED AT SOME POINT
	function install_azuremanagementstudio
	{
		#*********AZURE MANAGEMENT STUDIO
		$azureManagmentStudioDirectory = "$appsDirectory\azure_management_studio"
		if (!(Test-Path ($azureManagmentStudioDirectory + "\Azure Management Studio.exe")))
		{
			Write-BoxstarterMessage -message "Installing Azure Management Studio..." -color Green
			New-Item $azureManagmentStudioDirectory -Type Directory -force

			wget -Uri http://installers.cerebrata.com/setup/Azure%20Management%20Studio/production/1/Azure%20Management%20Studio.exe -OutFile "$azureManagmentStudioDirectory\Azure Management Studio.exe"
			New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\azms.exe" -Value "$azureManagmentStudioDirectory\Azure Management Studio.exe"
			Write-BoxstarterMessage -message "Finished installing Azure Management Studio." -color Green
		}
		else
		{
			Write-BoxstarterMessage -message "Azure Management Studio already installed."
		}
	}

	function install_java
	{
		#********JAVA
		$javaPath = "$env:ProgramFiles\Java\jdk1.8.0_60"
		if (!(Test-Path ("$javaPath\src.zip")))
		{
			Write-BoxstarterMessage -message "Installing Java SDK 1.8.0_60..." -color Green
			if (!(Test-Path ($InstallersDirectory + "\jdk-8u60-windows-x64.exe")))
			{
				wget -Uri http://hchcamstorage.blob.core.windows.net/installers/jdk-8u60-windows-x64.exe -OutFile $InstallersDirectory\jdk-8u60-windows-x64.exe
			}

			Set-Location $installersDirectory 
			.\jdk-8u60-windows-x64.exe /quiet /norestart
			[Environment]::SetEnvironmentVariable("JAVA_HOME", $javaPath, "MACHINE")
			Write-BoxstarterMessage -message "Finished installing Java SDK 1.8.0_60." -color Green
		}
		else
		{
			Write-BoxstarterMessage -message "Java SDK 1.8.0_60 already installed."
		}
	}

	function install_servicebusexplorer
	{
		#*****SERVICE BUS EXPLORER
		$sbExplorerPath = "$appsDirectory\service_bus_explorer"
		if (!(Test-Path ($sbExplorerPath + "\ServiceBusExplorer.exe")))
		{
			Write-BoxstarterMessage -message "Installing Service Bus Explorer..." -color Green
			wget https://code.msdn.microsoft.com/windowsazure/service-bus-explorer-f2abca5a/file/136876/2/Service%20Bus%20Explorer.zip -OutFile "$InstallersDirectory\Service Bus Explorer.zip"
			sz e -o"$sbExplorerPath" "$InstallersDirectory\Service Bus Explorer.zip" "C#\bin\debug\*"
			$env:path += ";$sbExplorerPath"
			New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\sbexplorer.exe" -Value "$sbExplorerPath\ServiceBusExplorer.exe"
			Write-BoxstarterMessage -message "Finished installing Service Bus Explorer." -color Green
		}
		else
		{
			Write-BoxstarterMessage -message "Service Bus Explorer already installed."
		}
	}

	function install_wowza
	{
		#************WOWZA
		$wowzaBaseDir = "${env:ProgramFiles(x86)}\Wowza Media Systems"
		if (!(Test-Path ($wowzaBaseDir)))
		{
			Write-BoxstarterMessage -message "Installing Wowza Streaming Engine..." -color Green
			wget -Uri http://hchcamstorage.blob.core.windows.net/installers/Wowza%20Streaming%20Engine%204.2.0.zip -OutFile "$InstallersDirectory\Wowza Streaming Engine 4.2.0.zip"
			New-Item $wowzaBaseDir -Type Directory
			$wowzaRoot = "$wowzaBaseDir\Wowza Streaming Engine 4.2.0"
			sz x -o"$wowzaBaseDir" "$InstallersDirectory\Wowza Streaming Engine 4.2.0.zip" "*"
			$wowzaBin = "$wowzaRoot\bin"
			$wowzaManagerRoot = "$wowzaRoot\manager"
			$wowzaManagerBin = "$wowzaManagerRoot\bin"
			$wowzaLauncher = "$wowzaBin\installerlauncher.exe"

			Set-Location $wowzaBin 
			&$wowzalauncher InstallWowzaStreamingEngine-Service.bat

			Set-Location $wowzaManagerBin 
			&$wowzaLauncher InstallWowzaStreamingEngineManager-Service.bat

			[Environment]::SetEnvironmentVariable("WMSAPP_HOME", $wowzaRoot, "MACHINE")
			[Environment]::SetEnvironmentVariable("WMSCONFIG_HOME", $wowzaRoot, "MACHINE")
			[Environment]::SetEnvironmentVariable("WMSINSTALL_HOME", $wowzaRoot, "MACHINE")
			[Environment]::SetEnvironmentVariable("WMSMGR_HOME", $wowzaManagerRoot, "MACHINE")
			Write-BoxstarterMessage -message "Finished installing Wowza Streaming Engine." -color Green
		}
		else
		{
			Write-BoxstarterMessage -message "Wowza Streaming Engine already installed."
		}
	}


	# Boxstarter options
	$Boxstarter.RebootOk=$true # Allow reboots?
	$Boxstarter.NoPassword=$false
	$Boxstarter.AutoLogin=$true # Save password securely and auto-login after a reboot

	# Basic Setup
	Update-ExecutionPolicy Unrestricted
	Disable-InternetExplorerESC
	Disable-UAC
	Enable-RemoteDesktop
	
	# Setup for custom installers and apps
	$installersDirectory = "C:\installers"
	$appsDirectory = "c:\apps"
	if (!(Test-Path $installersDirectory)) {New-Item $installersDirectory -Type Directory -force}
	if (!(Test-Path $installersDirectory)) {New-Item $appsDirectory -Type Directory -force}
 
	# Disable the Server Manager startup
	New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -Force -PropertyType DWORD -Value "0x1"
	
	#TODO [mrodgers 6-14-2015]: I Believe we need to update the chocolatey sources feed to pull chocolatey files from myget.org 
	# remember to make it rerunnable since this script will execute multiple times
	if (Test-PendingReboot) { Invoke-Reboot }

	# Install Visual Studio 2017 Community
	cinst visualstudio2017community -InstallArguments "/Features:WebTools SQL" -y
	cinst powershell -y
	if (Test-PendingReboot) { Invoke-Reboot }

	# Install dotnet 3.5 (not automatically enabled on 2012 server and required for sql 2014)
	#cinst dogtail.dotnet3.5sp1 -y
	#if (Test-PendingReboot) { Invoke-Reboot }

	# Install Update 4 for Visual Studio
	#cinst vs2013.4 -y
	#if (Test-PendingReboot) { Invoke-Reboot }

	# Visual Studio Extensions
	#Install-ChocolateyVsixPackage webessentials2013 https://visualstudiogallery.msdn.microsoft.com/56633663-6799-41d7-9df7-0f2a504ca361/file/105627/44/WebEssentials2013.vsix
	#Install-ChocolateyVsixPackage powershelltools https://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/156893/2/PowerShellTools.vsix
	#Install-ChocolateyVsixPackage nugettools2013 https://visualstudiogallery.msdn.microsoft.com/4ec1526c-4a8c-4a84-b702-b21a8f5293ca/file/105933/8/NuGet.Tools.2013.vsix
	#Install-ChocolateyVsixPackage slowcheetahxmltransforms https://visualstudiogallery.msdn.microsoft.com/69023d00-a4f9-4a34-a6cd-7e854ba318b5/file/55948/26/SlowCheetah.vsix
	
	# Web Platform Installer (get a full list of packages you can install from webpi using "clist -source webpi")
	#cinst webpicmd -y #This installs dependency lessmsi
	#cinst VWDOrVs2013AzurePack.2.5, windowsazurepowershell -source webpi -y #The install reports failure but all components look to be installed
	#TODO [mrodgers 6-14-2015]: why does the preceeding command fail, yet everything is installed?
	# Windows Azure SDK 2.5 installs the following:
	#	Microsoft Azure Storage Tools - 3.0.0
	#	Microsoft Azure Authoring Tools - 2.5.1
	#	Windows Azure Storage Emulator - 3.4
	#	Microsoft Azure Compute Emulator - 2.5
	#	Microsoft Azure SDK - 2.5 for Visual Studio 2013


	#cinst mssqlservermanagementstudio2014express -y
	#if (Test-PendingReboot) { Invoke-Reboot }

	#cinst 7zip -y
	#Set-Alias sz "$env:ProgramFiles\7-zip\7z.exe"

	#install_java
	#cinst maven -version 3.2.5 -y
	cinst notepadplusplus -y
	cinst wget -y
	cinst google-chrome-x64 -y
	cinst conemu -y
	#cinst resharper -version 8.1.23.546 -y 
	cinst git -y
	#cinst kdiff3 -y  
	cinst git-credential-winstore -y
	cinst fiddler -y
	#cinst intellijidea-community -y
	cinst sourcetree -y 
	#cinst vlc -y 
	#cinst winmerge -y 
	cinst curl -y
	#cinst rtmpdump -y
	#cinst ffmpeg -y
	cinst azurepowershell -y
	cinst azure-cli -y
	cinst azcopy -y
	cinst powershell-core -y
	cinst microsoftazurestorageexplorer -y
	cinst winrar -y
	cinst vscode -y
	cinst vscode-powershell -y
	cinst vscode-icons -y
	cinst royalts -y
	cinst beyondcompare -y
	cinst dropbox -y
	cinst openssl.light -y
	cinst bginfo -y
	cinst postman -y
	cinst python
	pip install sfctl
	#install_azuremanagementstudio
	#install_servicebusexplorer
	#install_wowza

	#TODO [mrodgers 6-14-2015]: Create installers and find a home to host the following:
	#MicrosoftAzureStorageTools_v3.msi


	# install Windows features
	cinst IIS-WebServerRole -source windowsfeatures -y
	cinst TelnetClient -source windowsfeatures -y
	cinst IIS-WebSockets -source windowsfeatures -y
	if (Test-PendingReboot) { Invoke-Reboot }

	# Download an Aescentia desktop background.
	#wget -Uri http://static1.squarespace.com/static/52d06f0ae4b02674e5623178/533dbc29e4b063017f76444d/533de803e4b099c54d48eb0b/1433149919198/The-Standard-%28Ae%29---2880x1800-%28MBP-15-Retina%29---16.10.png -OutFile "$env:LocalAppData\Aescentia2880x1800.png"
	#wget -Uri http://static1.squarespace.com/static/52d06f0ae4b02674e5623178/533dbc29e4b063017f76444d/533de802e4b099c54d48eb03/1396566128855/The-Standard-%28Ae%29---1024x768---4.3.png -OutFile "$env:LocalAppData\Aescentia1024x768.png"
	#wget -Uri http://static1.squarespace.com/static/52d06f0ae4b02674e5623178/533dbc29e4b063017f76444d/533de803e4b0f92a7a6447a7/1396566146694/The-Standard-%28Ae%29---1280x720-%28HD-720%29---16.9.png -OutFile "$env:LocalAppData\Aescentia1280x720.png"
	#wget -Uri http://static1.squarespace.com/static/52d06f0ae4b02674e5623178/533dbc29e4b063017f76444d/533de802e4b099c54d48eb05/1396566159737/The-Standard-%28Ae%29---1366x768---16.9.png -OutFile "$env:LocalAppData\Aescentia1336x768.png"
	#wget -Uri http://static1.squarespace.com/static/52d06f0ae4b02674e5623178/533dbc29e4b063017f76444d/533de803e4b099c54d48eb07/1396566175657/The-Standard-%28Ae%29---1440x900-%28MBP-15%29---16.10.png -OutFile "$env:LocalAppData\Aescentia1440x900.png"
	#wget -Uri http://static1.squarespace.com/static/52d06f0ae4b02674e5623178/533dbc29e4b063017f76444d/533de803e4b099c54d48eb09/1396566190133/The-Standard-%28Ae%29---1680x1050---16.10.png -OutFile "$env:LocalAppData\Aescentia1680x1050.png"
	#wget -Uri http://static1.squarespace.com/static/52d06f0ae4b02674e5623178/533dbc29e4b063017f76444d/533de803e4b0f92a7a6447a9/1396566202961/The-Standard-%28Ae%29---1920x1080-%28HD-1080%29---16.9.png -OutFile "$env:LocalAppData\Aescentia1920x1080.png"

	#Set-ItemProperty -path "HKCU:Control Panel\Desktop" -name wallpaper -value "$env:LocalAppData\AescentiaBackground.png"

	Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

	#taskbar items
	Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
	Install-ChocolateyPinnedTaskBarItem "$env:ProgramFiles\ConEmu\ConEmu64.exe"
	Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Atlassian\SourceTree\SourceTree.exe"
	Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\code4ward.net\Royal TS V4\RoyalTS.exe"
	Install-ChocolateyPinnedTaskBarItem "$env:ProgramFiles\Microsoft VS Code\Code.exe"
	#Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Microsoft SQL Server\120\Tools\Binn\ManagementStudio\ssms.exe"
	#Install-ChocolateyPinnedTaskBarItem "$env:ProgramFiles\NUnit-2.6.4\bin\nunit.exe"
	
	Install-Module AzureAD -force

	# Update Windows and reboot if necessary
	Install-WindowsUpdate -AcceptEula
	if (Test-PendingReboot) { Invoke-Reboot }
	
	#TODO [mrodgers 6-14-2015]: Find and install a click-once plugin for Chrome (so BoxStarter START command will work with Chrome)

