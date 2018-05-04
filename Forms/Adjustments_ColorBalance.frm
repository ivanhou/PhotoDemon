VERSION 5.00
Begin VB.Form FormColorBalance 
   BackColor       =   &H80000005&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   " Adjust Color Balance"
   ClientHeight    =   6540
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   12630
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   436
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   842
   ShowInTaskbar   =   0   'False
   Begin PhotoDemon.pdCommandBar cmdBar 
      Align           =   2  'Align Bottom
      Height          =   750
      Left            =   0
      TabIndex        =   0
      Top             =   5790
      Width           =   12630
      _ExtentX        =   22278
      _ExtentY        =   1323
   End
   Begin PhotoDemon.pdFxPreviewCtl pdFxPreview 
      Height          =   5625
      Left            =   120
      TabIndex        =   4
      Top             =   120
      Width           =   5625
      _ExtentX        =   9922
      _ExtentY        =   9922
   End
   Begin PhotoDemon.pdSlider sltRed 
      Height          =   405
      Left            =   6120
      TabIndex        =   1
      Top             =   1440
      Width           =   6255
      _ExtentX        =   10398
      _ExtentY        =   873
      Min             =   -100
      Max             =   100
      SliderTrackStyle=   3
      GradientColorLeft=   16776960
      GradientColorRight=   255
      GradientColorMiddle=   8881021
   End
   Begin PhotoDemon.pdSlider sltGreen 
      Height          =   405
      Left            =   6120
      TabIndex        =   2
      Top             =   2400
      Width           =   6255
      _ExtentX        =   10398
      _ExtentY        =   873
      Min             =   -100
      Max             =   100
      SliderTrackStyle=   3
      GradientColorLeft=   16711935
      GradientColorRight=   65280
   End
   Begin PhotoDemon.pdSlider sltBlue 
      Height          =   405
      Left            =   6120
      TabIndex        =   3
      Top             =   3360
      Width           =   6255
      _ExtentX        =   10398
      _ExtentY        =   873
      Min             =   -100
      Max             =   100
      SliderTrackStyle=   3
      GradientColorLeft=   65535
      GradientColorRight=   16711680
   End
   Begin PhotoDemon.pdCheckBox chkLuminance 
      Height          =   360
      Left            =   6360
      TabIndex        =   5
      Top             =   4440
      Width           =   6015
      _ExtentX        =   10610
      _ExtentY        =   582
      Caption         =   "preserve luminance"
   End
   Begin PhotoDemon.pdLabel lblTitle 
      Height          =   285
      Index           =   0
      Left            =   6000
      Top             =   1080
      Width           =   6345
      _ExtentX        =   11192
      _ExtentY        =   503
      Caption         =   "new balance"
      FontSize        =   12
      ForeColor       =   4210752
   End
   Begin PhotoDemon.pdLabel lblYellow 
      Height          =   270
      Left            =   6420
      Top             =   3840
      Width           =   2115
      _ExtentX        =   3731
      _ExtentY        =   476
      Caption         =   "yellow"
      ForeColor       =   4210752
   End
   Begin PhotoDemon.pdLabel lblMagenta 
      Height          =   270
      Left            =   6420
      Top             =   2880
      Width           =   2190
      _ExtentX        =   3863
      _ExtentY        =   476
      Caption         =   "magenta"
      ForeColor       =   4210752
   End
   Begin PhotoDemon.pdLabel lblCyan 
      Height          =   270
      Left            =   6420
      Top             =   1920
      Width           =   2145
      _ExtentX        =   3784
      _ExtentY        =   476
      Caption         =   "cyan"
      ForeColor       =   4210752
   End
   Begin PhotoDemon.pdLabel lblBlue 
      Height          =   270
      Left            =   9240
      Top             =   3840
      Width           =   2070
      _ExtentX        =   3651
      _ExtentY        =   476
      Alignment       =   1
      Caption         =   "blue"
      ForeColor       =   4210752
   End
   Begin PhotoDemon.pdLabel lblGreen 
      Height          =   270
      Left            =   9165
      Top             =   2880
      Width           =   2115
      _ExtentX        =   3731
      _ExtentY        =   476
      Alignment       =   1
      Caption         =   "green"
      ForeColor       =   4210752
   End
   Begin PhotoDemon.pdLabel lblRed 
      Height          =   270
      Left            =   9165
      Top             =   1920
      Width           =   2115
      _ExtentX        =   3731
      _ExtentY        =   476
      Alignment       =   1
      Caption         =   "red"
      ForeColor       =   4210752
   End
