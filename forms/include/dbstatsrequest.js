<!-- Script starts here ---->
<!--LAST MODIFIED BY JOHN R.PASTORI ON March 04, 2002 USING Cold Fusion Studio-->
<SCRIPT LANGUAGE=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to  the LIBRARY Database Statistics Program.";
	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		var yeardiff = 0;
		var monthdiff = 0;
		yeardiff = document.dbstatsrequest.endyear.selectedIndex - document.dbstatsrequest.beginyear.selectedIndex;
		monthdiff = document.dbstatsrequest.endmonth.selectedIndex - document.dbstatsrequest.beginmonth.selectedIndex;
//		document.writeln("YEARDIFF is " + yeardiff + "<br/>");
//		document.writeln("PROCESSTYPE  is " + document.dbstatsrequest.processtype.selectedIndex + "<br/>");
		if (document.dbstatsrequest.processtype.selectedIndex == "0") {
			if (document.dbstatsrequest.beginyear.selectedIndex == "0" && document.dbstatsrequest.endyear.selectedIndex > "0") {
				alertuser (document.dbstatsrequest.beginyear.name +  ",  You must select a consective Begin Year-End Year range for an Annual Report if you want other than current year.");
				document.dbstatsrequest.endyear.selectedIndex = "0";
				document.dbstatsrequest.beginyear.focus();
				return false;
			}
			if (document.dbstatsrequest.beginyear.selectedIndex > "0" || document.dbstatsrequest.endyear.selectedIndex > "0") {
				if (yeardiff > "1") {
					alertuser (document.dbstatsrequest.endyear.name +  ",  You must select a consective Begin Year-End Year range for an Annual Report.");
					document.dbstatsrequest.endyear.focus();
					return false;
				}
				if (yeardiff < "1") {
					alertuser (document.dbstatsrequest.endyear.name +  ",   End Year can NOT be less than or equal to Begin Year for an Annual Report.");
					document.dbstatsrequest.endyear.focus();
					return false;
				}
			}
			if (document.dbstatsrequest.beginmonth.selectedIndex > "0") {
				alertuser (document.dbstatsrequest.beginmonth.name +  ",   Begin Month can NOT be selected for an Annual Report. The default will always be 07.");
				document.dbstatsrequest.beginmonth.selectedIndex = "0";
				return false;
			}
			if (document.dbstatsrequest.endmonth.selectedIndex > "0") {
				alertuser (document.dbstatsrequest.endmonth.name +  ",   End Month can NOT be selected for an Annual Report. The default will always be 06.");
				document.dbstatsrequest.endmonth.selectedIndex = "0";
				return false;
			}
		}
		else if (document.dbstatsrequest.processtype.selectedIndex == "1") {
			if (document.dbstatsrequest.endmonth.selectedIndex > "0") {
				alertuser (document.dbstatsrequest.endmonth.name +  ",  End Month is NOT used for a Monthly Report.");
				document.dbstatsrequest.endmonth.selectedIndex = "0";
				document.dbstatsrequest.endmonth.focus();
				return false;
			}
			if (document.dbstatsrequest.endyear.selectedIndex > "0") {
				alertuser (document.dbstatsrequest.endyear.name +  ",  End Year is NOT used for a Monthly Report.");
				document.dbstatsrequest.endyear.selectedIndex = "0";
				document.dbstatsrequest.endyear.focus();
				return false;
			}
			if (document.dbstatsrequest.beginmonth.selectedIndex == "0" && document.dbstatsrequest.beginyear.selectedIndex > "0") {
				alertuser (document.dbstatsrequest.beginmonth.name +  ",  Begin Month MUST be selected if a Begin Year is selected for a Monthly Report.");
				document.dbstatsrequest.beginmonth.focus();
				return false;
			}
		}
		else if (document.dbstatsrequest.processtype.selectedIndex == "2") {
			if (document.dbstatsrequest.beginmonth.selectedIndex == "0") {
				alertuser (document.dbstatsrequest.beginmonth.name +  ",  You must select a Begin Month for a Range Of Months Report.");
				document.dbstatsrequest.beginmonth.focus();
				return false;
			}
			if (document.dbstatsrequest.beginyear.selectedIndex == "0") {
				alertuser (document.dbstatsrequest.beginyear.name +  ",  You must select a BeginYear for a Range Of Months Report.");
				document.dbstatsrequest.beginyear.focus();
				return false;
			}
			if (document.dbstatsrequest.endmonth.selectedIndex == "0") {
				alertuser (document.dbstatsrequest.endmonth.name +  ",  You must select a End Month for a Range Of Months Report.");
				document.dbstatsrequest.endmonth.focus();
				return false;
			}
			if (document.dbstatsrequest.endyear.selectedIndex == "0") {
				alertuser (document.dbstatsrequest.endyear.name +  ",  You must select a End Year for a Range Of Months Report.");
				document.dbstatsrequest.endyear.focus();
				return false;
			}
			if (yeardiff < "0") {
				alertuser (document.dbstatsrequest.endyear.name +  ",   End Year can NOT be less than Begin Year for a Range Of Months Report.");
				document.dbstatsrequest.endyear.focus();
				return false;
			}
			if (yeardiff == "0" && monthdiff < "0") {
				alertuser (document.dbstatsrequest.endmonth.name +  ",   End Month can NOT be less than Begin Month when Begin Year and End Year are the same for a Range Of Months Report.");
				document.dbstatsrequest.endyear.focus();
				return false;
			}
		}
	}
//
</SCRIPT>
<!--Script ends here -->