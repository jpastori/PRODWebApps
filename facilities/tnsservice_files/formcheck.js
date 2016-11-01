/* -----------------------------------------------------------------------------------
Created by: Anh Gross @ PINT Inc.
   Modified:	 6.7.01
	 								Added new features 
							 9.10.01
							    Added Confirm function
							4.18.02
								Added checkDate function
							12.11.02 
							Kun added unset, reset for Logical OR stuff
----------------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------------
USAGE: include the lines between START to END in your html page:

		//START
		<script src="formcheck.js"></script>
		
		<script>
			set_variables('name','blank','Full Name','');
			set_variables('username','Minimum Length','Username','6');
			set_variables('username','Maximum Length','Username','10');
			set_variables('password','Maximum Length','Password','8');
			set_variables('password','Alpha-Numeric','Password','');
			set_variables('publish_date','Date','Publish Date: Invalid Format','');
		</script>
		//END

IMPORTANT NOTES: 
Call set_variables function for each field you want to check for. This function takes
4 parameters: name, check_for, message, extra_info.

 * name: the exact name of the form field
 * check_for: which type you want to check for. 
			Currently there are 8 types: blank, Email, US Phone, Numeric, Credit Card, Maximum Length,
			Minimum Length, Alpha-Numeric, Date, and File Extension 
			Type names are cAsE sEnSiTiVe!!!
 * message: Any error message you want to include
 * extra_info: Used in Maximum length, Minimum length, File Extension check. Leave
 			blank when not used.
			
 * for Confirm function: extra_info is the second field name used to compare with name
 		example: set_variables('password','Confirm', 'Confirm password failed', 'confirm_password');
				
Other examples of using set_variables:
set_variables('email','Email','Email Address','');
set_variables('phone','US Phone', 'Phone Number','');
set_variables('quantity', 'Numeric', 'Number of hats','');
set_variables('card_number', 'Credit Card', 'Credit Card Number','');
set_variables('prod_image','Product Image','File', 'gif,jpg');	
set_variables('sales_brief','Sales Brief','File', 'xls,txt,doc,pdf');	
----------------------------------------------------------------------------------- */


//==================== USER SHOULD NOT MODIFY BEYOND THIS POINT ====================//

// Initializing global variables
var Names = new Array();
var CheckFor = new Array();
var Errors = new Array();
var ExtraInfo = new Array();
var error_message = "";
var firstfield = "";	
var errorFontIDName = new Array();

/* -----------------------------------------------------------------------------------
Function: 		set_variables
Description:	Set variables to Names, CheckFor and Errors array
----------------------------------------------------------------------------------- */
function set_variables(name, check_for, message, extra_info)
{
	 var i = Names.length;
	 Names[i] = name; 
	 CheckFor[i] = check_for; 
	 Errors[i] = message;
	 ExtraInfo[i] = extra_info;
}
/* -----------------------------------------------------------------------------------
Function: 		unset_variables
Description:	unSet variables NOT to check this element again
----------------------------------------------------------------------------------- */
function unset_variables(name,form)
{
	 for (i = 0; i < Names.length; i++)
	 {
	 	field = eval('form.'+Names[i]).name;
		if (field == name)
		{
			Errors[i] = "";
			ExtraInfo[i] = "Unset";
		}
	 }
}
/* -----------------------------------------------------------------------------------
Function: 		reset_variables for logical OR
Description:	reSet variables to check this element again **** specific for sdsu only
				need to refactor for other project for reseting with 
				2 more arguments msg and extra so it can decouple this code from 
				the specific project.
				What was I thinking doing this?  Time limit and get thing to work and see
				first and lazy to go back in and refator it.
				Think it again I will refactor it now.!!!
----------------------------------------------------------------------------------- */
function reset_variables(name,form,check_for,message,extra_info)
{
	 for (i = 0; i < Names.length; i++)
	 {
	 	field = eval('form.'+Names[i]).name;
		if (field == name)
		{
			Errors[i] = message;
			ExtraInfo[i] = extra_info;
			CheckFor[i] = check_for;
		}
	 }
}

