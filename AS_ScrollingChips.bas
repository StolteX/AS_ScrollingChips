B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
#If Documentation
Updates
1.00
	-Release
1.01
	-BugFix - labels with different heights
2.00
	-Complete new development
	-Now works like AS_Chips
#End If

#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFF000000
#DesignerProperty: Key: ShowRemoveIcon, DisplayName: Show Remove Icon, FieldType: Boolean, DefaultValue: False, Description: Displays a Remove icon which can be clicked on
#DesignerProperty: Key: Round, DisplayName: Round, FieldType: Boolean, DefaultValue: True, Description: Makes the chips round
#DesignerProperty: Key: CornerRadius, DisplayName: Corner Radius, FieldType: Int, DefaultValue: 5, MinRange: 0, Description: Only affected if Round = False

#Event: ChipClick (Chip As ASScrollingChips_Chip)
#Event: ChipLongClick (Chip As ASScrollingChips_Chip)
#Event: ChipRemoved (Chip As ASScrollingChips_Chip)
#Event: CustomDrawChip(Item As ASScrollingChips_CustomDraw)

Sub Class_Globals
	
	Type ASScrollingChips_Chip(Text As String,Icon As B4XBitmap,Tag As Object,Index As Int)
	Type ASScrollingChips_ChipProperties(Height As Float,BackgroundColor As Int,TextColor As Int,xFont As B4XFont,CornerRadius As Float,BorderSize As Float,TextGap As Float)
	Type ASScrollingChips_RemoveIconProperties(BackgroundColor As Int,TextColor As Int)
	Type ASScrollingChips_Views(BackgroundPanel As B4XView,TextLabel As B4XView,IconImageView As B4XView,RemoveIconLabel As B4XView)
	Type ASScrollingChips_CustomDraw(Chip As ASScrollingChips_Chip,ChipProperties As ASScrollingChips_ChipProperties,Views As ASScrollingChips_Views)
	
	Private g_ChipProperties As ASScrollingChips_ChipProperties
	Private g_RemoveIconProperties As ASScrollingChips_RemoveIconProperties
	
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI 'ignore
	Private xclv As CustomListView
	Public Tag As Object
	
	Private m_GapBetween As Float
	Private m_BackgroundColor As Int
	Private m_ShowRemoveIcon As Boolean
	Private m_Round As Boolean

End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
    Tag = mBase.Tag
    mBase.Tag = Me 
	ini_props(Props)
	ini_xclv
	
	#If B4A 
	Base_Resize(mBase.Width,mBase.Height)
	#End If
End Sub

Private Sub ini_props(Props As Map)
	m_BackgroundColor = xui.PaintOrColorToColor(Props.Get("BackgroundColor"))
	m_ShowRemoveIcon = Props.Get("ShowRemoveIcon")
	m_Round = Props.Get("Round")
	
	m_GapBetween = 5dip
	
	g_ChipProperties = CreateASScrollingChips_ChipProperties(22dip,xui.Color_Black,xui.Color_White,xui.CreateDefaultFont(14),DipToCurrent(Props.Get("CornerRadius")),0,3dip)
	g_RemoveIconProperties = CreateASScrollingChips_RemoveIconProperties(xui.Color_Black,xui.Color_White)
	
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
  
  	xclv.Base_Resize(Width,Height)
  
End Sub

Private Sub ini_xclv
	
	Dim tmplbl As Label
	tmplbl.Initialize("")
 
	Dim tmpmap As Map
	tmpmap.Initialize
	tmpmap.Put("DividerColor",m_BackgroundColor)'0xFFD9D7DE)
	tmpmap.Put("DividerHeight",m_GapBetween)
	tmpmap.Put("PressedColor",0x007EB4FA)'0xFF7EB4FA
	tmpmap.Put("InsertAnimationDuration",300)	
	tmpmap.Put("ListOrientation","Horizontal")		
	tmpmap.Put("ShowScrollBar",xui.IsB4J)
	
	xclv.Initialize(Me,"xclv")
	xclv.DesignerCreateView(mBase,tmplbl,tmpmap)
	
'	#If B4J
'	
'	#Else
'	Dim sv As ScrollView = xclv.sv
'	sv.Color = mBase.Color
'	#End If
	
	
	
End Sub

