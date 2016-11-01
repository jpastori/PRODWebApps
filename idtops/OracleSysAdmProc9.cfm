<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: OracleSysAdmProc9.cfm--->
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
	<TITLE>Procedure 9: Restore data from export or rollback to recover from Oracle data file corruption.</TITLE>
</HEAD>

<BODY>
<DIV align="center"><H1>Procedure 9: Restore data from export or rollback to recover<BR /> from Oracle data file corruption.</H1></DIV>
<BR />
<P></P><H2><U>Overview</U></H2>
&nbsp;&nbsp;&nbsp;&nbsp;Two restore options have been developed to recreate corrupted oracle tables with clean data.  

&nbsp;&nbsp;&nbsp;&nbsp;The two restore options currently available are: 
<UL>
	<OL>
		<LI> Use Oracle Import tcsh script (<STRONG><EM>/oracle/oracle102gserver/dbexports/oraimport</EM></STRONG>) to import all of a specific user's tables
			or a specific table for a specific user.  The users and tables need to imported in a specific order so that foreign index links
			are copied properly when the table data is imported.  The list of Oracle Schema user names and table names can be accessed by going to the 
			THORIN Windows 2003 Server for the <A href="http://thorin.sdsu.edu/OracleDBA/tabledefs.html"> table definitions </A> of all the applications.<BR /></LI>
<BR /><BR />
		<LI> Use Oracle's rollback feature that allows you to reset the contents of a table to a specific time and date.</LI>
	</OL>
</UL>
<BR /><BR />
<P>
  </P><H2><U>Detailed Description</U></H2>

<UL>
	<OL>
		<LI>The <A href="/#application.type#apps/istops/SchemaInfo.cfm">Schema Information page</A> details the order in which Oracle Schema Account names must be restored and briefly describes each Application..<BR /></LI>
<BR /><BR />
		<LI>The <A href="/#application.type#apps/istops/OracleImport.cfm">Oracle Import tcsh script parameters page</A> details how to use the oraimport script parameters to control data import selection..<BR /></LI>
<BR /><BR />
		<LI>The <A href="/#application.type#apps/istops/OracleDBRecoveryCommands.html">Oracle Database Recovery Feature page</A> details how to use the Oracle Alter Table Recovery command to return a table to a specific point in time.<BR /></LI>
	</OL>
</UL>
<BR />
</cfoutput>

</BODY>
</HTML>
