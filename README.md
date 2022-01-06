# Update-hosts-blacklist
Updates hosts blacklist for my home router for adblocking, or blocking access to other unwanted domains.

Steps:

1. Find a domain blacklist hosts file
    * such as https://hosts.oisd.nl/basic/

2. Have a DFS share for your hosts file and a user account having RW permissions to this share

3. Automate this script with Windows Task Scheduler
   * Mandatory parameters for script:
     * URL: direct download link to blacklist host file
     * Destination: DFS share path
     * Username: DFS Username with permissions to read and write Destination
     * PasswordFile: File with Powershell Securestring converted password string
       * Securestring your password with Powershell:
       * Write to Powershell -> "password" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString > pw.txt
     * OutputFile: File name to be saved to Destination
   * Set Task Manager to run this automation with current user, even if the user is not logged in (makes it invisibly run in the background)
   * Task Manager NEEDS to run this script with the same Windows User Account that you used to create the SecureString! SecureString can't be read by other accounts when created without a key.

 4. Configure your router to include this hosts file to DNS requests


Example how to run this script with Powershell. This can be placed to Task Manager or ran manually.


Powershell.exe -File "C:\Users\MyName\Documents\Automation\run.ps1" -URL "https://hosts.oisd.nl/basic/" -Destination "\\Router\Hosts\" -Username "MyUsername" -PasswordFile "C:\Users\MyName\Documents\Automation\pw.txt" -OutputFile "oisd_hosts_basic.txt"


My personal recommendation of DNS Servers for your router or mobile: Quad9 https://www.quad9.net/