/* -----------------------------------------------------------------------------------
Function: 		checkPhoneExtension
Description:	checkPhoneExtension will check specificially for SDSU Phone Logical OR
----------------------------------------------------------------------------------- */
function checkPhoneExtension(form)
{
	var 
			requestor_phone1 = false;
			requestor_phone2 = false;
			requestor_phone_ext = false;
			alternate_requestor_phone1 = false;
			alternate_requestor_phone2 = false;
			alternate_requestor_phone_ext = false;
			reported_phone_1 = false;
			reported_phone_2 = false;
			reported_phone_ext = false;
			alt_phone_1 = false;
			alt_phone_2 = false;
			alt_phone_ext = false;
	
	 for (i = 0; i < Names.length; i++)
	 {
	 	field = eval('form.'+Names[i]);
		Xinfo = ExtraInfo[i];
		
		if (field.name == "requestor_phone1")
			requestor_phone1 = checkAreaCode(field,Xinfo);
			
		else if (field.name == "alternate_requestor_phone1")
			alternate_requestor_phone1 = checkAreaCode(field,Xinfo);
		
		else if (field.name == "reported_phone_1") 
			reported_phone_1 = checkAreaCode(field,Xinfo);
			
		else if (field.name == "alt_phone_1") 
			alt_phone_1 = checkAreaCode(field,Xinfo);
		
		else if (field.name == "requestor_phone2")
			requestor_phone2 = checkPhone(field,Xinfo);
			
		else if (field.name == "alternate_requestor_phone2") 
			alternate_requestor_phone2 = checkPhone(field,Xinfo);
		
		else if (field.name == "reported_phone_2") 
			reported_phone_2 = checkPhone(field,Xinfo);
		
		else if (field.name == "alt_phone_2") 
			alt_phone_2 = checkPhone(field,Xinfo);
		
		else if (field.name == "requestor_phone_ext")
			requestor_phone_ext = checkExtension(field,Xinfo);
			
		else if (field.name == "alternate_requestor_phone_ext")
			alternate_requestor_phone_ext = checkExtension(field,Xinfo);
		
		else if (field.name == "reported_phone_ext") 
			reported_phone_ext = checkExtension(field,Xinfo);
			
		else if (field.name == "alt_phone_ext") 
			alt_phone_ext = checkExtension(field,Xinfo);
	 }
	 if( (requestor_phone1 && requestor_phone2) || requestor_phone_ext )
		{
			unset_variables('requestor_phone1',form);
			unset_variables('requestor_phone2',form);
			unset_variables('requestor_phone_ext',form);
		}
	else
		{
			reset_variables('requestor_phone1',form,'Minimum Length','Area Code 3 digits','3'); 
			reset_variables('requestor_phone2',form,'Minimum Length','Phone 7 digits OR','7');
			reset_variables('requestor_phone_ext',form,'Minimum Length','Extension 5 digits','5');
		}
	if( (alternate_requestor_phone1 && alternate_requestor_phone2) || alternate_requestor_phone_ext )
		{
			unset_variables('alternate_requestor_phone1',form);
			unset_variables('alternate_requestor_phone2',form);
			unset_variables('alternate_requestor_phone_ext',form);
		}
	else
		{
			reset_variables('alternate_requestor_phone1',form,'Minimum Length','Area Code 3 digits','3'); 
			reset_variables('alternate_requestor_phone2',form,'Minimum Length','Phone 7 digits OR','7');
			reset_variables('alternate_requestor_phone_ext',form,'Minimum Length','Extension 5 digits','5');
		}
	if( (reported_phone_1 && reported_phone_2) || reported_phone_ext )
		{
			unset_variables('reported_phone_1',form);
			unset_variables('reported_phone_2',form);
			unset_variables('reported_phone_ext',form);
		}
	else
		{
			reset_variables('reported_phone_1',form,'Minimum Length','Area Code 3 digits','3'); 
			reset_variables('reported_phone_2',form,'Minimum Length','Phone 7 digits OR','7');
			reset_variables('reported_phone_ext',form,'Minimum Length','Extension 5 digits','5');
		}
	if( (alt_phone_1 && alt_phone_2) || alt_phone_ext )
		{
			unset_variables('alt_phone_1',form);
			unset_variables('alt_phone_2',form);
			unset_variables('alt_phone_ext',form);
		}
	else
		{
			reset_variables('alt_phone_1',form,'Minimum Length','Area Code 3 digits','3'); 
			reset_variables('alt_phone_2',form,'Minimum Length','Phone 7 digits OR','7');
			reset_variables('alt_phone_ext',form,'Minimum Length','Extension 5 digits','5');
		}
}

