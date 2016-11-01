
/* -----------------------------------------------------------------------
*	open a new window
----------------------------------------------------------------------- */
function open_window( location , window_name )
{
	var width=630
	var height=480
	open_window_with_size( location , window_name, width, height )
}
		
/* -----------------------------------------------------------------------
*	open a new window with width and height specified
----------------------------------------------------------------------- */
function open_window_with_size( location , window_name, width, height )
{
	var status = "status=1,location=0,menubar=0,toolbar=0,scrollbars=1,resizable=1,width=" + width + ",height=" + height;
	window.open( location , window_name , status );
}

/* -----------------------------------------------------------------------
*	open a new window for images
----------------------------------------------------------------------- */
function open_image_window( location , window_name )
{
	var width=250;
	var heigh=250;
	open_window_with_size( location , window_name, width, height )	
}		
		
/* -----------------------------------------------------------------------
*		Close Window
----------------------------------------------------------------------- */		
function close_window()
{
	window.close();
}		
		
/* -----------------------------------------------------------------------
*		return delete confirmation
----------------------------------------------------------------------- */	
function confirm_delete(obj)
{
	return (confirm('Are you sure you want to delete ' + obj + '?'));
}		
		
		
/* -----------------------------------------------------------------------
*		Redirect to location
----------------------------------------------------------------------- */		
function redirect( location )
{	
	window.location = location;
}		
		
//submits first form in "content" frame
function processForm( action  , list_item_count )
{
	if (action == "Modify") 
		{
		if(isKeySelected( list_item_count ))
			{
			submitForm(action);
			}
		else
			{
			notSelectedPrompt(action);
			}
		}
	else if (action == "Delete")
		{
		if(isKeySelected( list_item_count ))
			{	
			if( deletePrompt( list_item_count ) )
				{
				submitForm(action); // confirm that user wants to delete record
				}
			}
		else
			{
			notSelectedPrompt(action);
			}
		}
	else if (action	== "Add")
		{
		submitForm(action);
		}
	return false;
}

function open_help_window(file)
{
window.open( file , 'cms_System_Help' , 'status=1,location=0,menubar=0,toolbar=0,scrollbars=1,resizable=1,width=360,height=270' );
}
		
function submitForm ( action )
{
	parent.content.document.forms[0].action.value = action;
	parent.content.document.forms[0].submit();
}
	
//reload "controls" frame
function reloadControlsFrame()
{
	parent.controls.location.reload();
}

//set form focus on paramters
function setFocus( form_name , form_element ) 
{
	document.forms[form_name].elements[form_element].focus();
}

//delete record prompt
function deletePrompt( list_item_count )
{
	var key 	= getKey( list_item_count );
	var label 	= "label" + key;

	var record_name = parent.content.document.forms[0].elements[label].value;	
	var msg = "Are you sure you want to delete '" + record_name + "'?"

	return confirm( msg );
}

//return selected key
function getKey( list_item_count ) 
	{
	var key = -1;
	
	if ( list_item_count == 1 )
		{
		//use different syntax for when there is only ONE list item
		key = parent.content.document.forms[ 0 ].key.value;
		}
	else
		{
		for( var i=0 ; i < parent.content.document.forms[0].length ; i++)
			{
			if ( parent.content.document.forms[0].key[i].checked )
				{
				key = parent.content.document.forms[0].key[i].value;
				break;
				}
			
			}		
		}
	return key;
	}



//selects a radio button
function select_key( list_item_to_select , number_of_items )
	{
	/* -----------------------------------------------------------
	*	PDL:	
	*	Check for special case of when there is only ONE list item
	*	IF ONE list item
	*		check if that item is selected
	*	ELSE
	*		run through all items and see if AT LEAST ONE item is selected
	*
	*	return selected INSIDE if statements or else function will error and return without return selected
	----------------------------------------------------------- */

	/* -----------------------------------------------------------
	*	There is a problem when there is only ONE list item.
	*	Check for this special case and change syntax for this occurrence.
	----------------------------------------------------------- */	
	
	if ( number_of_items == 1 )
		{
		parent.content.document.forms[ 0 ].key.checked = true;
		}
	else	
		{
		/* -----------------------------------------------------------
		*	Subtract by one because JavaScript starts index at 0
		*	whereas Cold Fusion starts index at 1
		----------------------------------------------------------- */		
		parent.content.document.forms[ 0 ].key[ list_item_to_select - 1 ].checked = true;			
		}		
	}	


	
	

