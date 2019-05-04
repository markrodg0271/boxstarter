#This script is used to setup the local development environment and tools required to modify the files in this project
#The script needs to be run only once

#Download Boxstarter from Chocolatey
choco install boxstarter

#Download the Boxstarter.Chocolatey cmdlets
choco install boxstarter.chocolatey

#set the boxstarter local repository
Set-BoxStarterConfig -LocalRepo $PSScriptRoot + "/BoxstarterRepository"
