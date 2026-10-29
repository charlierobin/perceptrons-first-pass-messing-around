#tag Class
Protected Class DesktopContainerNode
Inherits DesktopContainer
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  g.DrawingColor = Color.White
		  
		  g.FillRoundRectangle( 0, 0, g.Width, g.Height, 5, 5 )
		  
		  if self.highlighted then
		    
		    g.DrawingColor = Color.Red
		    
		  else
		    
		    g.DrawingColor = Color.Black
		    
		  end if
		  
		  g.DrawRoundRectangle( 0, 0, g.Width, g.Height, 5, 5 )
		  
		  RaiseEvent Paint( g, areas )
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function acceptsInputs() As Boolean
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function addInput(node as DesktopContainerNode, weight as Double) As Boolean
		  if self.inputs.IndexOf( node ) = -1 then
		    
		    self.inputs.Add( node )
		    
		    self.weights.Add( weight )
		    
		    return true
		    
		  else
		    
		    return false
		    
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function asJSON() As JSONItem
		  var json as JSONItem = new JSONItem( "{}" )
		  
		  json.Value( "uuid" ) = self.uuid
		  
		  json.Value( "type" ) = ""
		  
		  json.Value( "left" ) = self.Left
		  json.Value( "top" ) = self.Top
		  
		  var inputsJSON as JSONItem = new JSONItem( "[]" )
		  
		  json.Value( "inputs" ) = inputsJSON
		  
		  for i as Integer = 0 to self.inputs.LastIndex
		    
		    var inputJSON as JSONItem = new JSONItem( "{}" )
		    
		    inputJSON.Value( "uuid" ) = self.inputs( i ).uuid
		    
		    inputJSON.Value( "weight" ) = self.weights( i )
		    
		    inputsJSON.Add( inputJSON )
		    
		  next
		  
		  return json
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function canOutput() As Boolean
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.Constructor()
		  
		  self.uuid = DesktopContainerNode.getNextUUID()
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(json as JSONItem)
		  self.Constructor()
		  
		  self.uuid = json.Value( "uuid" )
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createNewInspector()
		  raise new RuntimeException()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function fromJSON(json as JSONItem) As DesktopContainerNode
		  var type as String = json.Value( "type" )
		  
		  select case type
		    
		  case "Value"
		    
		    return new ContainerValue( json )
		    
		  case "Perceptron"
		    
		    return new ContainerPerceptron( json )
		    
		  case "Output"
		    
		    return new ContainerOutput( json )
		    
		  else
		    
		    raise new RuntimeException( "Unknown type: " + type )
		    
		  end select
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function getNextUUID() As Integer
		  DesktopContainerNode.nextUUID = DesktopContainerNode.nextUUID + 1
		  
		  return DesktopContainerNode.nextUUID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getOutputValue() As Double
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub openInspector()
		  for each w as DesktopWindow in App.Windows()
		    
		    if w isA DesktopWindowInspector then
		      
		      if DesktopWindowInspector( w ).cc = self then
		        
		        w.Show()
		        
		        return
		        
		      end if
		      
		    end if
		    
		  next
		  
		  self.createNewInspector()
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub recalc()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removeLink(node as DesktopContainerNode)
		  var index as Integer = self.inputs.IndexOf( node )
		  
		  if index > -1 then
		    
		    self.inputs.RemoveAt( index )
		    
		    self.weights.RemoveAt( index )
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub sendRecalcToWindow()
		  if self.Parent <> nil then
		    
		    var w as WindowMain = WindowMain( self.Window )
		    
		    w.recalc()
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub toggleHighlighted()
		  self.highlighted = not self.highlighted
		  
		  self.Refresh()
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function usesWeights() As Boolean
		  return false
		  
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Paint(g As Graphics, areas() As Rect)
	#tag EndHook


	#tag Property, Flags = &h21
		Private highlighted As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		inputs() As DesktopContainerNode
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared nextUUID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		uuid As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		weights() As Double
	#tag EndProperty


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
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Size"
			InitialValue="300"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Size"
			InitialValue="300"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Visible=false
			Group="Position"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundColor"
			Visible=true
			Group="Background"
			InitialValue="&hFFFFFF"
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
			Name="HasBackgroundColor"
			Visible=true
			Group="Background"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Composited"
			Visible=true
			Group="Window Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="uuid"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
