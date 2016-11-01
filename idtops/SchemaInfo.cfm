<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: SchemaInfo.cfm--->
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
	<TITLE>Procedure 9:  Schema Information.</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>
<DIV ALIGN="center"><H1>Procedure 9:  Schema Information.</H1></DIV>
<BR />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The following 10 Oracle Schema Account names are used in the fifth parameter of the <A href="/#application.type#apps/istops/OracleImport.cfm">Oracle Import tcsh script</A>.
The order in which Oracle Schema Account names must be restored is:

<UL>
	<OL>
		<LI>		LIBSHAREDDATAMGR - The Library Shared Data Application contains data tables that support the other Applications.<BR /></LI>
<BR /><BR />
		<LI>		FACILITIESMGR - The Facilities Application is used by Bea to track facilities work orders.<BR />
				<STRONG><U>Note</U>:</STRONG>  (The Customer Table under LIBSHAREDDATAMGR will have to be dropped and reloaded after 
				all the FACILITIESMGR schema tables are loaded.)<BR /></LI>
<BR /><BR />
		<LI>		ISTPURCHASEMGR - The IST Purchasing Application is used by Carol Phillip's group to track purchase information about hardware and software.<BR /></LI>
<BR /><BR />
		<LI>		LIBSECURITYMGR - The Library Security Application provides tables to store the user security access information that determines the level
				of access each person is allowed to each application.<BR /></LI>
<BR /><BR />
		<LI>		ISTEQUIPMGR - The IST Equipment Inventory Application is used by Carol Phillip's Group to track the Library's current inventory of hardware
				and to whom each piece of equipment is assigned.<BR /></LI>
<BR /><BR />
		<LI>		ISTSOFTWMGR - The IST Software Inventory Application is used by Carol Phillip's Group to track the Library's current inventory of software
				and to whom each title is assigned.<BR />
				<STRONG><U>Note</U>:</STRONG>  (The Software Serial Numbers Table (SWSERIALNUMBERS) under ISTPURCHASEMGR will have to be dropped and reloaded after 
				all the ISTSOFTWMGR schema tables are loaded.)<BR /></LI>
<BR /><BR />
		<LI>		ISTSRMGR - The IST Service Request Application is used by Carol Phillip's Group and Mark Figueroa's Group to track IST service request work orders
				requested by Library Faculty and Staff.<BR /></LI>
<BR /><BR />
		<LI>		INSTRUCTIONMGR - The Instruction Application is used by the Library Faculty to track and generate statistics on the number of Instructional Orientations
				that have been presented.<BR /></LI>
<BR /><BR />
		<LI>		SPCOLMGR - The Special Collections Application is used by Special Collections to track researcher visits and their use of Special Collections materials.<BR /></LI>
<BR /><BR />
		<LI>		WEBRPTSMGR - The Web Reports Application contains information tables that support internal and public Library Web Reports for the Lfolks and Infodome websites.<BR /></LI>
<BR /><BR />
	</OL>
</UL>

</cfoutput>

</BODY>
</HTML>
