📚 ISBN Multi-Tab Scanner (v1.2+)
An automated AutoHotkey (AHK) tool designed for library volunteer groups (like the Friends of the Library) to streamline ISBN processing across multiple web platforms simultaneously.

🚀 What it Does
When you scan a barcode or type an ISBN and hit Enter, this script:

Captures the ISBN.

Logs it with a timestamp to your local Documents folder.

Automates the browser by tabbing through multiple Chrome pages, pasting the ISBN, and hitting search on each one automatically.

By default the script tabs through 3 Chrome tabs, but if you want more (or
less), you can specify a different number as a command line parameter.  Whatever
number you choose, exactly that number of Chrome tabs must be open.  If you choose 4 as the number of tabs, you must have 4 tabs open.  Then when you scan an ISBN into one of the tabs, the script will paste that ISBN into each of the open tabs.  A further requirement is that each tab must have the cursor in a compatible ISBN field, ready and waiting for data entry.

🛠️ Setup & Installation
1. Requirements
Windows 10/11 (HP, Toshiba, and other retired hardware supported!)

AutoHotkey v2.0+ must be installed.

Google Chrome (with the desired buyer tabs already open).

2. How to "Compile" into an EXE
Compiling the script into an .exe allows it to run on computers that don't have AutoHotkey installed:

Right-click the ISBN_Scanner.ahk file.

Select Compile Script (this uses the Ahk2Exe utility).

A new file named ISBN_Scanner.exe will appear. This is your "ready-to-use" program.

3. Creating a Shortcut with Parameters
You can tell the script exactly how many browser tabs to process by using a Windows Shortcut:

Right-click your .exe file and select Create shortcut.

Right-click the new shortcut and select Properties.

In the Target box, add a space and then the number of tabs at the end.

Example: "C:\Path\To\ISBN_Scanner.exe" 3

Click OK. Now, launching this shortcut will specifically use 3 tabs.

4. How to Make it Auto-Start
To ensure the scanner is ready as soon as the computer turns on:

Press Win + R on your keyboard.

Type shell:startup and hit Enter.

Copy and paste your Shortcut into this folder.

🎮 How to Use
Turn ON/OFF: Press F1.

Red Box: Scanner is OFF.

Green Box: Scanner is READY.

Scanning: Use your barcode scanner or numeric keypad as usual.

Stop/Exit: Right-click the H icon in your system tray (near the clock) and select Exit.

📂 Logging
The script automatically finds your user profile and saves a log at:
Documents\AutoHotkey\AutoScanner.log

Friendly Note for Volunteers
This script was built to handle older hardware and prevent "ghost windows". If the status box says v1.2, you have the latest version with improved support for numeric keypads and manual pasting.