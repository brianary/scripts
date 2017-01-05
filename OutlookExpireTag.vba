' Too many emails remain beyond their period of relevance: daily personnel schedule changes, 
' found item notices, office food notices, server reboot notices, weather/traffic warnings, &c.
' This Outlook script will allow specifying an expiration date as a hashtag in the subject
' of outgoing emails, since Outlook does such a good job of hiding the UI for that field. -BL

Public WithEvents Item As Outlook.MailItem

Private Function DateUnit(ByVal isoUnit, ByVal isYmwdPart) As String
    Select Case isoUnit
        Case "Y": DateUnit = "yyyy"
        Case "W": DateUnit = "ww"
        Case "M":
            If isYmwdPart Then
                DateUnit = "m"
            Else
                DateUnit = "n"
            End If
        Case Else: DateUnit = isoUnit
    End Select
End Function

Private Function AddIsoDuration(ByVal start As Date, ByVal isoDuration As String) As Date
    Dim value, durationMatch, nextPart
    value = start
    Set durationMatch = New RegExp
    durationMatch.Pattern = "^(P((\d+[YMWD])*)(T((\d+[HMS])+))?)$"
    Set nextPart = New RegExp
    nextPart.Pattern = "^(\d+)([YMWDHMS])"
    Set matched = durationMatch.Execute(isoDuration)(0)
    ymwd = matched.SubMatches(1)
    hms = matched.SubMatches(4)
    Do Until Len(ymwd) = 0
        Set part = nextPart.Execute(ymwd)(0)
        value = DateAdd(DateUnit(part.SubMatches(1), True), CInt(part.SubMatches(0)), value)
        ymwd = Mid(ymwd, Len(part) + 1)
    Loop
    Do Until Len(hms) = 0
        Set part = nextPart.Execute(hms)(0)
        value = DateAdd(DateUnit(part.SubMatches(1), False), CInt(part.SubMatches(0)), value)
        hms = Mid(hms, Len(part) + 1)
    Loop
    AddIsoDuration = value
End Function

Private Sub Application_ItemSend(ByVal Item As Object, Cancel As Boolean)
    Dim durationMatch
    Set durationMatch = New RegExp
    durationMatch.Pattern = "#(P(\d+[YMWD])*(T(\d+[HMS])+)?)\b"
    ExpiryTime = Item.ExpiryTime
    If InStr(1, Item.Subject, "#today", vbTextCompare) > 0 Then
        If ExpiryTime = #1/1/4501# Then
            Item.ExpiryTime = DateAdd("d", 1, Date)
        End If
    ElseIf durationMatch.Test(Item.Subject) Then
        If ExpiryTime = #1/1/4501# Then
            Item.ExpiryTime = AddIsoDuration(Now, durationMatch.Execute(Item.Subject)(0).SubMatches(0))
        End If
    End If
    Item.Save
End Sub
