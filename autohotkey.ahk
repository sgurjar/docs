; HOTSTRINGS
; HOTKEYS

; ==================================================
; #SingleInstance says that if I load up my AutoHotKey script
; and there is already one loaded, then just use the new one
; without prompting. If you make changes to your script file,
; you can double click the file to reload it. This way you won’t
; get annoying prompts when you do so. This has to be the first
; line in your AHK file if you use it.
#SingleInstance

; ==================================================
; By default, AHK puts a slight delay between each keystroke in
; a macro. I have no idea why you would normally want this, so the
; above line removes that delay and it will execute the keystrokes
; as fast as possible. http://jonkruger.com/blog/2010/09/07/whats-in-my-autohotkey-file/
SetKeyDelay, -1

; ==================================================
; Remaps Caps Lock to End.
CapsLock::
Send {Delete}
return

; ==================================================
; Shift-Caps Lock will now toggle Caps Lock. Because sometimes you actually do need Caps Lock.
+Capslock::Capslock

; ==================================================
; window key + k
#k::
IfWinExist, ahk_class KMeleon Browser Window
{
    WinActivate
    return
}
else
{
    Run C:\tools\k-meleon\K-Meleon1.5.4\k-meleon.exe
    return
}

; ==================================================
; window key + k
#x::
IfWinExist, ahk_class MozillaWindowClass
{
    WinActivate
    return
}
else
{
    Run c:\tools\firefox\firefox.exe
    return
}


; ==================================================
#c::
IfWinExist, ahk_class Console_2_Main
{
    WinActivate
    return
}
else
{
    Run C:\tools\Console2\Console.exe
    return
}

; ==================================================
#t::
Run C:\tools\EditPlus\3.10\editplus.exe ; editplus support single instance
WinMaximize
return

; ==================================================
#e::
IfWinExist, ahk_class TfcForm
{
    WinActivate
    return
}
else
{
    Run C:\tools\filemgr\fc\bin\FreeCommander.exe
    return
}

; ==================================================
#o::
IfWinExist, ahk_class rctrl_renwnd32
{
    WinActivate
    return
}
else
{
    Run "C:\Program Files\Microsoft Office\Office12\OUTLOOK.EXE"  /recycle
    return
}

; ==================================================
; CtrlShiftEsc
^+Esc::
IfWinExist, ahk_class PROCEXPL
{
    WinActivate
    return
}
else
{
    Run C:\tools\sysinternals\bin\procexp.exe
    return
}


; ==================================================
#p::
IfWinExist, PuTTY Connection Manager
{
    WinActivate
    return
}
else
{
    Run C:\tools\PuTTY\puttycm.exe
    return
}

; ==================================================
#i::
IfWinExist, ahk_class IEFrame
{
 WinActivate
 return
}
else
{
 Run "C:\Program Files\Internet Explorer\iexplore.exe"
 return
}

; ==================================================
; ctrl+shift+insert paste in all windows
#Ins::
SendRaw %clipboard%

; ==================================================
; Convert any copied files, HTML, or other formatted
; text to plain text.
^+c::
clipboard = %clipboard%

; ==================================================
; use WinKey+LeftArrow as Home
#Left::
send {Home}
return

; ==================================================
; use WinKey+RightArrow as End
#Right::
send {End}
return

; ==================================================
; use WinKey+LeftArrow as Home
#Up::
send ^{Home}
return

; ==================================================
; use WinKey+RightArrow as End
#Down::
send ^{End}
return

; ==================================================
; search google with clipboard
#s::
run k.bat http://www.google.com/search?q=%clipboard%
return

; ==================================================
; Reload this AutoHotKey script
; Win-Shift-Ctrl-R
#^+r::
  SoundPlay *64
  Reload
  Sleep 1000
  MsgBox 4, , Script reloaded unsuccessful, open it for editing?
  IfMsgBox Yes, Edit
return

^w::
	Send ^{f4}
return

#w::
	Send !{f4}
return