'Public Sub AddAdd(background_color As Int)
'	
'	Dim tmp_height As Float =  MeasureTextHeight("A",g_LabelProperties.xFont) + 10dip
'	
'	Dim xpnl_base As B4XView = xui.CreatePanel("")
'	Dim xpnl_background As B4XView = xui.CreatePanel("")
'	xpnl_base.SetLayoutAnimated(0,0,0,tmp_height + g_TextPaddingTopBottom,xclv.GetBase.Height)
'	xpnl_background.SetColorAndBorder(background_color,0,0,tmp_height/2)
'	
'	Dim xlbl_text As B4XView = CreateLabel("")
'	xlbl_text.TextColor = g_LabelProperties.TextColor
'	xlbl_text.Font = xui.CreateMaterialIcons(15)
'	xlbl_text.SetTextAlignment("CENTER","CENTER")
'	xlbl_text.Text = Chr(0xE145)
'	
'	xpnl_base.AddView(xpnl_background,xpnl_base.Width/2 - tmp_height/2,xclv.GetBase.Height/2 - tmp_height/2,tmp_height,tmp_height)
'	xpnl_base.AddView(xlbl_text,xpnl_background.Left,xpnl_background.Top,xpnl_background.Width,xpnl_background.Height)
'	
'	xclv.Add(xpnl_base,"add")
'	
'End Sub

Public Sub AddChip(Text As String,Icon As B4XBitmap,xTag As Object)
	AddChip2List(Text,Icon,g_ChipProperties.BackgroundColor,xTag)
End Sub

Public Sub AddChip2(Text As String,Icon As B4XBitmap,ChipColor As Int,xTag As Object)
	AddChip2List(Text,Icon,ChipColor,xTag)
End Sub

Private Sub AddChip2List(Text As String,Icon As B4XBitmap,ChipColor As Int,xTag As Object)
	Dim ChipProps As ASScrollingChips_ChipProperties = CreateASScrollingChips_ChipProperties(g_ChipProperties.Height,ChipColor,g_ChipProperties.TextColor,g_ChipProperties.xFont,g_ChipProperties.CornerRadius,g_ChipProperties.BorderSize,g_ChipProperties.TextGap)
	
	Dim Chip As ASScrollingChips_Chip
	Chip.Text = Text
	Chip.Icon = Icon
	Chip.Tag = xTag
	Chip.Index = xclv.Size
	
	Dim FontGap As Float = IIf(xui.IsB4J,6dip,0dip)
	
	Dim HaveIcon As Boolean = IIf(Chip.Icon <> Null And Chip.Icon.IsInitialized = True,True,False)
	
	Dim Width As Float = MeasureTextWidth(Chip.Text,ChipProps.xFont) + FontGap + ChipProps.TextGap*3
	
	If m_ShowRemoveIcon = True Then Width = Width + IIf(xui.IsB4J,ChipProps.Height/1.5,ChipProps.Height)
	If HaveIcon = True Then Width = Width + ChipProps.Height/1.3
	
	Dim xpnl_Background As B4XView = xui.CreatePanel("xpnl_ChipBackground")
	xpnl_Background.Color = m_BackgroundColor
	xpnl_Background.SetLayoutAnimated(0,0,0,Width,mBase.Height)
	
	xclv.Add(xpnl_Background,CreateMap("Chip":Chip,"ChipProperties":ChipProps))

End Sub