//checks for selected radio button
function isKeySelected( list_item_selected ) 
	{
	var selected = false;
	
	/* -----------------------------------------------------------
	*	PDL:	
	*	Check for special case of when there is only ONE list item
	*	IF ONE list item
	*		check if that item is selected
	*	ELSE
	*		run through all items and see if AT LEAST ONE item is selected
	*
	*	return selected INSIDE if statements or else function will error and return without return selected
	----------------------------------------------------------- */
			
	/* -----------------------------------------------------------
	*	There is a problem when there is only ONE list item.
	*	Check for this special case and change syntax for this occurrence.
	----------------------------------------------------------- */
	if ( list_item_selected <= 0 )
		{
		selected = false;
		
		return selected;		
		}
	else if( list_item_selected == 1 )		
		{			
		//special case for when only ONE list item is displayed
		if ( parent.content.document.forms[ 0 ].key.checked )
			{
			selected = true;
			}
			
		return selected;			
		}
	else		
		{
		//case for when MORE THAN ONE list item is displayed
		for( var j=0 ; j < parent.content.document.forms[ 0 ].key.length ; j++ )
			{
			if ( parent.content.document.forms[ 0 ].key[ j ].checked )
				{
				selected = true;
				}			
			}
			
		return selected;
		}	
	}

	
//tell user that they need to select a record to operate on
function notSelectedPrompt( action ) 
	{
	alert("You must select a Record to " + action);
	return false;
	}
	
function checkAll( this_checkbox )
	{
	/*
	this_checkbox.checked = true;
	alert( this_checkbox.checked );
	*/
	}
	
	
/* -----------------------------------------------------------------------
*	BEGIN HTML Editor stuff
-----------------------------------------------------------------------*/	
var textarea_names 		= new Array();		//array to store textarea name information
var html_editor_names 	= new Array();		//array to store html_editor name information

//initialize arrays to nothing so you won't get an error finding the length
textarea_names[ 0 ] 	= "";
html_editor_names[ 0 ]	= "";

//ASSUME textarea_names and html_editor_names are SAME LENGTH
function add_html_editor( textarea_name )
	{
	//LOOP through array until we get to an "empty" spot to add info to
	var index = 0;
	while ( textarea_names[ index ] != "" )
		{
		index++;
		}
	
	//add new information to the next available slot
	textarea_names[ index ] 	= textarea_name;
	html_editor_names[ index ] 	= textarea_name + "_htmleditor";
	
	//so when you find the next "empty" spot you won't be comparing to jibberish in an unitialized array spot
	textarea_names[ index + 1 ] 	= "";
	html_editor_names[ index + 1 ] 	= "";
	}
	
function html_editor_to_form( form_name , textarea_name , html_editor_name )
	{
	document.forms[ form_name ].elements[ textarea_name ].value = document.all[ html_editor_name ].html;
	}
	
function submit_textarea( form_name )
	{
	//if the form is using an HTML editor then process it.
	if ( textarea_names[ 0 ] != "" )
		{
		//go to length - 1 because we added an extra field 
		for ( var index = 0 ; index < textarea_names.length - 1 ; index++ )
			{
			html_editor_to_form( form_name , textarea_names[ index ] , html_editor_names[ index ] );
			}
		}
	}		
/* -----------------------------------------------------------------------
*	END HTML Editor stuff
-----------------------------------------------------------------------*/		


/* -----------------------------------------------------------------------
*	Opens a new window to the selected item's detail page
-----------------------------------------------------------------------*/		
function view_page( list_item_count )
	{
	if( isKeySelected( list_item_count ) )
		{	
		//open up new window to view
		
		//get url parameters by finding key
		var key 			= getKey( list_item_count );
		var url_parameter 	= "url_parameters" + key;

		//concatenate base URL with URL parameters	
		var view_page_url = parent.content.document.forms[ 0 ].elements[ "view_url_template" ].value + parent.content.document.forms[0].elements[ url_parameter ].value;
		var new_window = window.open( view_page_url ); 
		}
	else
		{
		notSelectedPrompt('view a page');
		}	
	return false;
	}
	
/* -----------------------------------------------------------------------
*	Void function, do nothing
-----------------------------------------------------------------------*/
function my_void() {}

