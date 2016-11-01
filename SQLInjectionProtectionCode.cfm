<!--- Program: SQLInjectionProtectionCode.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/19/2012 --->
<!--- Date in Production: 09/19/2012 --->
<!--- Module: Application ColdFusion Error Handler --->
<!-- Last modified by John R. Pastori on 12/18/2014 using ColdFusion Studio. -->
<!-- Added Carol Phillips' Home IP address to be bypassed for injection checking. - 10/02/2014 - JRP -->
<!-- Added 130.191.26 subnet to be bypassed for injection checking. - 12/18/2014 - JRP -->

<!---- 
SQL INJECTION PROTECTOR CODE (stored in /application.cfm)
=======================================================
 --->
<!--- CREATE SQL REGULAR EXPRESSION--->
<CFSET sqlregex = "(DECLARE\s\@[\w]+)|(SELECT\s[\w\*\)\(\,\s]+\sFROM\s[\w]+)|(UPDATE\s[\w]+\sSET\s[\w\,\'\=]+)|(INSERT\sINTO\s[\d\w]+[\s\w\d\)\(\,]*\sVALUES\s\([\d\w\'\,\)]+)|(DELETE\sFROM\s[\d\w\'\=]+)|(DROP\sTABLE\s[\d\w\'\=]+)">

<CFSET ERRORFOUND = "NO">

<CFIF LEFT(CGI.REMOTE_ADDR, 10) NEQ '130.191.17' AND LEFT(CGI.REMOTE_ADDR, 10) NEQ '130.191.26' AND LEFT(CGI.REMOTE_ADDR, 11) NEQ '130.191.104' AND LEFT(CGI.REMOTE_ADDR, 11) NEQ '130.191.106' AND CGI.REMOTE_ADDR NEQ '146.244.137.189' AND CGI.REMOTE_ADDR NEQ '98.176.2.148'>
<!--- CHECK FORM VARIABLES --->

     <CFLOOP collection="#FORM#" item="FORM.FIELDNAMES">
          <CFIF isSimpleValue(evaluate(FORM.FIELDNAMES)) AND refindnocase(sqlregex, "#evaluate(FORM.FIELDNAMES)#")>
               <CFLOCATION url="appcoldfusionerror.cfm?message=Invalid Input. Possible SQL Injection attack.">
               <CFSET StructClear(FORM)>
               <CFSET ERRORFOUND = "YES">
          </CFIF>
     </CFLOOP>

<!--- CHECK URL VARIABLES --->

	<CFPARAM name="CGI.query_string" default="">

	<CFIF 
          CGI.query_string contains "CAST" or 
          CGI.query_string contains "CHAR" or 
          CGI.query_string contains "CONVERT" or 
          CGI.query_string contains "DECLARE" or 
          CGI.query_string contains "DROP" or 
          CGI.query_string contains "EXEC" or 
          CGI.query_string contains "EXECUTE" or 
          CGI.query_string contains "INSERT" or 
          CGI.query_string contains "SELECT" or 
          CGI.query_string contains "VARCHAR" or 
          CGI.query_string contains "UPDATE"
     >
     
          <CFSET ERRORFOUND EQ "YES">
     
          <CFOUTPUT>
     
          <PRE>
     
               <H1>HACK ATTEMPT RECORDED FROM IP: #CGI.remote_addr#</H1>
     
               #DateFormat(Now(), "MM-DD-YYYY")# @ #TimeFormat(Now(), "HH:MM:SS")#
     
               #CGI.script_name#&#CGI.query_string#
     
          </PRE>
     
          </CFOUTPUT>
     
     </CFIF>
     
     <CFIF ERRORFOUND EQ "YES">
          <CFMAIL
     
          to="pastori@rohan.sdsu.edu"
     
          from="webmaster@lfolks.sdsu.edu"
     
          subject="HACK attempt FROM IP: #CGI.remote_addr#">
     
               HACK ATTEMPT RECORDED:
     
               #DateFormat(Now(), "MM-DD-YYYY")# @ #TimeFormat(Now(), "HH:MM:SS")#
     
               IP: #CGI.remote_addr#
     
               ATTEMPT:
     
               http://#CGI.server_name#/#CGI.script_name#&#CGI.query_string#
     
          </CFMAIL>
     
          <CFABORT>
     </CFIF>

</CFIF>