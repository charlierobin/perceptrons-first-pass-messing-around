#tag Module
Protected Module ConfirmDialog
	#tag Method, Flags = &h1
		Protected Function show(message as String) As Boolean
		  // TODO
		  
		  Var d As New MessageDialog                  // declare the MessageDialog object
		  Var b As MessageDialogButton                // for handling the result
		  
		  d.IconType = MessageDialog.IconTypes.Caution       // display warning icon
		  
		  d.ActionButton.Caption = "Delete"
		  
		  d.CancelButton.Visible = True               // show the Cancel button
		  
		  // d.AlternateActionButton.Visible = True      // show the "Don't Save" button
		  // d.AlternateActionButton.Caption = "Don't Save"
		  
		  d.Message = message
		  d.Explanation = "This action cannot be undone"
		  
		  b = d.ShowModal                             // display the dialog
		  
		  Select Case b                               // determine which button was pressed.
		    
		  Case d.ActionButton
		    
		    return true
		    
		  Case d.AlternateActionButton
		    // user pressed Don't Save
		  Case d.CancelButton
		    // user pressed Cancel
		  End Select
		  
		  return false
		  
		End Function
	#tag EndMethod


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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
	#tag EndViewBehavior
End Module
#tag EndModule
