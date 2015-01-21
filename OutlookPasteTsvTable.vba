Sub PasteFormattedTable()
    Dim doc As Word.Document
    Dim sel As Word.Selection
    Dim start As Integer
    Set doc = Application.ActiveInspector.WordEditor
    Set sel = doc.Windows(1).Selection
    start = sel.start
    sel.PasteSpecial Link:=False, DataType:=wdPasteText
    sel.start = start
    sel.ConvertToTable DefaultTableBehavior:=wdWord9TableBehavior, AutoFitBehavior:=wdAutoFitContent
    styles = Array(-162, -208, -250, -222, -236, -176, -194)
    sel.Style = styles(doc.Tables.Count Mod (UBound(styles) + 1))
End Sub