/* -----------------------------------------------------------------------------------
Function: 		check_form
Description:	Main function which will process the Names, CheckFor and Errors arrays
							and call appropriate functions for specific type check.
----------------------------------------------------------------------------------- */
function check_form(form)
{
	checkPhoneExtension(form);
	
	for (i = 0; i < Names.length; i++)
	{
		type = eval('form.'+Names[i]).type;
		field = eval('form.'+Names[i]);
		msg = Errors[i];
		Xinfo = ExtraInfo[i];

		if( type == "text" || type == "textarea" || type == "password" || type == "file")
		{
			if(CheckFor[i] == "US Phone") 
				checkUSPhone(field,msg);
				
			else if(CheckFor[i] == "Email") 
				checkEmail(field,msg);
				
			else if(CheckFor[i] == "Numeric") 
				isNumeric(field,msg);
				
			else if(CheckFor[i] == "Credit Card") 
				checkCard(field,msg);
				
			else if(CheckFor[i] == "Maximum Length")
				checkMaxLength(field,msg,Xinfo);
				
			else if(CheckFor[i] == "Minimum Length")
				checkMinLength(field,msg,Xinfo);
				
			else if(CheckFor[i] == "Alpha-Numeric")
				isAlphaNumeric(field,msg);
				
			else if(CheckFor[i] == "File Extension")
				checkFileExtension(field,msg,Xinfo);
				
			else if(CheckFor[i] == "Confirm")
			{
				field2 = eval('form.'+ Xinfo);	
				checkConfirm(field,field2,msg);
			}
			
			else if(CheckFor[i] == "Date")
				checkDate(field,msg);
			
			else 
				checkText(field,msg,Xinfo);						
		}
			
		else if(type == "select-one" || type == "select-multiple")
			checkSelect(field,msg);			
			
		//checkbox/radio field has length one		
		else if(type == "checkbox" || type == "radio")	
			checkSingleRadioXBox(field,msg);	
	
		//checkbox/radio field has length greater than one
		else if(!type)
			checkRadioXbox(field,msg);	

		else{}	
	}
	
	return check_message();	
}


/* -----------------------------------------------------------------------------------
Function: 		check_message
Description:	Check to see if there is any error message collected.
							Return true if no error was found.
							Return false if error was found
----------------------------------------------------------------------------------- */
function check_message()
{
	back_event = "";
	for (i = 0; i < document.forms[1].elements.length; i++ )
		{
		if (document.forms[1].elements[i].name == "Back")
			{
			back_event = document.forms[1].elements[i].value;
			}
		}
	//alert(back_event);
	if( back_event == "back to previous page")
	{
	return true;
	}
	else if(error_message != "")
	{
		alert("Please fix the following required fields:\n" + error_message);

		//reset error message to blank
		error_message = "";
		
		if(window.focus)
		{
			if(firstfield != "")
			{
			  focusfield = firstfield;
				firstfield = "";
				focusfield.focus();		
			}  
		}
		return false;
	}
return true;
}


