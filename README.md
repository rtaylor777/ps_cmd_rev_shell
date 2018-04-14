# Combined PowerShell and CMD Reverse Shell

**Credit:** Based on the PowerShell reverse shell one-liner provided by Nikhil Mittal:

https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcpOneLine.ps1

**Disclaimer:** These scripts are provided for educational purposes only and for use by Ethical Hackers. Use only on systems for which you have acquired all the legally required contracts and permissions for use. It is your responsibility to determine whether you are legally permitted to use these scripts in your country and for your purposes. No warrantee or guarantees are provided.

**Tested on** PowerShell version 2 and up.

**Intro:**
This is a psudo cmd.exe reverse shell. I designed this shell to support some PowerShell convenience commands such as 'cd','exit','d:','pwd','ls','ps','rm','cp','mv','cat'.

Simply add more of them to the array if you wish to support more. Also, if you are determined to only support CMD commands when at the CMD prompt then reduce the list. Bear in mind that 'cd,'exit',and 'd:' are required, if you remove them you will be unable to make persistent changes to other drives or directories and you will not be able to use the exit command to exit the shell.

The script is intended to be launched with the -NonI (non interactive) option of powershell. The result of not running it like this is that PowerShell will try to interactively prompt for missing parameters and your shell will be locked up. As a result of the -NonI option, if you fail to provide the required parameters to a PowerShell command you will not see any error messages, the command simply will not work. So if you are having issues with a command's syntax, be sure to test on your own Windows system from an interactive PowerShell prompt.

This shell doubles as a PowerShell shell. Type $ps on the cmd command line and the shell will switch to a PowerShell shell from the cmd.exe shell. Then type $ps=$false in the PowerShell shell and you will switch back to running commands through cmd.exe. 

The reality is that PowerShell is calling 'cmd.exe /c' for every cmd command that you enter, so in effect PowerShell is the parent, cmd.exe the child and the only environment change that persists between commands happens in PowerShell. For this reason I had to catch any directory or drive letter change and execute them in PowerShell, otherwise the change would not persist between one call to cmd.exe and the next.

