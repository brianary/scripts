' Outlook will strip single-space indents when displaying emails.
' If you've got, for example, syntax highlighted source code that employs
' any indentation of only one space, you'll want to add two spaces to the
' each line (adding one will not appear for text that isn't indented).
' This Outlook script will paste formatted text, and indent it.
' Requires Tools -> References -> Microsoft Word 14.0 Object Library (later versions may also work)

Sub PasteTextFormattedIndented()
    Dim doc As Word.Document
    Dim sel As Word.Selection
    Dim start As Integer
    Dim finish As Integer
    Dim re As Object
    Set doc = Application.ActiveInspector.WordEditor
    Set sel = doc.Windows(1).Selection
    start = sel.start
    sel.PasteSpecial Link:=False, DataType:=wdPasteRTF
    sel.start = start
    finish = sel.End
    sel.End = start
    While sel.start < finish
        sel.HomeKey
        sel.TypeText "  "
        sel.MoveDown wdLine, 1
        finish = finish + 2
    Wend
    finish = finish
    sel.start = start
    sel.End = finish
End Sub
