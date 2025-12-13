' Start Language Monitor
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptPath = fso.GetParentFolderName(WScript.ScriptFullName)
psScript = Chr(34) & scriptPath & "\LanguageMonitor.ps1" & Chr(34)

WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File " & psScript, 0, False