Private Sub AddChipIntern(xpnl_Background As B4XView,ChipMap As Map)
	
	Dim Chip As ASScrollingChips_Chip = ChipMap.Get("Chip")
	Dim ChipProperties As ASScrollingChips_ChipProperties = ChipMap.Get("ChipProperties")
	
	Dim FontGap As Float = IIf(xui.IsB4J,6dip,0dip)
	Dim Width As Float = MeasureTextWidth(Chip.Text,ChipProperties.xFont) + FontGap + ChipProperties.TextGap*3
	Dim HaveIcon As Boolean = IIf(Chip.Icon <> Null And Chip.Icon.IsInitialized = True,True,False)
	If m_ShowRemoveIcon = True Then Width = Width + IIf(xui.IsB4J,ChipProperties.Height/1.5,ChipProperties.Height)
	If HaveIcon = True Then Width = Width + ChipProperties.Height/1.3
	
	Dim xpnl_ChipBackground As B4XView = xui.CreatePanel("xpnl_ChipBackground")
	xpnl_Background.AddView(xpnl_ChipBackground,xpnl_Background.Width/2 - Width/2,xpnl_Background.Height/2-ChipProperties.Height/2,Width,ChipProperties.Height)
	xpnl_ChipBackground.SetColorAndBorder(ChipProperties.BackgroundColor,ChipProperties.BorderSize,0,IIf(m_Round = True,xpnl_ChipBackground.Height/2, ChipProperties.CornerRadius))
	
	Dim xlbl_Text As B4XView = CreateLabel("")
	xpnl_ChipBackground.AddView(xlbl_Text,0,0,0,0)
	xlbl_Text.TextColor = ChipProperties.TextColor
	xlbl_Text.SetTextAlignment("CENTER","CENTER")
	xlbl_Text.Font = ChipProperties.xFont
	xlbl_Text.SetLayoutAnimated(0,ChipProperties.TextGap + IIf(HaveIcon = True,ChipProperties.Height/1.3,0),0,MeasureTextWidth(Chip.Text,ChipProperties.xFont) + FontGap + ChipProperties.TextGap,ChipProperties.Height)
	xlbl_Text.Text = Chip.Text
	
	Dim xiv_Icon As B4XView = CreateImageView("")
	xpnl_ChipBackground.AddView(xiv_Icon,0,0,0,0)
	
	Dim xlbl_RemoveIcon As B4XView = CreateLabel("xlbl_RemoveIcon")
	xpnl_ChipBackground.AddView(xlbl_RemoveIcon,0,0,0,0)
	
	'************Icon********************************
	If HaveIcon Then
			
		Dim HeightWidth As Float = ChipProperties.Height/1.3
		xiv_Icon.SetLayoutAnimated(0,ChipProperties.Height/2 - HeightWidth/2,xpnl_ChipBackground.Height/2 - HeightWidth/2,HeightWidth,HeightWidth)
		xiv_Icon.SetBitmap(Chip.Icon.Resize(xiv_Icon.Width,xiv_Icon.Height,True))
			
	End If
	xiv_Icon.Visible = HaveIcon
	'************RemoveIcon********************************
	If m_ShowRemoveIcon = True Then
			
		Dim HeightWidth As Float = ChipProperties.Height/1.5
			
		xlbl_RemoveIcon.Font = xui.CreateMaterialIcons(9)
		xlbl_RemoveIcon.Text = Chr(0xE5CD)
		xlbl_RemoveIcon.SetTextAlignment("CENTER","CENTER")
		xlbl_RemoveIcon.SetColorAndBorder(g_RemoveIconProperties.BackgroundColor,0,0,HeightWidth/2)
		xlbl_RemoveIcon.TextColor = g_RemoveIconProperties.TextColor
			
			
		xlbl_RemoveIcon.SetLayoutAnimated(0,xpnl_ChipBackground.Width - ChipProperties.Height/2 - HeightWidth/2,xpnl_ChipBackground.Height/2 - HeightWidth/2,HeightWidth,HeightWidth)
		xlbl_RemoveIcon.Visible = True
	Else
		xlbl_RemoveIcon.Visible = False
	End If
	
	CustomDrawChip(CreateASScrollingChips_CustomDraw(Chip,ChipProperties,CreateASScrollingChips_Views(xpnl_Background,xlbl_Text,xiv_Icon,xlbl_RemoveIcon)))
	
End Sub

Public Sub RefreshChips
	For i = 0 To xclv.Size -1
		xclv.GetPanel(i).RemoveAllViews
	Next
	xclv.Refresh
End Sub

Private Sub xclv_VisibleRangeChanged (FirstIndex As Int, LastIndex As Int)
	Dim ExtraSize As Int = 20
	For i = 0 To xclv.Size - 1
		Dim p As B4XView = xclv.GetPanel(i)
		If i > FirstIndex - ExtraSize And i < LastIndex + ExtraSize Then
			'visible+
			If p.NumberOfViews = 0 Then
			AddChipIntern(p,xclv.GetValue(i))
			End If
		Else
			'not visible
			If p.NumberOfViews > 0 Then
				p.RemoveAllViews
			End If
		End If
	Next
End Sub


#Region Properties

'Call RefreshChips if you change something
Public Sub getRemoveIconProperties As ASScrollingChips_RemoveIconProperties
	Return g_RemoveIconProperties
End Sub
'Can only influence the appearance before the respective chip has been added
Public Sub getChipPropertiesGlobal As ASScrollingChips_ChipProperties
	Return g_ChipProperties
End Sub

Public Sub getCLV As CustomListView
	Return xclv
End Sub

Public Sub GetBackgroundAt(index As Int) As B4XView
	Return xclv.GetPanel(index).GetView(0)
