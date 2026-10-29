#tag DesktopWindow
Begin DesktopWindow WindowMain
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   True
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   400
   ImplicitInstance=   False
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   908382207
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "(unsaved)"
   Type            =   0
   Visible         =   True
   Width           =   600
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Closing()
		  var toClose() as DesktopWindow
		  
		  for each cc as DesktopContainerNode in self.ccArray
		    
		    for each w as DesktopWindow in App.Windows()
		      
		      if w isA DesktopWindowInspector then
		        
		        var iw as DesktopWindowInspector = DesktopWindowInspector( w )
		        
		        if iw.cc = cc then
		          
		          toClose.Add( iw )
		          
		        end if
		        
		      end if
		      
		    next
		    
		  next
		  
		  for each w as DesktopWindow in toClose
		    
		    w.Close()
		    
		  next
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function ConstructContextualMenu(base As DesktopMenuItem, x As Integer, y As Integer) As Boolean
		  var p as Point = new Point( x, y )
		  
		  for each cc as DesktopContainerNode in self.ccArray
		    
		    if cc.Bounds.Contains( p ) then
		      
		      return true
		      
		    end if
		    
		  next
		  
		  for each r as Rect in self.rectArray
		    
		    if r.Contains( p ) then
		      
		      var data as Dictionary = self.weightRectData.Value( r )
		      
		      var cc as DesktopContainerNode = data.Value( "target" )
		      
		      if cc.usesWeights() then
		        
		        base.AddMenu( new DesktopMenuItem( "Edit Weight", r ) )
		        
		      end if
		      
		      base.AddMenu( new DesktopMenuItem( "Delete Link…", r ) )
		      
		      return true
		      
		    end if
		    
		  next
		  
		  base.AddMenu( new DesktopMenuItem( "New Value", p ) )
		  base.AddMenu( new DesktopMenuItem( "New Perceptron", p ) )
		  base.AddMenu( new DesktopMenuItem( "New Output", p ) )
		  
		  return true
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ContextualMenuItemSelected(selectedItem As DesktopMenuItem) As Boolean
		  var cc as DesktopContainerNode = nil
		  
		  var s as String = selectedItem.Text
		  
		  if s = "Edit Weight" then
		    
		    var r as Rect = selectedItem.Tag
		    
		    var data as Dictionary = self.weightRectData.Value( r )
		    
		    WindowWeightInspector.openFor( data.Value( "source" ), data.Value( "target" ) )
		    
		  elseif s = "Delete Link…" then
		    
		    if ConfirmDialog.show( "Are you sure?" ) then
		      
		      var r as Rect = selectedItem.Tag
		      
		      var data as Dictionary = self.weightRectData.Value( r )
		      
		      var targetCC as DesktopContainerNode = data.Value( "target" )
		      var sourceCC as DesktopContainerNode = data.Value( "source" )
		      
		      WindowWeightInspector.closeFor( sourceCC, targetCC )
		      
		      targetCC.removeLink( sourceCC )
		      
		    end if
		    
		  else
		    
		    var p as Point = selectedItem.Tag
		    
		    select case s
		      
		    case "New Value"
		      
		      cc = new ContainerValue( WindowDefaults.TextFieldDefaultValue.Text.ToDouble() )
		      
		    case "New Perceptron"
		      
		      cc = new ContainerPerceptron( WindowDefaults.TextFieldDefaultThreshold.Text.ToDouble() )
		      
		    case "New Output"
		      
		      cc = new ContainerOutput()
		      
		    else
		      
		      raise new RuntimeException( "Error: " + s )
		      
		    end select
		    
		    cc.EmbedWithin( self, p.X, p.Y )
		    
		    self.ccArray.Add( cc )
		    
		  end if
		  
		  self.recalc()
		  
		  return true
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #pragma unused areas
		  
		  self.rectArray.RemoveAll()
		  
		  self.weightRectData.RemoveAll()
		  
		  for each cc as DesktopContainerNode in self.ccArray
		    
		    for i as Integer = 0 to cc.inputs.LastIndex
		      
		      var inputNode as DesktopContainerNode = cc.inputs( i )
		      
		      g.DrawingColor = Color.LightGray
		      
		      g.DrawLine( cc.Bounds.Center.X, cc.Bounds.Center.Y, inputNode.Bounds.Center.X, inputNode.Bounds.Center.Y )
		      
		      var r as Rect = new Rect( inputNode.Bounds.Center.X, inputNode.Bounds.Center.Y, cc.Bounds.Center.X - inputNode.Bounds.Center.X, cc.Bounds.Center.Y - inputNode.Bounds.Center.Y )
		      
		      g.DrawingColor = Color.Gray
		      
		      var r2 as Rect = new Rect( r.Center.X - 10, r.Center.Y - 10, 20, 20 )
		      
		      g.FillOval( r2.Left, r2.Top, r2.Width, r2.Height )
		      
		      if cc.usesWeights() then
		        
		        g.DrawingColor = Color.White
		        
		        g.FontSize = 9
		        
		        g.DrawText( cc.weights( i ).ToString(), r2.Left + 2, r2.Top + 12 )
		        
		      end if
		      
		      self.rectArray.Add( r2 )
		      
		      self.weightRectData.Value( r2 ) = new Dictionary( "source" : inputNode, "target" : cc )
		      
		    next
		    
		  next
		  
		  if self.drawing then
		    
		    g.DrawingColor = Color.DarkGray
		    
		    g.DrawLine( self.startX, self.startY, self.MouseX, self.MouseY )
		    
		  end if
		  
		  
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function Close() As Boolean Handles Close.Action
		  self.Close()
		  
		  return true
		  
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Save() As Boolean Handles Save.Action
		  var f as FolderItem = SpecialFolder.Desktop.Child( "perceptrons.json" )
		  
		  if self.Title <> "(unsaved)" then
		    
		    f = new FolderItem( self.Title, FolderItem.PathModes.Native )
		    
		  else
		    
		    f = FolderItem.ShowSaveFileDialog( "", "perceptrons.json" )
		    
		  end if
		  
		  if f <> nil then
		    
		    var jsonNodesArray as JSONItem = new JSONItem( "[]" )
		    
		    for each node as DesktopContainerNode in self.ccArray
		      
		      var nodeJSON as JSONItem = node.asJSON()
		      
		      jsonNodesArray.Add( nodeJSON )
		      
		    next
		    
		    var json as JSONItem = new JSONItem( "{}" )
		    
		    json.Value( "nodes" ) = jsonNodesArray
		    
		    json.Value( "left" ) = self.Left
		    json.Value( "top" ) = self.Top
		    
		    json.Value( "width" ) = self.Width
		    json.Value( "height" ) = self.Height
		    
		    
		    
		    
		    var t as TextOutputStream = TextOutputStream.Create( f )
		    
		    json.Compact = false
		    
		    t.Write( json.ToString ) 
		    
		    t.Close()
		    
		    self.Title = f.NativePath
		    
		  end if
		  
		  return true
		  
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub CCMouseDown(sender as DesktopContainerNode)
		  // if sender.canOutput() then
		  
		  self.drawing = true
		  
		  self.startX = self.MouseX
		  self.startY = self.MouseY
		  
		  self.sourceNode = sender
		  
		  self.lastHighlightedNode = nil
		  
		  // end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CCMouseDrag()
		  var p as Point = new Point( self.MouseX, self.MouseY )
		  
		  var highlighted as DesktopContainerNode = nil
		  
		  for each cc as DesktopContainerNode in self.ccArray
		    
		    if cc = self.sourceNode then continue
		    
		    if cc.acceptsInputs() then
		      
		      if cc.Bounds.Contains( p ) then
		        
		        highlighted = cc
		        
		        exit
		        
		      end if
		      
		    end if
		    
		  next
		  
		  if self.lastHighlightedNode <> nil then
		    
		    self.lastHighlightedNode.toggleHighlighted()
		    
		  end if
		  
		  if highlighted <> nil then
		    
		    highlighted.toggleHighlighted()
		    
		  end if
		  
		  self.lastHighlightedNode = highlighted
		  
		  self.Refresh()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CCMouseUp()
		  var targetNode as DesktopContainerNode = self.lastHighlightedNode
		  
		  if self.lastHighlightedNode <> nil then
		    
		    self.lastHighlightedNode.toggleHighlighted()
		    
		    self.lastHighlightedNode = nil
		    
		  end if
		  
		  self.drawing = false
		  
		  if targetNode <> nil then
		    
		    if targetNode.addInput( self.sourceNode, WindowDefaults.TextFieldDefaultWeight.Text.ToDouble() ) then
		      
		      self.recalc()
		      
		    end if
		    
		  end if
		  
		  self.sourceNode = nil
		  
		  self.Refresh()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  self.weightRectData = new Dictionary()
		  
		  super.Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub deleteNodeWithUserConfirmation(node as DesktopContainerNode)
		  if ConfirmDialog.show( "Are you sure?" ) then
		    
		    self.ccArray.RemoveAt( self.ccArray.IndexOf( node ) )
		    
		    for each cc as DesktopContainerNode in self.ccArray
		      
		      cc.removeLink( node )
		      
		    next
		    
		    DesktopWindowInspector.closeAllRelatedTo( node )
		    
		    node.Close()
		    
		    self.recalc()
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getEndNodes() As DesktopContainerNode()
		  var nodes() as DesktopContainerNode
		  
		  // find all nodes which are not "featured" in other nodes inputs
		  // eventually changes links to 2 way, ie: output to input
		  
		  for each node as DesktopContainerNode in self.ccArray
		    
		    nodes.Add( node )
		    
		  next
		  
		  for each node as DesktopContainerNode in self.ccArray
		    
		    for each input as DesktopContainerNode in node.inputs
		      
		      if nodes.IndexOf( input ) > -1 then
		        
		        nodes.RemoveAt( nodes.IndexOf( input ) )
		        
		      end if
		      
		    next
		    
		  next
		  
		  return nodes
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getNodeByUUID(uuid as Integer) As DesktopContainerNode
		  for each node as DesktopContainerNode in self.ccArray
		    
		    if node.uuid = uuid then
		      
		      return node
		      
		    end if
		    
		  next
		  
		  return nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function openNew() As WindowMain
		  var w as WindowMain = new WindowMain()
		  
		  return w
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function openNew(json as JSONItem) As WindowMain
		  var w as WindowMain = WindowMain.openNew()
		  
		  w.Left = json.Value( "left" )
		  w.Top = json.Value( "top" )
		  
		  w.Width = json.Value( "width" )
		  w.Height = json.Value( "height" )
		  
		  var jsonNodesArray as JSONItem = json.Value( "nodes" )
		  
		  for i as Integer = 0 to jsonNodesArray.LastRowIndex()
		    
		    var nodeJSON as JSONItem = jsonNodesArray.ChildAt( i )
		    
		    var left as Integer = nodeJSON.Value( "left" )
		    var top as Integer = nodeJSON.Value( "top" )
		    
		    var cc as DesktopContainerNode = DesktopContainerNode.fromJSON( nodeJSON )
		    
		    cc.EmbedWithin( w, left, top )
		    
		    w.ccArray.Add( cc )
		    
		  next
		  
		  for i as Integer = 0 to jsonNodesArray.LastRowIndex()
		    
		    var nodeJSON as JSONItem = jsonNodesArray.ChildAt( i )
		    
		    var targetUUID as Integer = nodeJSON.Value( "uuid" )
		    var targetNode as DesktopContainerNode = w.getNodeByUUID( targetUUID )
		    
		    var inputsJSONArray as JSONItem = nodeJSON.Value( "inputs" )
		    
		    for j as Integer = 0 to inputsJSONArray.LastRowIndex()
		      
		      var inputJSON as JSONItem = inputsJSONArray.ChildAt( j )
		      
		      var sourceUUID as Integer = inputJSON.Value( "uuid" )
		      var sourceNode as DesktopContainerNode = w.getNodeByUUID( sourceUUID )
		      
		      var weight as Double = inputJSON.Value( "weight" )
		      
		      var result as Boolean = targetNode.addInput( sourceNode, weight )
		      
		      if not result then raise new RuntimeException()
		      
		    next
		    
		  next
		  
		  w.recalc()
		  
		  return w
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub recalc()
		  Timer.CancelCallLater( AddressOf self.recalc1 )
		  
		  Timer.CallLater( 100, AddressOf self.recalc1 )
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub recalc1()
		  System.DebugLog( "recalc" )
		  
		  var endNodes() as DesktopContainerNode = self.getEndNodes()
		  
		  for each node as DesktopContainerNode in endNodes
		    
		    // System.DebugLog( node.uuid.ToString() )
		    
		    node.recalc()
		    
		  next
		  
		  // perhaps best to split recalc and refresh ...
		  
		  self.Refresh()
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private ccArray() As DesktopContainerNode
	#tag EndProperty

	#tag Property, Flags = &h21
		Private drawing As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private lastHighlightedNode As DesktopContainerNode
	#tag EndProperty

	#tag Property, Flags = &h21
		Private rectArray() As Rect
	#tag EndProperty

	#tag Property, Flags = &h21
		Private sourceNode As DesktopContainerNode
	#tag EndProperty

	#tag Property, Flags = &h21
		Private startX As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private startY As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private weightRectData As Dictionary
	#tag EndProperty


#tag EndWindowCode

#tag ViewBehavior
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
