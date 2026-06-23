#Requires AutoHotkey v2.0
#SingleInstance Force ; Kills old "ghost" windows automatically
SetTitleMatchMode 2

; Retrieve command line parameters
NumChromeTabs := (A_Args.Length >= 1) ? A_Args[1] : 3 ; Default to 3 tabs
SleepTime := (A_Args.Length >= 2) ? A_Args[2] : 500 ; Default to 500ms

; --- Global Variables ---
Version := "v1.4" ; Track updates across the HP and Toshibas 
UserPath := EnvGet("USERPROFILE") ; Dynamic path for different library PCs 
Global LogFile := UserPath . "\Documents\AutoHotkey\AutoScanner.log"
Global Active := False
Global ScannerHook := InputHook("V", "{Enter}{NumpadEnter}") 
Global RecentScans := []

; FIX 2: Added a specific Hotkey for manual entries (Pasting/Typing)
; This forces the script to process whatever is currently in the active field
~Enter::
~NumpadEnter::
{
    if (Active && WinActive("ahk_exe chrome.exe")) {
        ; If the hook is running, stop it to trigger ProcessScan
        ScannerHook.Stop() 
    }
}

; --- Create the Persistent Status Window ---
MyGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "ScannerStatus")
MyGui.BackColor := "B22222" 
MyGui.SetFont("s10 w700 cWhite", "Verdana")

; Display version number in the header for easy identification
StatusHeader := MyGui.Add("Text", "Center w250 h75", "`nAUTO SCANNER OFF (" Version ")`n " NumChromeTabs " Tabs, Delay: " SleepTime " ms`nPress F1 to turn on")

; Log Area - increased h to 70 for better spacing
MyGui.SetFont("s9 w400 cWhite", "Consolas")
LogDisplay := MyGui.Add("Text", "Center w250 h70", "`n(Waiting for scan...)")

; Show the window
MyGui.Show("xCenter y0 NoActivate")

; Make the window draggable (Left-click and hold anywhere on the box)
OnMessage(0x0201, WM_LBUTTONDOWN)
WM_LBUTTONDOWN(*) {
    PostMessage(0xA1, 2,,, "A")
}

F1:: {
    Global Active := !Active
    SoundBeep(Active ? 750 : 500)
    
    if (Active) {
        StatusHeader.Text := "`nAUTO SCANNER READY(" Version ")`n" NumChromeTabs " Tabs, Delay: " SleepTime " ms`nPress F1 to turn off"
        MyGui.BackColor := "228B22" ; Forest Green
        ScannerHook.Start()
    } else {
        StatusHeader.Text := "`nAUTO SCANNER OFF(" Version ")`n" NumChromeTabs " Tabs, Delay: " SleepTime " ms`nPress F1 to turn on"
        MyGui.BackColor := "B22222" ; Firebrick Red
        ScannerHook.Stop()
    }
}

ScannerHook.OnEnd := (Hook) => ProcessScan(Hook.Input)

ProcessScan(ScannedText) {
    Global RecentScans
	
	; If the operator turned the scanner OFF, exit immediately.
    ; Also exit if the scanned text is empty (which happens when stopping).
    if (!Active) {
        return
    }

    if (ScannedText == "") {
        ScannedText := A_Clipboard
    }
    
    ; GUARDRAIL: Only run if Chrome is the foreground window
    if !WinActive("ahk_exe chrome.exe") {
        ScannerHook.Start()
        return
    }
	
    ; Clean the input: Keep numbers and the 'X' (for ISBN-10)
    CleanISBN := RegExReplace(ScannedText, "[^0-9Xxb]", "") 
    
    if (StrLen(CleanISBN) < 9) {
        ScannerHook.Start()
        return
    }

    ; Update the Log History
    ReadableDate := FormatTime(, "MM/dd/yyyy HH:mm:ss ")
    FileAppend(ReadableDate CleanISBN "`n", LogFile)
    RecentScans.InsertAt(1, CleanISBN)
    if (RecentScans.Length > 3)
        RecentScans.Pop()
    
    LogText := ""
    for index, val in RecentScans
        LogText .= val . "`n"
    LogDisplay.Value := LogText

    ; The Carousel: Tab to the next 2 tabs, then return to start
    Loop (NumChromeTabs - 1) {
        Send "^{Tab}"
        Sleep SleepTime ; pause for browser rendering
        Send "^a{Backspace}"
        SendText CleanISBN
        Send "{Enter}"
    }
    
    ; Return to the original starting tab
    Send "^{Tab}"
    
    ; Restart the listener for the next barcode
    ScannerHook.Start()
}