End Sub

Public Sub GetLabelAt(index As Int) As B4XView
	Return xclv.GetPanel(index).GetView(0).GetView(0)
End Sub

Public Sub getGapBetween As Float
	Return m_GapBetween
End Sub

Public Sub setGapBetween(Gap As Float)
	m_GapBetween = Gap
End Sub

Public Sub Clear
	xclv.Clear
End Sub

Public Sub getSize As Int
	Return xclv.Size
End Sub

Public Sub RemoveChip(Index As Int)
	ChipRemoved(xclv.GetValue(Index).As(Map).Get("Chip"))
	xclv.RemoveAt(Index)
End Sub
'Call RefreshChips if you change something
Public Sub SetChipProperties(Index As Int,Properties As ASScrollingChips_ChipProperties)
	Dim mProps As Map = xclv.GetValue(Index)
	mProps.Put("ChipProperties",Properties)
	mProps.Put("Chip",mProps.Get("Chip"))
	'list_Chips.Set(Index,mProps)
End Sub

Public Sub GetChipProperties(Index As Int) As ASScrollingChips_ChipProperties
	Return xclv.GetValue(Index).As(Map).Get("ChipProperties")
End Sub

Public Sub GetChip(Index As Int) As ASScrollingChips_Chip
	Return xclv.GetValue(Index).As(Map).Get("Chip")
End Sub

Public Sub getShowRemoveIcon As Boolean
	Return m_ShowRemoveIcon
End Sub

Public Sub setShowRemoveIcon(Show As Boolean)
	m_ShowRemoveIcon = Show
End Sub

'Call RefreshChips if you change something
Public Sub getBackgroundColor As Int
	Return m_BackgroundColor
End Sub

Public Sub setBackgroundColor(Color As Int)
	m_BackgroundColor = Color
End Sub
'Call RefreshChips if you change something
Public Sub setRound(isRound As Boolean)
	m_Round = isRound
End Sub

Public Sub getRound As Boolean
	Return m_Round
End Sub

#End Region

#Region Events

Private Sub CustomDrawChip(Item As ASScrollingChips_CustomDraw)
	If xui.SubExists(mCallBack, mEventName & "_CustomDrawChip",1) Then
		CallSub2(mCallBack, mEventName & "_CustomDrawChip",Item)
	End If
End Sub


Private Sub ChipRemoved(Chip As ASScrollingChips_Chip)
	If xui.SubExists(mCallBack, mEventName & "_ChipRemoved",1) Then
		CallSub2(mCallBack, mEventName & "_ChipRemoved",Chip)
	End If
End Sub

Private Sub ChipClicked(Chip As ASScrollingChips_Chip)
	If xui.SubExists(mCallBack, mEventName & "_ChipClick",1) Then
		CallSub2(mCallBack, mEventName & "_ChipClick",Chip)
	End If
End Sub

Private Sub ChipLongClick(Chip As ASScrollingChips_Chip)
	If xui.SubExists(mCallBack, mEventName & "_ChipLongClick",1) Then
		CallSub2(mCallBack, mEventName & "_ChipLongClick",Chip)
	End If
End Sub

#If B4J
Private Sub xpnl_ChipBackground_MouseClicked (EventData As MouseEvent)
	EventData.Consume
	If EventData.PrimaryButtonPressed Then
		ClickedChip(Sender)
	else If EventData.SecondaryButtonPressed Then
		LongClickedChip(Sender)
	End If
End Sub
#Else
Private Sub xpnl_ChipBackground_Click
	ClickedChip(Sender)
End Sub
Private Sub xpnl_ChipBackground_LongClick
	LongClickedChip(Sender)
End Sub
#End If

#If B4J
Private Sub xlbl_RemoveIcon_MouseClicked (EventData As MouseEvent)
	EventData.Consume
	RemoveChip2(Sender)
End Sub
#Else
Private Sub xlbl_RemoveIcon_Click
	RemoveChip2(Sender)
End Sub
#End If

Private Sub ClickedChip(xpnl_Background As B4XView)
	ChipClicked(xclv.GetValue(xclv.GetItemFromView(xpnl_Background)).As(Map).Get("Chip"))
End Sub

Private Sub LongClickedChip(xpnl_Background As B4XView)
	ChipLongClick(xclv.GetValue(xclv.GetItemFromView(xpnl_Background)).As(Map).Get("Chip"))
End Sub

