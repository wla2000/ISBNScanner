# 📚 ISBN Multi-Tab Scanner (v1.2+)

[cite_start]An automated AutoHotkey (AHK) tool designed for library volunteer groups to streamline ISBN processing across multiple web platforms simultaneously[cite: 2, 4]. [cite_start]This script is particularly useful for organizations that need to compare book values across different buyers or marketplaces quickly.

## 🚀 Key Features
* [cite_start]**Multi-Tab Automation:** Automates the browser by tabbing through a customizable number of Chrome pages, pasting the ISBN, and hitting search on each one.
* [cite_start]**Hardware Friendly:** Optimized to run on older hardware (like retired library HPs or "ancient" laptops) without lagging.
* [cite_start]**Robust Logging:** Automatically captures every scan with a timestamp to a local log file using dynamic user paths.
* [cite_start]**Input Flexibility:** Recognizes barcode scanners, manual typing (including the numeric keypad), and pasted ISBNs[cite: 2, 4].
* [cite_start]**Single-Instance Force:** Built-in logic to prevent multiple "ghost" windows from running at once.

## 🛠️ Setup & Execution

### 1. Requirements
* [cite_start]**Windows 10/11**.
* [cite_start]**AutoHotkey v2.0+** installed on the machine.
* **Google Chrome** opened to the tabs you wish to search.

### 2. How to Compile into an EXE
If you want to run this as a standalone program:
1.  Right-click the `ISBN_Scanner.ahk` file.
2.  Select **Compile Script** (using the `Ahk2Exe` utility).
3.  This creates an `ISBN_Scanner.exe` which can be shared with other computers.

### 3. Command Line Parameters (Custom Tabs)
You can define how many Chrome tabs the "Carousel" should visit by using a Windows Shortcut:
1.  Right-click your `.exe` (or `.ahk`) file and select **Create shortcut**.
2.  Right-click the shortcut and select **Properties**.
3.  In the **Target** box, add a space and your desired tab count at the end:
    * *Example:* `"C:\Path\To\Scanner.exe" 3`
4.  The status window will display the active tab count upon launch.

### 4. How to Make it Auto-Start
To have the scanner ready for volunteers as soon as Windows boots:
1.  Press `Win + R`, type `shell:startup`, and hit **Enter**.
2.  [cite_start]Paste your **Shortcut** into this folder.

## 🎮 Controls
* **F1:** Master Toggle.
    * [cite_start]**Red Window:** Scanner is OFF[cite: 2, 4].
    * [cite_start]**Green Window:** Scanner is ACTIVE[cite: 2, 4].
* **Exit:** Right-click the **H** icon in the system tray and select **Exit**.

## 📂 Data & Logging
The script uses `EnvGet` to find the correct local directory regardless of the Windows username:
[cite_start]`Documents\AutoHotkey\AutoScanner.log`