/* -----------------------------------------------------------------------------------
Function: 		checkText
Description:	Check for blank value in fields of type TEXT. 
							Add error message if value in blank
----------------------------------------------------------------------------------- */
function checkText(field,error,Xinfo)
{
	if(field.value == "" && Xinfo != "Unset")	
	{
		error_message += error + "\n";	
		turnRed(field);
		if(firstfield == "")
			firstfield = field;
	}
	else
	{
		turnBlack(field);
	}
}


/* -----------------------------------------------------------------------------------
Function: 		checkSelect
Description:	Check for a selection from fields of type SELECT (One or Multiple). 
							Add error message if no selection was made.
----------------------------------------------------------------------------------- */
function checkSelect(field,error)
{
	selected = field.selectedIndex;
	
	if(field[selected].value == "")
	{
		turnRed(field);
		error_message += error + "\n";
		if(firstfield == "")
			firstfield = field;
	}
	else
	{
		turnBlack(field);
	}
}


/* -----------------------------------------------------------------------------------
Function: 		checkSingleRadioXBox
Description:	Check for a selection from fields of type RADIO or CHECKBOX with ONLY ONE
							element. 
							Add error message if no selection was made.
----------------------------------------------------------------------------------- */
function checkSingleRadioXBox(field,error)
{
	if(!field.checked)
	{
		turnRed(field);
		error_message += error + "\n";
	}
	else
	{
		turnBlack(field);
	}
}


/* -----------------------------------------------------------------------------------
Function: 		checkRadioXbox
Description:	Check for a selection from fields of type RADIO or CHECKBOX with MORE THAN
							ONE element. 
							Add error message if no selection was made.
----------------------------------------------------------------------------------- */
function checkRadioXbox(field,error)
{
	var checkedOne = 0;

	//loop through the field elements to check for selection
	for(var i = 0; i < field.length; i++)
	{
		if(field[i].checked)
			checkedOne = 1;
	}
	
	if(!checkedOne)
	{
		turnRed(field);
		error_message += error + "\n";	
	}
	else
	{
		turnBlack(field);
	}
}

/* -----------------------------------------------------------------------------------
Function: 		checkMaxLength
Description:	Check for maximum length of value
							Add error message if length is greater than maximum characters allowed
----------------------------------------------------------------------------------- */
function checkMaxLength(field,error,maximum)
{
	//checkText(field,error);
	if(field.value.length > maximum)
	{
		turnRed(field);
		error_message += error + "\n";
		if(firstfield == "")
			firstfield = field;
	}
	else
	{
		turnBlack(field);
	}
}

/* -----------------------------------------------------------------------------------
Function: 		checkMinLength
Description:	Check for mininum length of value
							Add error message if length is less than minimum characters required
----------------------------------------------------------------------------------- */
function checkMinLength(field,error,minimum)
{
	if(field.value.length < minimum)
	{
		turnRed(field);
		error_message += error + "\n";
		if(firstfield == "")
			firstfield = field;
	}
	else
	{
		turnBlack(field);
	}
}

/* -----------------------------------------------------------------------------------
Function: 		checkAreaCode
Description:	Check for minimum length of value
							Add error message if length is less than minimum characters required
----------------------------------------------------------------------------------- */
function checkAreaCode(field,minimum)
{
	if (minimum == "Unset")
		minimum = 3;
	if(field.value.length < minimum)
	{
		return false;
	}
	else
	{
		return true;
	}
}

/* -----------------------------------------------------------------------------------
Function: 		checkPhone
Description:	Check for minimum length of value
							Add error message if length is less than minimum characters required
----------------------------------------------------------------------------------- */
function checkPhone(field,minimum)
{
	if (minimum == "Unset")
		minimum = 7;
	if(field.value.length < minimum)
	{
		return false;
	}
	else
	{
		return true;
	}
}

/* -----------------------------------------------------------------------------------
Function: 		checkExtension
Description:	Check for minimum length of value
							Add error message if length is less than minimum characters required
----------------------------------------------------------------------------------- */
function checkExtension(field,minimum)
{
	if (minimum == "Unset")
		minimum = 5;
	if(field.value.length < minimum)
	{
		return false;
	}
	else
	{
		return true;
	}
}



