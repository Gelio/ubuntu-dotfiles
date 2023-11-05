; Win + `123 to focus windows
#`::WinActivate, ahk_exe WindowsTerminal.exe
#1::WinActivate, ahk_exe chrome.exe
#2::WinActivate, ahk_exe Franz.exe
#3::WinActivate, ahk_exe Code - Insiders.exe

; Ctrl + Win + hl to change workspaces
#^h::Send {LWin down}{LCtrl down}{Left}
#^l::Send {LWin down}{LCtrl down}{Right}

; vim keys during alt-tab
#IfWinActive, ahk_class MultitaskingViewFrame
	!h::Send {LAlt down}{Left}
	!j::Send {LAlt down}{Down}
	!k::Send {LAlt down}{Up}
	!l::Send {LAlt down}{Right}
#IfWinActive

; Win + Shift + hjkl to move focus
#+h::FocusClosestWindow("GetDistanceLeft", "IsOverlappingHorizontal")
#+l::FocusClosestWindow("GetDistanceRight", "IsOverlappingHorizontal")
#+k::FocusClosestWindow("GetDistanceUp", "IsOverlappingVertical")
#+j::FocusClosestWindow("GetDistanceDown", "IsOverlappingVertical")

FocusClosestWindow(GetDistance, IsOverlapping)
{
	NegativeDistanceThreshold := -80
	WinGet, activeWindowID, ID, A
	
	WinGet, windowID, List
	windowIDToFocus := ""
	closestDistance := 9999999
	Loop, %windowID%
	{
		currentWindowID := windowID%A_Index%
		WinGetTitle, Title2, ahk_id %currentWindowID%
		If (Title2 == "" or !%IsOverlapping%(activeWindowID, currentWindowID))
			continue

		distance := %GetDistance%(activeWindowID, currentWindowID)
		If (distance >= NegativeDistanceThreshold and distance < closestDistance)
		{
			closestDistance := distance
			windowIDToFocus := currentWindowID
		}
	}

	If (windowIDToFocus != "")
		WinActivate, ahk_id %windowIDToFocus%
}

GetDistanceLeft(activeWindowID, currentWindowID)
{
	WinGetPos, X1, Y1, Width1, Height1, ahk_id %activeWindowID%
	WinGetPos, X2, Y2, Width2, Height2, ahk_id %currentWindowID%

	return X1 - (X2 + Width2)
}

GetDistanceRight(activeWindowID, currentWindowID)
{
	WinGetPos, X1, Y1, Width1, Height1, ahk_id %activeWindowID%
	WinGetPos, X2, Y2, Width2, Height2, ahk_id %currentWindowID%

	return X2 - (X1 + Width1)
}

GetDistanceUp(activeWindowID, currentWindowID)
{
	WinGetPos, X1, Y1, Width1, Height1, ahk_id %activeWindowID%
	WinGetPos, X2, Y2, Width2, Height2, ahk_id %currentWindowID%

	return Y2 - (Y1 + Height1)
}

GetDistanceDown(activeWindowID, currentWindowID)
{
	WinGetPos, X1, Y1, Width1, Height1, ahk_id %activeWindowID%
	WinGetPos, X2, Y2, Width2, Height2, ahk_id %currentWindowID%

	return Y1 - (Y2 + Height2)
}

IsOverlappingHorizontal(id1, id2)
{
	WinGetPos, X1, Y1, Width1, Height1, ahk_id %id1%
	WinGetPos, X2, Y2, Width2, Height2, ahk_id %id2%

	return IsOverlapping(Y1, Height1, Y2, Height2)
}

IsOverlappingVertical(id1, id2)
{
	WinGetPos, X1, Y1, Width1, Height1, ahk_id %id1%
	WinGetPos, X2, Y2, Width2, Height2, ahk_id %id2%

	return IsOverlapping(X1, Width1, X2, Width2)
}

; Checks whether there is some overlap between 2 windows on a given dimension
; Necessary to check when switching focus in some direction
IsOverlapping(start1, len1, start2, len2)
{
	end1 := start1 + len1
	end2 := start2 + len2

	if (start1 <= start2)
		return end1 >= start2
	else
		return end2 >= start1
}