Private Sub RemoveChip2(xlbl_RemoveIcon As B4XView)
	ChipRemoved(xclv.GetValue(xclv.GetItemFromView(xlbl_RemoveIcon)).As(Map).Get("Chip"))
	xclv.RemoveAt(xclv.GetItemFromView(xlbl_RemoveIcon))
End Sub

#End Region

#Region Functions

Private Sub CreateLabel(EventName As String) As B4XView
	Dim tmp_lbl As Label
	tmp_lbl.Initialize(EventName)
	Return tmp_lbl
End Sub

Private Sub CreateImageView(EventName As String) As B4XView
	Dim iv As ImageView
	iv.Initialize(EventName)
	Return iv
End Sub

'https://www.b4x.com/android/forum/threads/fontawesome-to-bitmap.95155/post-603250
Public Sub FontToBitmap (text As String, IsMaterialIcons As Boolean, FontSize As Float, color As Int) As B4XBitmap
	Dim xui As XUI
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, 32dip, 32dip)
	Dim cvs1 As B4XCanvas
	cvs1.Initialize(p)
	Dim fnt As B4XFont
	If IsMaterialIcons Then fnt = xui.CreateMaterialIcons(FontSize) Else fnt = xui.CreateFontAwesome(FontSize)
	Dim r As B4XRect = cvs1.MeasureText(text, fnt)
	Dim BaseLine As Int = cvs1.TargetRect.CenterY - r.Height / 2 - r.Top
	cvs1.DrawText(text, cvs1.TargetRect.CenterX, BaseLine, fnt, color, "CENTER")
	Dim b As B4XBitmap = cvs1.CreateBitmap
	cvs1.Release
	Return b
End Sub

Private Sub MeasureTextWidth(Text As String, Font1 As B4XFont) As Int
#If B4A
	Private bmp As Bitmap
	bmp.InitializeMutable(2dip, 2dip)
	Private cvs As Canvas
	cvs.Initialize2(bmp)
	Return cvs.MeasureStringWidth(Text, Font1.ToNativeFont, Font1.Size)
#Else If B4i
    Return Text.MeasureWidth(Font1.ToNativeFont)
#Else If B4J
    Dim jo As JavaObject
    jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
    jo.RunMethod("setFont",Array(Font1.ToNativeFont))
    jo.RunMethod("setLineSpacing",Array(0.0))
    jo.RunMethod("setWrappingWidth",Array(0.0))
    Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
    Return Bounds.RunMethod("getWidth",Null)
#End If
End Sub

#End Region

#Region Types

Public Sub CreateASScrollingChips_ChipProperties (Height As Float, BackgroundColor As Int, TextColor As Int, xFont As B4XFont, CornerRadius As Float, BorderSize As Float, TextGap As Float) As ASScrollingChips_ChipProperties
	Dim t1 As ASScrollingChips_ChipProperties
	t1.Initialize
	t1.Height = Height
	t1.BackgroundColor = BackgroundColor
	t1.TextColor = TextColor
	t1.xFont = xFont
	t1.CornerRadius = CornerRadius
	t1.BorderSize = BorderSize
	t1.TextGap = TextGap
	Return t1
End Sub

Public Sub CreateASScrollingChips_RemoveIconProperties (BackgroundColor As Int, TextColor As Int) As ASScrollingChips_RemoveIconProperties
	Dim t1 As ASScrollingChips_RemoveIconProperties
	t1.Initialize
	t1.BackgroundColor = BackgroundColor
	t1.TextColor = TextColor
	Return t1
End Sub

Public Sub CreateASScrollingChips_CustomDraw (Chip As ASScrollingChips_Chip, ChipProperties As ASScrollingChips_ChipProperties, Views As ASScrollingChips_Views) As ASScrollingChips_CustomDraw
	Dim t1 As ASScrollingChips_CustomDraw
	t1.Initialize
	t1.Chip = Chip
	t1.ChipProperties = ChipProperties
	t1.Views = Views
	Return t1
End Sub

Public Sub CreateASScrollingChips_Views (BackgroundPanel As B4XView, TextLabel As B4XView, IconImageView As B4XView, RemoveIconLabel As B4XView) As ASScrollingChips_Views
	Dim t1 As ASScrollingChips_Views
	t1.Initialize
	t1.BackgroundPanel = BackgroundPanel
	t1.TextLabel = TextLabel
	t1.IconImageView = IconImageView
	t1.RemoveIconLabel = RemoveIconLabel
	Return t1
End Sub

#End Region