/* -----------------------------------------------------------------------------------
Function: 		CheckCard
Description:	Check to see if credit card number is either a valid Visa, MasterCard
							or American Express.
							Add error message if card number is invalid
----------------------------------------------------------------------------------- */
function checkCard(field,error)
{
	var card = field.value;
	
	if(!( isVisa(card) || isMasterCard(card) || isAmericanExpress(card) ))
	{
		turnRed(field);
		error_message += error + ": invalid card number\n";
		if(firstfield == "")
			firstfield = field;
	}
	else
	{
		turnBlack(field);
	}
}


/* -----------------------------------------------------------------------------------
Function: 		isCreditCard
Description:	Check to see if credit card number is valid.
							Return true if a valid number.
							Return false if not a valid number.
----------------------------------------------------------------------------------- */
function isCreditCard(st) 
{
  
	// Encoding only works on cards with less than 19 digits
  if (st.length > 19)
    return (false);

  sum = 0; mul = 1; l = st.length;
  for (i = 0; i < l; i++) {
    digit = st.substring(l-i-1,l-i);
    tproduct = parseInt(digit ,10)*mul;
    if (tproduct >= 10)
      sum += (tproduct % 10) + 1;
    else
      sum += tproduct;
    if (mul == 1)
      mul++;
    else
      mul--;
  }

  if ((sum % 10) == 0)
    return (true);
  else
    return (false);

}


/* -----------------------------------------------------------------------------------
Function: 		isVisa
Description:	Check for valid Visa card number.
							Add error message if not a valid Visa number.
----------------------------------------------------------------------------------- */
function isVisa(cc)
{
  
	//strip all non-digit characters
	cc = stripNotAllowable(cc, "1234567890");
	
	if (((cc.length == 16) || (cc.length == 13)) && (cc.substring(0,1) == 4))
	  return (isCreditCard(cc))
	return false;		
}


/* -----------------------------------------------------------------------------------
Function: 		isMasterCard
Description:	Check for valid MasterCard number.
							Add error message if not a valid MasterCard number.
----------------------------------------------------------------------------------- */
function isMasterCard(cc)
{
  
	//strip all non-digit characters
	cc = stripNotAllowable(cc, "1234567890");
	
	firstdig = cc.substring(0,1);
  seconddig = cc.substring(1,2);
  if ((cc.length == 16) && (firstdig == 5) && ((seconddig >= 1) && (seconddig <= 5)))
    return (isCreditCard(cc))
	return false;
}


/* -----------------------------------------------------------------------------------
Function: 		isAmericanExpress
Description:	Check for valid American Express number.
							Add error message if not a valid American Express number.
----------------------------------------------------------------------------------- */
function isAmericanExpress(cc)
{
  
	//strip all non-digit characters
	cc = stripNotAllowable(cc, "1234567890");
	
	firstdig = cc.substring(0,1);
  seconddig = cc.substring(1,2);
  if ((cc.length == 15) && (firstdig == 3) && ((seconddig == 4) || (seconddig == 7)))
  	return (isCreditCard(cc))
	return false;
}


/* -----------------------------------------------------------------------------------
Function: 		stripNotAllowable
Description:	Stripping all characters not allowed in a list of allowed characters.
							Return the cleaned up string.
----------------------------------------------------------------------------------- */
function stripNotAllowable(s, allowable)
{ 
	var returnString = "";

  // Search through string's characters one by one.  If character is allowable, append to returnString.	
	for (var i = 0; i < s.length; i++)
	{   
	   var c = s.charAt(i);
	   if (allowable.indexOf(c) != -1) 
		 	returnString += c;
	}
	
	return returnString;
}