End
Attribute VB_Name = "FormColorBalance"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'***************************************************************************
'Color Balance Adjustment Form
'Copyright 2013-2018 by Tanner Helland
'Created: 31/January/13
'Last updated: 02/August/17
'Last update: revert changes from an outside contributor that may have carried licensing issues
'
'Color balance Fairly simple and standard color adjustment form.  Layout and feature set derived from comparable tools
' in GIMP and Photoshop.
'
'All source code in this file is licensed under a modified BSD license.  This means you may use the code in your own
' projects IF you provide attribution.  For more information, please visit http://photodemon.org/about/license/
'
'***************************************************************************

Option Explicit

Public Sub ApplyColorBalance(ByVal effectParams As String, Optional ByVal toPreview As Boolean = False, Optional ByRef dstPic As pdFxPreviewCtl)
    
    If (Not toPreview) Then Message "Adjusting color balance..."
    
    Dim cParams As pdParamXML
    Set cParams = New pdParamXML
    cParams.SetParamString effectParams
    
    Dim rVal As Long, gVal As Long, bVal As Long
    Dim preserveLuminance As Boolean
    
    With cParams
        rVal = .GetLong("red", 0)
        gVal = .GetLong("green", 0)
        bVal = .GetLong("blue", 0)
        preserveLuminance = .GetBool("preserveluminance", chkLuminance.Value)
    End With
    
    Dim rModifier As Long, gModifier As Long, bModifier As Long
    rModifier = 0
    gModifier = 0
    bModifier = 0
    
    'Now, build actual RGB modifiers based off the values provided
    gModifier = gModifier - rVal
    bModifier = bModifier - rVal
    rModifier = rModifier + rVal
    
    rModifier = rModifier - gVal
    bModifier = bModifier - gVal
    gModifier = gModifier + gVal
    
    rModifier = rModifier - bVal
    gModifier = gModifier - bVal
    bModifier = bModifier + bVal
    
    'Because these modifiers are constant throughout the image, we can build look-up tables for them
    Dim rLookup(0 To 255) As Byte, gLookup(0 To 255) As Byte, bLookup(0 To 255) As Byte
    
    'Create a local array and point it at the pixel data we want to operate on
    Dim imageData() As Byte
    Dim tmpSA As SafeArray2D, tmpSA1D As SafeArray1D
    EffectPrep.PrepImageData tmpSA, toPreview, dstPic
        
    'Local loop variables can be more efficiently cached by VB's compiler, so we transfer all relevant loop data here
    Dim x As Long, y As Long, initX As Long, initY As Long, finalX As Long, finalY As Long
    initX = curDIBValues.Left
    initY = curDIBValues.Top
    finalX = curDIBValues.Right
    finalY = curDIBValues.Bottom
            
    'These values will help us access locations in the array more quickly.
    ' (qvDepth is required because the image array may be 24 or 32 bits per pixel, and we want to handle both cases.)
    Dim qvDepth As Long
    qvDepth = curDIBValues.BytesPerPixel
    
    'To keep processing quick, only update the progress bar when absolutely necessary.  This function calculates that value
    ' based on the size of the area to be processed.
    Dim progBarCheck As Long
    If (Not toPreview) Then ProgressBars.SetProgBarMax finalY
    progBarCheck = ProgressBars.FindBestProgBarValue()
    
    'Color variables
    Dim r As Long, g As Long, b As Long
    Dim h As Double, s As Double, l As Double
    
    'Populate the lookup tables
    For x = 0 To 255
    
        r = x + rModifier
        g = x + gModifier
        b = x + bModifier
        
        If (r > 255) Then r = 255
        If (r < 0) Then r = 0
        If (g > 255) Then g = 255
        If (g < 0) Then g = 0
        If (b > 255) Then b = 255
        If (b < 0) Then b = 0
        
        rLookup(x) = r
        gLookup(x) = g
        bLookup(x) = b
    
    Next x
    
    Dim origLuminance As Double
    Const ONE_DIV_255 As Double = 1# / 255#
    
    'Loop through each pixel in the image, converting values as we go
    initX = initX * qvDepth
    finalX = finalX * qvDepth
    
    For y = initY To finalY
        workingDIB.WrapArrayAroundScanline imageData, tmpSA1D, y
    For x = initX To finalX Step qvDepth
        
        'Get the source pixel color values
        b = imageData(x)
        g = imageData(x + 1)
        r = imageData(x + 2)
        
        
        'If the user wants us to maintain luminance, we need to convert the newly modified values to HSL,
        ' then substitute this pixel's original luminance value when converting back to RGB.
        If preserveLuminance Then
            
            'Cache the original luminance
            origLuminance = Colors.GetLuminance(r, g, b) * ONE_DIV_255
            
            'Calculate new values
            r = rLookup(r)
            g = gLookup(g)
            b = bLookup(b)
        
            'Convert the new values to HSL
            Colors.ImpreciseRGBtoHSL r, g, b, h, s, l
            
            'Now, convert back, using the original luminance
            Colors.ImpreciseHSLtoRGB h, s, origLuminance, r, g, b
            
        Else
            r = rLookup(r)
            g = gLookup(g)
            b = bLookup(b)
        End If
        
        'Assign the new values to each color channel
        imageData(x) = b
        imageData(x + 1) = g
        imageData(x + 2) = r
        
    Next x
        If (Not toPreview) Then
            If (y And progBarCheck) = 0 Then
                If Interface.UserPressedESC() Then Exit For
                SetProgBarVal y
            End If
        End If
    Next y
    
    'Safely deallocate imageData()
    workingDIB.UnwrapArrayFromDIB imageData
    
    'Pass control to finalizeImageData, which will handle the rest of the rendering
    EffectPrep.FinalizeImageData toPreview, dstPic
    
