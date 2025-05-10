MsgBox "meh_shortcuts: (re)started..."
SoundBeep, 750, 500
;#	Win (Windows logo key)
;!	Alt
;^	Ctrl
;+	Shift
;&	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey.


;WinActivate
;Activates the specified window.
;
;WinActivate , WinTitle, WinText, ExcludeTitle, ExcludeText
;
;SetTitleMatchMode
;Sets the matching behavior of the WinTitle parameter in commands such as WinWait.
;
;SetTitleMatchMode, MatchMode
;SetTitleMatchMode, Speed
;Parameters
;MatchMode
;Specify one of the following digits or the word RegEx:
;
;1 = A window's title must start with the specified WinTitle to be a match.
;2 = A window's title can contain WinTitle anywhere inside it to be a match.
;3 = A window's title must exactly match WinTitle to be a match.

;^!+ = meh = alt + ctrl + Shift
;swap meh(^!+s) with (CapsLock) to use caps as modifier


^!+n::CycleWindowsByTitle("Notepad", "%windir%\\system32\\notepad.exe")
^!+e::CycleWindowsByTitle("- Excel", "C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE")
^!+c::CycleWindowsByTitle("Visual Studio Code", "C:\\Users\\cmoir\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe")
^!+g::CycleWindowsByTitle("Google Chrome", "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe")
^!+t::CycleWindowsByTitle("Microsoft Teams", "C:\Users\cmoir\AppData\Local\Microsoft\WindowsApps\ms-teams.exe")
^!+s::CycleWindowsByTitle("- Sublime Text", "C:\Program Files\Sublime Text 3\sublime_text.exe")
^!+v::CycleWindowsByTitle("Microsoft Visual Studio", "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe")
^!+k::CycleWindowsByTitle("KDiff3", "C:\Program Files\KDiff3\kdiff3.exe")
^!+o::CycleWindowsByTitle("- Outlook", "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE")
^!+q::CycleWindowsByTitle("- Microsoft SQL Server Management Studio", "C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe")
^!+p::CycleWindowsByTitle("Postman", "C:\Users\cmoir\AppData\Local\Postman\Postman.exe")
^!+w::CycleWindowsByTitle("Wireshark", "C:\Program Files\Wireshark\Wireshark.exe")

return

CycleWindowsByTitle(appTitle, exePath) {
    SetTitleMatchMode, 2
    WinGet, winList, List, %appTitle%

    if (winList = 0) {
        Run, %exePath%
        return
    }

    windowData := []
    Loop, %winList%
    {
        winID := winList%A_Index%
        WinGetTitle, winTitle, ahk_id %winID%
        if (winTitle != "")
            windowData.Push({id: winID, title: winTitle})
    }

    windowData.Sort("SortByTitle")

    static lastIndexMap := {}
    key := appTitle

    ; Set or reset index if needed
    if (!lastIndexMap.HasKey(key) || lastIndexMap[key] > windowData.Length())
        lastIndexMap[key] := 1

    nextID := windowData[lastIndexMap[key]].id

    ; Build message showing sorted list and selected window
    msg := "Sorted windows for " appTitle ":`n`n"
    Loop, % windowData.Length()
    {
        idx := A_Index
        sel := (idx = lastIndexMap[key]) ? " <==" : ""
        msg .= idx ": " windowData[idx].title sel "`n"
    }
    msg .= key ":" windowData.Length() " : "  lastIndexMap[key] "`n"
   ; MsgBox, 64, Window Cycle, %msg%

    WinActivate, ahk_id %nextID%

    ; Increment for next time, wrap if needed
    lastIndexMap[key]++
    if (lastIndexMap[key] > windowData.Length())
        lastIndexMap[key] := 1
}

SortByTitle(a, b) {
    return (a.title > b.title) ? 1 : (a.title < b.title) ? -1 : 0
}