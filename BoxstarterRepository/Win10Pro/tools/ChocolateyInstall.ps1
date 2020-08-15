
	# Boxstarter options
	$Boxstarter.RebootOk=$true # Allow reboots?
	$Boxstarter.NoPassword=$false
	$Boxstarter.AutoLogin=$true # Save password securely and auto-login after a reboot

	# Basic Setup
	Update-ExecutionPolicy Unrestricted
	Disable-InternetExplorerESC
	Disable-UAC
	
	Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

	Set-StartScreenOptions -EnableListDesktopAppsFirst

	Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart -EnableShowStartOnActiveScreen -EnableShowAppsViewOnStartScreen -EnableSearchEverywhereInAppsView -EnableListDesktopAppsFirst

	# Disables the Bing Internet Search when searching from the search field in the Taskbar or Start Menu.
	Disable-BingSearch
	Disable-GameBarTips

	# remember to make it rerunnable since this script will execute multiple times
	if (Test-PendingReboot) { Invoke-Reboot }

	cinst notepadplusplus -y
	cinst google-chrome-x64 -y
	cinst git -y
	cinst git-credential-winstore -y
	cinst fiddler -y
	cinst curl -y
	cinst azurepowershell -y
	cinst azure-cli -y
	cinst azcopy -y
	cinst powershell-core -y
	cinst microsoftazurestorageexplorer -y
	cinst winrar -y
	cinst vscode -y
	cinst vscode-powershell -y
	cinst vscode-icons -y
	cinst install royalts-v5 -y
	cinst beyondcompare -y
	cinst dropbox -y
	cinst openssl.light -y
	cinst steam -y

	# install Windows features
	cinst TelnetClient -source windowsfeatures -y
	if (Test-PendingReboot) { Invoke-Reboot }

	#taskbar items
	Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
	Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles}\Microsoft VS Code\Code.exe"
	Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Royal TS V5\RoyalTS.exe"

	# Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	# Install-Module AzureAD -force

	# Update Windows and reboot if necessary
	Install-WindowsUpdate -AcceptEula
	if (Test-PendingReboot) { Invoke-Reboot }

