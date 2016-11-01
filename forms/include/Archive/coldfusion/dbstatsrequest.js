<!-- Script starts here ---->
<!-- LAST MODIFIED BY JOHN R.PASTORI ON February 18, 2004 USING Cold Fusion Studio -->
<SCRIPT LANGUAGE=JAVASCRIPT TYPE="text/javascript" >
<!--
	window.defaultStatus = "Welcome to  the LIBRARY Database Statistics Program.";
	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		var yeardiff = 0;
		var monthdiff = 0;
		yeardiff = document.DBSTATSREQUEST.ENDYEAR.selectedIndex - document.DBSTATSREQUEST.BEGINYEAR.selectedIndex;
		monthdiff = document.DBSTATSREQUEST.ENDMONTH.selectedIndex - document.DBSTATSREQUEST.BEGINMONTH.selectedIndex;
//		document.writeln("YEARDIFF is " + yeardiff + "<br/>");
//		document.writeln("PROCESSTYPE  is " + document.DBSTATSREQUEST.PROCESSTYPE.selectedIndex + "<br/>");
		if (document.DBSTATSREQUEST.PROCESSTYPE.selectedIndex == "0") {
			if (document.DBSTATSREQUEST.BEGINYEAR.selectedIndex == "0" && document.DBSTATSREQUEST.ENDYEAR.selectedIndex > "0") {
				alertuser (document.DBSTATSREQUEST.BEGINYEAR.name +  ",  You must select a consective Begin Year-End Year range for an Annual Report if you want other than current year.");
				document.DBSTATSREQUEST.ENDYEAR.selectedIndex = "0";
				document.DBSTATSREQUEST.BEGINYEAR.focus();
				return false;
			}
			if (document.DBSTATSREQUEST.BEGINYEAR.selectedIndex > "0" || document.DBSTATSREQUEST.ENDYEAR.selectedIndex > "0") {
				if (yeardiff > "1") {
					alertuser (document.DBSTATSREQUEST.ENDYEAR.name +  ",  You must select a consective Begin Year-End Year range for an Annual Report.");
					document.DBSTATSREQUEST.ENDYEAR.focus();
					return false;
				}
				if (yeardiff < "1") {
					alertuser (document.DBSTATSREQUEST.ENDYEAR.name +  ",   End Year can NOT be less than or equal to Begin Year for an Annual Report.");
					document.DBSTATSREQUEST.ENDYEAR.focus();
					return false;
				}
			}
			if (document.DBSTATSREQUEST.BEGINMONTH.selectedIndex > "0") {
				alertuser (document.DBSTATSREQUEST.BEGINMONTH.name +  ",   Begin Month can NOT be selected for an Annual Report. The default will always be 07.");
				document.DBSTATSREQUEST.BEGINMONTH.selectedIndex = "0";
				return false;
			}
			if (document.DBSTATSREQUEST.ENDMONTH.selectedIndex > "0") {
				alertuser (document.DBSTATSREQUEST.ENDMONTH.name +  ",   End Month can NOT be selected for an Annual Report. The default will always be 06.");
				document.DBSTATSREQUEST.ENDMONTH.selectedIndex = "0";
				return false;
			}
		}
		else if (document.DBSTATSREQUEST.PROCESSTYPE.selectedIndex == "1") {
			if (document.DBSTATSREQUEST.ENDMONTH.selectedIndex > "0") {
				alertuser (document.DBSTATSREQUEST.ENDMONTH.name +  ",  End Month is NOT used for a Monthly Report.");
				document.DBSTATSREQUEST.ENDMONTH.selectedIndex = "0";
				document.DBSTATSREQUEST.ENDMONTH.focus();
				return false;
			}
			if (document.DBSTATSREQUEST.ENDYEAR.selectedIndex > "0") {
				alertuser (document.DBSTATSREQUEST.ENDYEAR.name +  ",  End Year is NOT used for a Monthly Report.");
				document.DBSTATSREQUEST.ENDYEAR.selectedIndex = "0";
				document.DBSTATSREQUEST.ENDYEAR.focus();
				return false;
			}
			if (document.DBSTATSREQUEST.BEGINMONTH.selectedIndex == "0" && document.DBSTATSREQUEST.BEGINYEAR.selectedIndex > "0") {
				alertuser (document.DBSTATSREQUEST.BEGINMONTH.name +  ",  Begin Month MUST be selected if a Begin Year is selected for a Monthly Report.");
				document.DBSTATSREQUEST.BEGINMONTH.focus();
				return false;
			}
		}
		else if (document.DBSTATSREQUEST.PROCESSTYPE.selectedIndex == "2") {
			if (document.DBSTATSREQUEST.BEGINMONTH.selectedIndex == "0") {
				alertuser (document.DBSTATSREQUEST.BEGINMONTH.name +  ",  You must select a Begin Month for a Range Of Months Report.");
				document.DBSTATSREQUEST.BEGINMONTH.focus();
				return false;
			}
			if (document.DBSTATSREQUEST.BEGINYEAR.selectedIndex == "0") {
				alertuser (document.DBSTATSREQUEST.BEGINYEAR.name +  ",  You must select a BEGINYEAR for a Range Of Months Report.");
				document.DBSTATSREQUEST.BEGINYEAR.focus();
				return false;
			}
			if (document.DBSTATSREQUEST.ENDMONTH.selectedIndex == "0") {
				alertuser (document.DBSTATSREQUEST.ENDMONTH.name +  ",  You must select a End Month for a Range Of Months Report.");
				document.DBSTATSREQUEST.ENDMONTH.focus();
				return false;
			}
			if (document.DBSTATSREQUEST.ENDYEAR.selectedIndex == "0") {
				alertuser (document.DBSTATSREQUEST.ENDYEAR.name +  ",  You must select a End Year for a Range Of Months Report.");
				document.DBSTATSREQUEST.ENDYEAR.focus();
				return false;
			}
			if (yeardiff < "0") {
				alertuser (document.DBSTATSREQUEST.ENDYEAR.name +  ",   End Year can NOT be less than Begin Year for a Range Of Months Report.");
				document.DBSTATSREQUEST.ENDYEAR.focus();
				return false;
			}
			if (yeardiff == "0" && monthdiff < "0") {
				alertuser (document.DBSTATSREQUEST.ENDMONTH.name +  ",   End Month can NOT be less than Begin Month when Begin Year and End Year are the same for a Range Of Months Report.");
				document.DBSTATSREQUEST.ENDYEAR.focus();
				return false;
			}
		}
	}
//-->
</SCRIPT>
<!--Script ends here -->