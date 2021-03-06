<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: GandalfOracle.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/25/2008 --->
<!--- Date in Production: 02/25/2008 --->
<!--- Module: ORACLE SYSADMIN PROCEDURES FOR GANDALF.SDSU.EDU --->
<!-- Last modified by John R. Pastori on 02/25/2008 using ColdFusion Studio. -->

<CFOUTPUT>
<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/idtops/GandalfOracle.cfm">
<CFSET CONTENT_UPDATED = "February 25, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>ORACLE SYSADMIN PROCEDURES FOR GANDALF.SDSU.EDU</TITLE>
	<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</HEAD>

<BODY>
<DIV align="center"><H1>ORACLE SYSADMIN PROCEDURES FOR GANDALF.SDSU.EDU</H1></DIV>
<BR />
<P></P><H2><u>Overview</u></H2>
  &nbsp;&nbsp;&nbsp;&nbsp;The following procedures are used to support the Library&##8217;s Production/Development 
  Oracle server: GANDALF.SDSU.EDU. They are to be used by system administration personnel 
  who have root access to the server. Knowledge of the UNIX file structure is essential 
  to finding the appropriate directories and root access is required to view these 
  directories. There are two oracle instances, devapps for development and PRODAPPS 
  for production, running on the Gandalf server.<P></P>
<P>
  </P><H2><u>Procedure Descriptions</u></H2>
  &nbsp;&nbsp;&nbsp;&nbsp;The first two procedures start up and shut down Oracle using the Oracle system script. 
  The third procedure explains how to manually start and stop a specific Oracle Instance 
  using SQLPLUS. The fourth, fifth, and sixth procedures are run as scheduled UNIX 
  cron jobs. The fourth and fifth procedures create export/import files of development 
  and production data respectively. The sixth procedure cleans up oracle trace files 
  so only one month of files exists at a time. The seventh procedure restores the 
  Gandalf Firewall port parameter file from a backup copy. The eighth procedure describes 
  the command to check available disk space. The ninth procedure describes how to 
  recover from a catastrophic hardware crash.<P></P>
<P>
  </P><H2><u>Procedure Links</u></H2>
  &nbsp;&nbsp;&nbsp;&nbsp;Detailed information about each procedure is accessed by clicking the links below: 
<P></P>
<UL>
	<OL>
		<LI>Procedure 1: Oracle System Server software Start up (<A href="/#application.type#apps/idtops/OracleSysAdmProc1-2.html">S99zoracle start</A>).<BR /></LI>
<BR />
		<LI>Procedure 2: Oracle System Server software Shutdown (<A href="/#application.type#apps/idtops/OracleSysAdmProc1-2.html##PROC2">S99zoracle stop</A>).<BR /></LI>
<BR />
		<LI>Procedure 3: Individual Oracle Instance Manual Start up/Shutdown (<A href="/#application.type#apps/idtops/OracleSysAdmProc3.html">sqlplus</A>).<BR /></LI>
<BR />
		<LI>Procedure 4: Oracle Development Instance Export (<A href="/#application.type#apps/idtops/OracleSysAdmProc4.html">oradbbkup devapps</A>).<BR /></LI>
<BR />
		<LI>Procedure 5: Oracle Production Instance Export (<A href="/#application.type#apps/idtops/OracleSysAdmProc5.html">oradbbkup PRODAPPS</A>).<BR /></LI>
<BR />
		<LI>Procedure 6: Clean up archive and limit number of archive files (<A href="/#application.type#apps/idtops/OracleSysAdmProc6.html">purgearchivefiles</A>).<BR /></LI>
<BR />
		<LI>Procedure 7: <A href="/#application.type#apps/idtops/OracleSysAdmProc7-8.html">Restore Gandalf Firewall port parameter file</A> from backup copy.<BR /></LI>
<BR />
		<LI>Procedure 8: Check <A href="/#application.type#apps/idtops/OracleSysAdmProc7-8.html##PROC8">available disk space</A> on the Gandalf server.<BR /></LI>
<BR />
		<LI>Procedure 9: <A href="/#application.type#apps/idtops/OracleSysAdmProc9.cfm">Restore data</A> from export or rollback to recover from Oracle data file corruption.</LI>
	</OL>
</UL>
<BR />
<CFINCLUDE template="/include/coldfusion/footer.cfm">
</BODY></HTML></CFOUTPUT>