End Sub

Private Sub chkLuminance_Click()
    UpdatePreview
End Sub

Private Sub cmdBar_OKClick()
    Process "Color balance", , GetLocalParamString(), UNDO_Layer
End Sub

Private Sub cmdBar_RequestPreviewUpdate()
    UpdatePreview
End Sub

Private Sub cmdBar_ResetClick()
    chkLuminance.Value = False
End Sub

Private Sub Form_Load()
    cmdBar.MarkPreviewStatus False
    ApplyThemeAndTranslations Me
    cmdBar.MarkPreviewStatus True
    UpdatePreview
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ReleaseFormTheming Me
End Sub

Private Sub sltBlue_Change()
    UpdatePreview
End Sub

Private Sub sltGreen_Change()
    UpdatePreview
End Sub

Private Sub sltRed_Change()
    UpdatePreview
End Sub

Private Sub UpdatePreview()
    If cmdBar.PreviewsAllowed Then ApplyColorBalance GetLocalParamString(), True, pdFxPreview
End Sub

'If the user changes the position and/or zoom of the preview viewport, the entire preview must be redrawn.
Private Sub pdFxPreview_ViewportChanged()
    UpdatePreview
End Sub

Private Function GetLocalParamString() As String
    
    Dim cParams As pdParamXML
    Set cParams = New pdParamXML
    
    With cParams
        .AddParam "red", sltRed.Value
        .AddParam "green", sltGreen.Value
        .AddParam "blue", sltBlue.Value
        .AddParam "preserveluminance", chkLuminance.Value
    End With
    
    GetLocalParamString = cParams.GetParamString()
    
End Function
