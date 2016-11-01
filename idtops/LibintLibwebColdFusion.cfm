<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: LibintLibwebColdFusion.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/25/2008 --->
<!--- Date in Production: 02/25/2008 --->
<!--- Module: COLDFUSION MX 7 SYSADMIN PROCEDURES FOR LIBINT.SDSU.EDU and LIBWEB.SDSU.EDU --->
<!-- Last modified by John R. Pastori on 02/25/2008 using ColdFusion Studio. -->

<CFOUTPUT>
<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/idtops/LibintLibwebColdFusion.cfm">
<CFSET CONTENT_UPDATED = "February 25, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
<TITLE>COLDFUSION MX 7 SYSADMIN PROCEDURES FOR LIBINT.SDSU.EDU and LIBWEB.SDSU.EDU</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</HEAD>

<BODY>
<DIV align="center"><H1>COLDFUSION MX 7 SYSADMIN PROCEDURES FOR <BR /> LIBINT.SDSU.EDU and LIBWEB.SDSU.EDU</H1></DIV>
<BR />
<P></P><H2><u>Overview</u></H2>
  &nbsp;&nbsp;&nbsp;&nbsp;The following procedures are used to support the Library&##8217;s Production/Development ColdFusion/Apache 
  Web server: LIBINT.SDSU.EDU.  This server supports the LFOLKS and LFOLKSTEST web sites.<BR />
  &nbsp;&nbsp;&nbsp;&nbsp;The same procedures are used for the Library&##8217;s Public Apache Web server: LIBWEB.SDSU.EDU.  This server supports the 
  INFODOME, DOMETEST and DOMESAND web sites.<BR />
  &nbsp;&nbsp;&nbsp;&nbsp;They are to be used by system administration personnel who have root access to the server.
  Knowledge of the UNIX file structure is essential to finding the appropriate directories and root access is required to view these directories.<BR />
<P></P>
<P>
  </P><H2><u>Procedure Descriptions</u></H2>
  &nbsp;&nbsp;&nbsp;&nbsp;The first two procedures start up and shut down the ColdFusion server using the ColdFusion jrun command.  
  The third and fourth procedures startup and shutdown the Apache Web Server software.
<P></P>
<P>
  </P><H2><u>Procedure Links</u></H2>
  &nbsp;&nbsp;&nbsp;&nbsp;Detailed information about each procedure is accessed by clicking the links below: 
<P></P>
<UL>
  <OL>
    <LI>Procedure 1: ColdFusion MX 7 Server software Start up (<A href="/#application.type#apps/idtops/ColdFusionSysAdmProc1-2.html">jrun -start cfusion</A>).<BR /></LI>
 
    <LI>Procedure 2: ColdFusion MX 7 Server software Shutdown (<A href="/#application.type#apps/idtops/ColdFusionSysAdmProc1-2.html##PROC2">jrun -stop cfusion</A>).<BR /></LI>
 
    <LI>Procedure 3: Apache Web Server software Start up (<A href="/#application.type#apps/idtops/ApacheSysAdmProc3-4.html">S50apache start</A>).<BR /></LI>

    <LI>Procedure 4: Apache Web Server software Shutdown (<A href="/#application.type#apps/idtops/ApacheSysAdmProc3-4.html##PROC4">S50apache stop</A>).<BR /></LI>
  </OL>
</UL>
<BR />
<CFINCLUDE template="/include/coldfusion/footer.cfm">
</cfoutput>
</BODY>
</HTML>
