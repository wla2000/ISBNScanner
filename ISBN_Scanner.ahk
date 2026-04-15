#Requires AutoHotkey v2.0
SetTitleMatchMode 2

; --- Global Variables ---
Global Active := False
Global ScannerHook := InputHook("V", "{Enter}") 
Global RecentScans := []

; --- Create the Persistent Status Window ---
MyGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "ScannerStatus")
MyGui.BackColor := "B22222" 
MyGui.SetFont("s10 w700 cWhite", "Verdana")

; Increased h (height) to 50 to prevent text clipping
StatusHeader := MyGui.Add("Text", "Center w250 h50", "`nAUTO SCANNER OFF`nPress F1 to turn on")

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
        StatusHeader.Text := "`nAUTO SCANNER READY`nPress F1 to turn off"
        MyGui.BackColor := "228B22" ; Forest Green
        ScannerHook.Start()
    } else {
        StatusHeader.Text := "`nAUTO SCANNER OFF`nPress F1 to turn on"
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
    
    ; GUARDRAIL: Only run if Chrome is the foreground window
    if !WinActive("ahk_exe chrome.exe") {
        ScannerHook.Start()
        return
    }
	
    ; Clean the input: Keep numbers and the 'X' (for ISBN-10)
    CleanISBN := RegExReplace(ScannedText, "[^0-9Xb]", "") 
    
    if (StrLen(CleanISBN) < 9) {
        ScannerHook.Start()
        return
    }

    ; Update the Log History
    RecentScans.InsertAt(1, CleanISBN)
    if (RecentScans.Length > 3)
        RecentScans.Pop()
    
    LogText := ""
    for index, val in RecentScans
        LogText .= val . "`n"
    LogDisplay.Value := LogText

    ; The Carousel: Tab to the next 2 tabs, then return to start
    Loop 2 {
        Send "^{Tab}"
        Sleep 500 ; Half-second pause for browser rendering
        Send "^a{Backspace}"
        SendText CleanISBN
        Send "{Enter}"
    }
    
    ; Return to the original starting tab
    Send "^{Tab}"
    
    ; Restart the listener for the next barcode
    ScannerHook.Start()
}