/* -----------------------------------------------------------------------
*	Function to keep a menu at a defined location in the window
-----------------------------------------------------------------------*/
function PersistLayer(layerName,firstTime){
	
	NSpath = "document.layers['" +layerName+ "']";
	IEpath = "document.all['" +layerName+ "']";
	
	var offset;
	var isIE=(document.all) ? 1 : 0;
	var isNav=(document.layers) ? 1 : 0;
	
	if(NSpath =='') {	
		if(isIE){ eval('var theLayer='+layerName)}	
		else{ eval('var theLayer=document.'+layerName)	}
		}	
	else{	
		if(isIE){ eval('var theLayer='+IEpath)}	
		else{ eval('var theLayer='+NSpath)	}
		}	

		if(eval(firstTime)){
			theLayer.XPOS = 0;
			theLayer.YPOS = 0;
		}

	if(isNav){	
		offset = self.pageXOffset
		if (offset != theLayer.XPOS){
			offset=offset-theLayer.XPOS
			theLayer.left+=offset
			theLayer.XPOS = theLayer.XPOS + offset;
			}
			
		offset = self.pageYOffset
		if (offset != theLayer.YPOS){
			offset=offset-theLayer.YPOS
			theLayer.top+=offset
			theLayer.YPOS = theLayer.YPOS + offset;
			}

	}
	else{
		offset = window.document.body.scrollLeft
		if (offset != theLayer.XPOS){
			offset=offset-theLayer.XPOS
			theLayer.style.pixelLeft+=offset
			theLayer.XPOS = theLayer.XPOS + offset;
			}
			
		offset = window.document.body.scrollTop
		if (offset != theLayer.YPOS){
			
			if (theLayer.YPOS < 150) {
			offset=offset-theLayer.YPOS;
			}
			
			else {
			offset=offset-theLayer.YPOS-150;
			}
			theLayer.style.pixelTop+=offset
			theLayer.YPOS = theLayer.YPOS + offset;
			
			}
	}
	
	theLayer.timerid = setTimeout("PersistLayer(\""+layerName+"\",'false')",500);

document.MM_returnValue=false;
theLayer.document.MM_returnValue=false;

}

/* ----------------------------------------------------------- 
*	START: SCRIPT FOR THE IMAGE LIBRARY INSERTION
 ----------------------------------------------------------- */	

// This function performs the actual insertion of a selected image file.
// The line containing the insertMediaFile function call is
// the important line.  All others are error checking and housekeeping.
function PerformSelection(sImageFile, sDescription) 
{ 
    var strEditorName = GetParameterValue("editorname"); 
 
	 // Error Checking
	    if(top.opener.closed) 
	    {       
	        alert("The parent page is no longer available."); 
	        return; 
	    } 
	    if(strEditorName.length == 0) 
	    { 
	        alert("The editor is not specified."); 
	        return; 
	    } 
	    if(sImageFile.length == 0) 
	    { 
	        alert("Please select a file before attempting an upload."); 
	        return; 
	    } 
	 
	 // This hides this window so that the user interface will be shown.
	 // Do this before calling the insertMediaFile function.
	    window.moveTo(-20000, 0); 
	 
	 // Here is where the insert actually happens.
	 
	//alert(window.name);
	//alert(window.top.name);
	//alert(window.top.opener.name);
	 top.opener.eWebEditPro.instances[strEditorName].insertMediaFile(sImageFile, false, sDescription, "IMAGE", 0, 0);
	 
	 // We are done.
	    window.close();  
}

////////////////////////////////////////////////////////
// This function and GetParameterValue are
// functions to extract parameters.
// Cold Fusion, ASP, and other servers have their own
// functionality to do this.
function ExtractParameters() 
{ 
       var strAddress = document.URL; 
       var strParams = ""; 
       var idx = strAddress.search(/\?/); 
       if(idx > 0) 
       { 
              strParams = strAddress.slice(idx + 1, -1); 
       } 
       return(strParams); 
} 
function GetParameterValue(sparamname) 
{ 
       var strParams = ExtractParameters(); 
       var strValue = ""; 
       var strElem = sparamname + "="; 
       var idx = 0; 
       if(strParams.slice(0, strElem.length) != strElem) 
       { 
              idx = strParams.search(strElem); 
       } 
       if(idx >= 0) 
       { 
              strValue = strParams.slice(idx + strElem.length, -1); 
              idx = strValue.search(/\&/); 
              if(idx > 0) 
              { 
                     strValue = strValue.slice(0, idx); 
              } 
       } 
       return(strValue); 
} 

/* ----------------------------------------------------------- 
*	START: SCRIPT FOR THE IMAGE LIBRARY INSERTION INTO A FORM FIELD
 ----------------------------------------------------------- */	
function SelectFile(imageFile, field) 
{ 
	field_object = eval('opener.document.forms[0].' + field);
	field_object.value = imageFile;
	self.close();
}

/* ----------------------------------------------------------- 
*	START: first_field_focus
 ----------------------------------------------------------- */	
function first_field_focus() 
{ 
	document.forms[0].elements[0].focus();
}