/* -----------------------------------------------------------------------------------
Function: 		checkUSPhone
Description:	Check for valid US phone numbers (consists of ten digits)
							Add error message if not a valid number
----------------------------------------------------------------------------------- */
function checkUSPhone(field, error)
{
	
	//make sure that field value exists
	checkText(field,error + ' can not be empty');
	
	if (field.value.length > 0)
	{
		var badformat = 0;
		
		//checking for non-allowable characters
		var str = stripNotAllowable(field.value, "1234567890.()- ");
		badformat = (str.length < field.value.length)?1:0;
		
		//checking for 10 digits
		USPhone = stripNotAllowable(field.value, "1234567890");
		badformat = (USPhone.length != 10 || badformat )?1:0;
		
		if (badformat) 
		{
			turnRed(field);
			error_message += error +": wrong format\n";	
			if(firstfield == "")
				firstfield = field;
		}
		else
		{
			turnBlack(field);
		}
	}
}


/* -----------------------------------------------------------------------------------
Function: 		checkEmail
Description:	Check for valid email addresses
							Add error message if not a valid email address
----------------------------------------------------------------------------------- */
function checkEmail(field,error)
{
	
	//make sure that field value exists
	checkText(field,error + ' can not be empty');
	
	if (field.value.length > 0)
	{
		var email = field.value;
		var len = email.length;
		var badformat = false;
		
		//check for illegal characters in email
		illegalChars = stripNotAllowable(email, "'\"\\/()`~!#$%^&*+}{|:;?><,[]");
		
		firstChar = stripNotAllowable(email.charAt(0), ".@");
		lastChar = stripNotAllowable(email.charAt(len - 1), ".@");
		
		//email length must be > 5, there must be an @ and a . and they can not be at the end of the email string
		if (len < 5 || email.indexOf('@') == -1 || firstChar != "" || lastChar != "")
	  	badformat = true;
		else
		{
			var firstAt = email.indexOf('@');
			var afterAt = email.substring(firstAt +1, len);
			
			var Atcounts = stripNotAllowable(afterAt, "@");
			var Pcounts	 = stripNotAllowable(afterAt, ".");
			
			// more @ after first @ or no . after first @ or period is found right after first @ set badformat to true
			badformat = (Atcounts.length > 0 || Pcounts == 0 || email.charAt(firstAt+1)== '.' || illegalChars != '')? true:false;
	
		}
		
		if(badformat)
		{
				turnRed(field);
				error_message += error +": wrong format\n";	
				if(firstfield == "")
					firstfield = field;
		}
		else
		{
			turnBlack(field);
		}
	}
}

/* -----------------------------------------------------------------------------------
Function: 		checkConfirm
Description:	Making sure that 2 field values matche. Use for confirming passord, email, etc.
							Add error message if values do not match
----------------------------------------------------------------------------------- */
function checkConfirm(field, field2, error)
{ 
	
	if (field.value != field2.value)
	{
		turnRed(field);
		error_message += error + "\n";	
		if(firstfield == "")
			firstfield = field2;
	}
	else
	{
		turnBlack(field);
	}
}	

/* -----------------------------------------------------------------------------------
Function: 		isNumeric
Description:	Checking for numeric value.
							Add error message if value is not numeric
----------------------------------------------------------------------------------- */
function isNumeric(field, error)
{ 
	//make sure that field value exists
	checkText(field,error + ' can not be empty');
	
	if (field.value.length > 0)
	{
		if(isNaN(field.value))
		{
			turnRed(field);
			error_message += error + " must be numeric\n";	
				if(firstfield == "")
					firstfield = field;
		}
		else
		{
			turnBlack(field);
		}
	}
}	


