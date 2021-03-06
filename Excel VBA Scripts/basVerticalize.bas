Attribute VB_Name = "basVerticalize"
'*****************************************************
'Sub Verticalize()
'https://github.com/hbere/excel-vba
'For use in Excel
'
'Results:
'   1.  Inputs a Horizontal table with N dimension columns, M measure/fact columns, and R rows
'   2.  Outputs a Vertical table with N+1 columns and M*R rows
'
'Purpose:
'   1.  Create a table that can be easily summarized with a Pivot Table
'
'Usage/Assumptions:
'   1.  Input table must begin with dimension columns, reading left-to-right
'   2.  Remainder of columns to the right are measure/fact columns
'   3.  Formatting doesn't need to come through.  (For the moment, formatting is not perserved through the transformation.)
'
'*****************************************************
Sub Verticalize()
On Error GoTo ErrorHandler:

    'Declare Variables
    Dim InputRange As Range     'Range for input table
    Dim OutputRange As Range    'Range (upper-left corner) for output table

    Dim DTot As Long            'Number of dimensions (Static)
    Dim MStart As Long          'Starting column for measures
    Dim MTot As Long            'Total number of measures
    Dim MNames() As String      'Array for Measure names
    Dim DVals() As String       'Dynamic Array for Dimension values
    Dim MVals() As String       'Dynamic Array for Measure values

    Dim OutRow As Long          'Counter for output rage row
    Dim OutCol As Long          'Counter for output range column
    Dim InRow As Long           'Counter for input range row
    Dim InCol As Long           'Counter for input range column

    Dim i As Long               'All-purpose counter
    Dim j As Long               'All-purpose counter

    'Initialize Variables
    MsgBox "Note: This Macro operates under two assumptions: 1.  Input Data Range must begin with all dimension columns, left-to-right.  2.  Remainder of columns to the right are measure columns."
    Set InputRange = Application.InputBox(Title:="Input Data Range", prompt:="Please select or enter the input table range.  It can be a normal Excel range (e.g. $A$1:$D$5) or a named range (e.g. MyTable)", Type:=8)
    DTot = Application.InputBox(Title:="Dimensions", prompt:="How many dimensions columns are there?", Type:=1)
    Set OutputRange = Application.InputBox(Title:="Output Data Range.", prompt:="Please select the upper-left cell of where you'd like the output to appear.", Type:=8)
    MStart = DTot + 1
    MTot = InputRange.Columns.Count - DTot
    ReDim MNames(MTot)
    ReDim DVals(DTot)
    ReDim MVals(MTot)

    'Configure Environment
    Application.ScreenUpdating = False

    'Paste the Title Row
    For i = 1 To DTot
        OutputRange.Cells(1, i) = InputRange.Cells(1, i)
    Next i
    OutputRange.Cells(1, i) = "Measure Name"
    i = i + 1
    OutputRange.Cells(1, i) = "Measure Value"

    'Populate Measure Names array
    For i = 1 To MTot
        j = MStart + i - 1
        MNames(i) = InputRange.Cells(1, j)  'SAVE Measure NAMES IN ARRAY
    Next i

    'Transform the data
    OutRow = 2
    'Cycle through input rows starting with row 2
    For InRow = 2 To InputRange.Rows.Count  'FOR EACH INPUT TABLE ROW

        'Activate input workbook, sheet, and range
        Workbooks(InputRange.Worksheet.Parent.Name).Sheets(InputRange.Parent.Name).Activate
        InputRange.Activate

        'Populate Dimension Values Array
        For i = 1 To DTot  'SAVE DIMENSION NAMES IN ARRAY
            DVals(i) = InputRange.Cells(InRow, i)
        Next i

        'Populate Measure Values Array
        For i = 1 To MTot  'SAVE DIMENSION NAMES IN ARRAY
            j = MStart + i - 1
            MVals(i) = InputRange.Cells(InRow, j)
        Next i

        'Activate output workbook, sheet, and range
        Workbooks(OutputRange.Worksheet.Parent.Name).Sheets(OutputRange.Parent.Name).Activate
        OutputRange.Activate

        'Paste Everything in Output Range
        For j = 1 To MTot  'FOR [Count(Measures)] OUTPUT TABLE ROWS
            OutCol = 1
            For i = 1 To DTot  'FOR EACH DIMENSION
                OutputRange.Cells(OutRow, OutCol) = DVals(i)  'PASTE IN DIMENSION NAME ONE PER CELL IN OUTPUT TABLE ROW
                OutCol = OutCol + 1
            Next i
            OutputRange.Cells(OutRow, OutCol) = MNames(j)
            OutCol = OutCol + 1
            OutputRange.Cells(OutRow, OutCol) = MVals(j)
            OutRow = OutRow + 1
        Next j
    Next InRow

Exit Sub

ErrorHandler:
    MsgBox "Error: " & Err.Description & ".  Please try again.", vbOKOnly

End Sub

