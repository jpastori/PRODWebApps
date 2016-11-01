<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: OracleImport.cfm--->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 04/20/2007 --->
<!--- Date in Production: 04/20/2007 --->
<!--- Module: ORACLE SYSADMIN PROCEDURES FOR GANDALF.SDSU.EDU --->
<!-- Last modified by John R. Pastori on 04/20/2007 using ColdFusion Studio. -->

<cfoutput>
<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/istops/GandalfOracle.cfm">
<CFSET CONTENT_UPDATED = "April 20, 2007">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Procedure 9:  Oracle Import tcsh script parameters.</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>
<DIV ALIGN="center"><H1>Procedure 9:  Oracle Import tcsh script parameters.</H1></DIV>
<BR />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The oraimport script has five parameters, separated by spaces, that must 
be included in the command line for both the "user" and "table" restore types and a sixth parameter that must
be included when using the "table" restore type.  All previous tables must first be deleted using the 
<A href="/#application.type#apps/istops/SQLDropStatement.html">SQL drop table command</A> with
<A href="/#application.type#apps/istops/OracleSysAdmProc3.html">Procedure ##3 </A>as described in step ##8 before starting this procedure.
The parameters are:

<UL>
	<OL>
		<LI>		The first parameter, designated $1 in the script, is the <STRONG><EM>restore type</EM></STRONG> and is <STRONG><EM>required</EM></STRONG>.
				The values for this parameter are "user" or "table".  The "user" value will cause the script to restore all the tables for a specific Oracle Schema Account name.
				
				The "table" value allows specific single or multiple tables to be imported by the table name.<BR /></LI>
<BR /><BR />
		<LI>		The second parameter, designated $2 in the script, is the ORACLE account <STRONG><EM>password </EM></STRONG> and is <STRONG><EM>required</EM></STRONG>.
				(See Barry, Carol, John or Ron for current user account passwords.)<BR /></LI>
<BR /><BR />
		<LI>		The third parameter, designated $3 in the script, is the <STRONG><EM>Oracle Instance Name (ORACLE_SID)</EM></STRONG> and is <STRONG><EM>required</EM></STRONG>.
				It is also used to set directory sub-path names and is part of the filename in which the export data is stored. 
				For production the value is "PRODAPPS" and for development it is "devapps".<BR /></LI>
<BR /><BR />
		<LI>		The fourth parameter, designated $4 in the script, is the <STRONG><EM>year month and day</EM></STRONG> that the export data file was created and is part
				of the filename and is <STRONG><EM>required</EM></STRONG>.
				It is in the format "yyyymmdd".  A full production filename will look like <STRONG>PRODAPPS20060306.dmp</STRONG> and is stored in the 
				<STRONG><u>/ora/archive/PRODAPPS/</u></STRONG> directory.
				A full development filename will look like <STRONG>devapps20060306.dmp</STRONG> and is stored in the <STRONG><u>/ora/archive/devapps/</u></STRONG> directory<BR /></LI>
<BR /><BR />
		<LI>		The fifth parameter, designated $5 in the script, is the specific <STRONG><EM>Oracle Schema Account name</EM></STRONG> detailed on the
				<A href="/#application.type#apps/istops/SchemaInfo.cfm">Schema Information page</A> and is <STRONG><EM>required</EM></STRONG>.
				This name must be entered in upper case.<BR /></LI>
<BR /><BR />
		<LI>		The sixth parameter, designated $6 in the script, is the <STRONG><EM>list of specific table or tables</EM></STRONG> to be imported for the specific Oracle Schema Account name
				specified in Parameter $5 (see ##5 above).
				This parameter is only required if Parameter $1 (see ##1 above) is set to "table". 
				Table names must be entered in uppercase.  
				Multiple table names are comma-separated with no spaces.<BR /></LI>
<BR /><BR />
		<LI>		The command lines, entered at the Linux TCSH or BASH shell prompt, look like:</LI>
<BR />
		<OL type="a">
				<LI>		Start the secure shell (ssh) software to create a telnet style session.<BR /></LI>
<BR />
				<LI>		Login  as user oracle.  (See Barry, Carol, John or Ron for current user account passwords.)<BR /></LI>
<BR />
				<LI>		<STRONG><EM>./oraimport user password PRODAPPS 20060306 LIBSHAREDDATAMGR [return].</EM></STRONG><BR /></LI>
				<EM><u>Or</u></EM><BR />
				<LI>		<STRONG><EM>./oraimport table password devapps 20060306 SPCOLMGR IDTYPES,SERVICES, STATUS [return].</EM></STRONG><BR /></LI>
<BR />
				<LI>		Log out of the secure shell (ssh) software by typing: <STRONG><EM>exit [return]</EM></STRONG> and closing the window.</LI>
		</OL>
	</OL>
</UL>

</cfoutput>

</BODY>
</HTML>