/* -----------------------------------------------------------------------------------
Function: 		isAlphaNumeric
Description:	Checking for alpha-numeric value.
							Add error message if value is not alpha-numeric
----------------------------------------------------------------------------------- */
function isAlphaNumeric(field, error)
{ 
	
	//make sure that field value exists
	checkText(field,error + ' can not be empty');
	
	if (field.value.length > 0)
	{
		Alpha = stripNotAllowable(field.value, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
		Numeric = stripNotAllowable(field.value, "0123456789");
		
		if(Alpha.length == 0 || Numeric.length == 0 || (Alpha.length + Numeric.length) < field.value.length)
		{
			turnRed(field);
			error_message += error +  " must be alpha-numeric\n";	
				if(firstfield == "")
					firstfield = field;
		}
		else
		{
			turnBlack(field);
		}
	}
}	

/* -----------------------------------------------------------------------------------
Function: 		checkFileExtension
Description:	Checking for a valid file extension when uploading a file.
							Add error message if file extension is not in the allowable extension list
----------------------------------------------------------------------------------- */
function checkFileExtension(field, error, extensions)
{ 
	checkText(field,error + ' can not be empty');
	if (field.value.length > 0)
	{
		var extArray = new Array();
		var extFound = 0;
		
		extensions = extensions.toLowerCase();
		
		// full path of file being uploaded
		file = field.value.toLowerCase();	
		
		// getting the extension for file being uploaded
		ext = file.substring(file.indexOf('.') +1, file.length);
		
		// store allowable extensions in a temp variable
		tempext = extensions;
		
		// get the first comma
		var commaIndex = tempext.indexOf(',');
	
		while (commaIndex > 0)
		{
			sublist = tempext.substring(0, commaIndex);
			extArray[extArray.length] = sublist;	
			tempext = tempext.substring(commaIndex +1,tempext.length);
			commaIndex = tempext.indexOf(',');
			if(commaIndex < 0)
				extArray[extArray.length] = tempext;			
		}
		
		for(var i=0; i < extArray.length; i++)
		{
			if(extArray[i] == ext)		
				extFound = 1;
		}
		
		if(!extFound)
		{
			turnRed(field);
			error_message += error +  ": wrong file extension\n";	
				if(firstfield == "")
					firstfield = field;
		}
		else
		{
			turnBlack(field);
		}
	}
}	


/* -----------------------------------------------------------------------------------
Function: 		checkDate
Description:	Check for valid date format
----------------------------------------------------------------------------------- */
function checkDate(field, error)
{ 
	if (field.value.length > 0)
	{
		var date = Date.parse(field.value);
		
		if(isNaN(date))
		{
			turnRed(field);
			error_message += error + "\n";	
				if(firstfield == "")
					firstfield = field;
		}
		else
		{
			turnBlack(field);
		}
	}
}
/* -----------------------------------------------------------------------------------
Function: 		turnRed
Description:	change text color of font of each form element to be red
Programmer:		Kun Puparussanon
----------------------------------------------------------------------------------- */
function turnRed(field)
{
	var field_name = field.name + '_font';
	if(field_name) 
	{
		if(document.getElementById(field_name))
		{
			document.getElementById(field_name).style.color='red';
		}
	}
}
/* -----------------------------------------------------------------------------------
Function: 		turnBlack
Description:	change text color of font of each form element to be black
Programmer:		Kun Puparussanon
----------------------------------------------------------------------------------- */
function turnBlack(field)
{
	var field_name = field.name + '_font';
	if(field_name) 
	{
		if(document.getElementById(field_name))
		{
			document.getElementById(field_name).style.color='black';
		}
	}
}
/* -----------------------------------------------------------------------------------
Function: 		numberOnly
Description:	not allow any characters but digits
Programmer:		Thomas recommended and Kun typed.
----------------------------------------------------------------------------------- */
function numbersOnly(field, event)
{
 var key,keychar;

 if (window.event)
   key = window.event.keyCode;
 else if (event)
    key = event.which;
 else
    return true;
 keychar = String.fromCharCode(key);
  // check for special characters like backspace
  // then check for the numbers 
 if ((key==null) || (key==0) || (key==8) || 
     (key==9) || (key==13) || (key==27) )
   return true;
  else if ((("0123456789-.").indexOf(keychar) > -1))
         {
           window.status = "";
           return true;
         }
       else
         {
           window.status = "Field excepts numbers - and . only"; 
           return false;
         }
 }