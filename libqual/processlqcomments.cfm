<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processlqcomments.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to LibQual - Check LibQual Comment Criteria --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to LibQual - Check LibQual Comment Criteria</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<IMG src="/images/bigheader.jpg" width="279" height="63" alt="LFOLKS Intranet Web Site" border="0" />
<BR /><BR /><BR /><BR /><BR />

<CFIF FORM.PROCESSCOMMENTS EQ "MODIFY">

	<CFQUERY name="ModifyLibqual_Comments" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET		COMMENTS = '#FORM.COMMENTS#',
			<CFIF IsDefined('FORM.BUDGET')>
				BUDGET = '#FORM.BUDGET#',
			<CFELSE>
				BUDGET = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.RPT_CONFUSION')>
				RPT_CONFUSION = '#FORM.RPT_CONFUSION#',
			<CFELSE>
				RPT_CONFUSION = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.RPT_NEGATIVE')>
				RPT_NEGATIVE = '#FORM.RPT_NEGATIVE#',
			<CFELSE>
				RPT_NEGATIVE = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.RPT_POSITIVE')>
				RPT_POSITIVE = '#FORM.RPT_POSITIVE#',
			<CFELSE>
				RPT_POSITIVE = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.RPT_CONFUSION') OR IsDefined('FORM.RPT_NEGATIVE') OR IsDefined('FORM.RPT_POSITIVE')> 
				REPORTGROUP = 'YES',
			</CFIF>
				CHECKEDBYID = #val(FORM.CHECKEDBYID)#,
				RECCHECKED = 'YES'
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<H1>LIBQUAL Comments MODIFIED!</H1>
	<CFIF FIND('lqcommcriteriacheck.cfm', #CGI.HTTP_REFERER#, 1) NEQ 0>
		<CFIF client.LQCRecordCounter EQ ARRAYLEN(session.CommentIDArray)>
			<H1>All Selected Records Processed!</H1>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/index.cfm" />
			<CFEXIT>
		<CFELSE>
			<H1>Process Next Record</H1>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/lqcommcriteriacheck.cfm" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/lqcommcriteria.cfm" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCOMMENTS EQ "BUILDING">

	<CFQUERY name="ModifyLibqual_BLDGComments" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF IsDefined('FORM.BLD_ACCESSIBILITY')>
				BLD_ACCESSIBILITY = '#FORM.BLD_ACCESSIBILITY#',
			<CFELSE>
				BLD_ACCESSIBILITY = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_CLEANMAINT')>
				BLD_CLEANMAINT = '#FORM.BLD_CLEANMAINT#',
			<CFELSE>
				BLD_CLEANMAINT = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_ELECTOUTLETS')>
				BLD_ELECTOUTLETS = '#FORM.BLD_ELECTOUTLETS#',
			<CFELSE>
				BLD_ELECTOUTLETS = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_FURNITURE')>
				BLD_FURNITURE = '#FORM.BLD_FURNITURE#',
			<CFELSE>
				BLD_FURNITURE = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_GROUPSTUDY')>
				BLD_GROUPSTUDY = '#FORM.BLD_GROUPSTUDY#',
			<CFELSE>
				BLD_GROUPSTUDY = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_HEATCOOL')>
				BLD_HEATCOOL = '#FORM.BLD_HEATCOOL#',
			<CFELSE>
				BLD_HEATCOOL = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_HOURS')>
				BLD_HOURS = '#FORM.BLD_HOURS#',
			<CFELSE>
				BLD_HOURS = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_LIGHTING')>
				BLD_LIGHTING = '#FORM.BLD_LIGHTING#',
			<CFELSE>
				BLD_LIGHTING = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_QUIETSPACE')>
				BLD_QUIETSPACE = '#FORM.BLD_QUIETSPACE#',
			<CFELSE>
				BLD_QUIETSPACE = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_RESTROOMS')>
				BLD_RESTROOMS = '#FORM.BLD_RESTROOMS#',
			<CFELSE>
				BLD_RESTROOMS = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_SAFETY')>
				BLD_SAFETY = '#FORM.BLD_SAFETY#',
			<CFELSE>
				BLD_SAFETY = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_SIGNAGE')>
				BLD_SIGNAGE = '#FORM.BLD_SIGNAGE#',
			<CFELSE>
				BLD_SIGNAGE = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.BLD_STUDYSPACE')>
				BLD_STUDYSPACE = '#FORM.BLD_STUDYSPACE#',
			<CFELSE>
				BLD_STUDYSPACE = 'No',
			</CFIF>
				RECCHECKED = 'YES'
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>
	
	<CFQUERY name="CheckBuildingGroup" datasource="#application.type#LIBQUAL">
		SELECT	LQC.COMMENTID, LQC.BLD_ACCESSIBILITY, LQC.BLD_CLEANMAINT, LQC.BLD_ELECTOUTLETS, LQC.BLD_FURNITURE,
				LQC.BLD_GROUPSTUDY, LQC.BLD_HEATCOOL, LQC.BLD_HOURS, LQC.BLD_LIGHTING, LQC.BLD_QUIETSPACE, LQC.BLD_RESTROOMS,
				LQC.BLD_SAFETY, LQC.BLD_SIGNAGE, LQC.BLD_STUDYSPACE
		FROM		LIBQUAL_COMMENTS LQC
		WHERE 	COMMENTID = <CFQUERYPARAM value="#FORM.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	LQC.COMMENTID
	</CFQUERY>

	<CFQUERY name="ModifyLibqual_BLDGroup" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF CheckBuildingGroup.BLD_ACCESSIBILITY EQ 'No' AND CheckBuildingGroup.BLD_CLEANMAINT EQ 'No' 
			  AND CheckBuildingGroup.BLD_ELECTOUTLETS  EQ 'No' AND CheckBuildingGroup.BLD_FURNITURE  EQ 'No' 
			  AND CheckBuildingGroup.BLD_GROUPSTUDY    EQ 'No' AND CheckBuildingGroup.BLD_HEATCOOL   EQ 'No' 
			  AND CheckBuildingGroup.BLD_HOURS         EQ 'No' AND CheckBuildingGroup.BLD_LIGHTING   EQ 'No' 
			  AND CheckBuildingGroup.BLD_QUIETSPACE    EQ 'No' AND CheckBuildingGroup.BLD_RESTROOMS  EQ 'No' 
			  AND CheckBuildingGroup.BLD_SAFETY        EQ 'No' AND CheckBuildingGroup.BLD_SIGNAGE    EQ 'No' 
			  AND CheckBuildingGroup.BLD_STUDYSPACE    EQ 'No'>
				BUILDINGGROUP = 'No'
			<CFELSE>
				BUILDINGGROUP = 'YES'
			</CFIF>
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<H1>LIBQUAL Comments MODIFIED!</H1>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("LIBQUAL Comments MODIFIED!");
			window.close();
		 -->
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFIF FORM.PROCESSCOMMENTS EQ "COLLECTIONS">

	<CFQUERY name="ModifyLibqual_COLLComments" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF IsDefined('FORM.COL_MAINT')>
				COL_MAINT = '#FORM.COL_MAINT#',
			<CFELSE>
				COL_MAINT = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.COL_ONLINE')>
				COL_ONLINE = '#FORM.COL_ONLINE#',
			<CFELSE>
				COL_ONLINE = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.COL_PERIODICALS')>
				COL_PERIODICALS = '#FORM.COL_PERIODICALS#',
			<CFELSE>
				COL_PERIODICALS = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.COL_PRINT')>
				COL_PRINT = '#FORM.COL_PRINT#',
			<CFELSE>
				COL_PRINT = 'No',
			</CFIF>
				RECCHECKED = 'YES'
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<CFQUERY name="CheckCollectionsGroup" datasource="#application.type#LIBQUAL">
		SELECT	LQC.COMMENTID, LQC.COL_MAINT, LQC.COL_ONLINE, LQC.COL_PERIODICALS, LQC.COL_PRINT
		FROM		LIBQUAL_COMMENTS LQC
		WHERE 	COMMENTID = <CFQUERYPARAM value="#FORM.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	LQC.COMMENTID
	</CFQUERY>

	<CFQUERY name="ModifyLibqual_COLGroup" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF CheckCollectionsGroup.COL_MAINT       EQ 'No' AND CheckCollectionsGroup.COL_ONLINE EQ 'No' 
			  AND CheckCollectionsGroup.COL_PERIODICALS EQ 'No' AND CheckCollectionsGroup.COL_PRINT  EQ 'No'>
				COLLECTIONSGROUP = 'No'
			<CFELSE>
				COLLECTIONSGROUP = 'YES'
			</CFIF>
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<H1>LIBQUAL Comments MODIFIED!</H1>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("LIBQUAL Comments MODIFIED!");
			window.close();
		 -->
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFIF FORM.PROCESSCOMMENTS EQ "POLICIES">

	<CFQUERY name="ModifyLibqual_POLComments" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF IsDefined('FORM.POL_CELLPHONES')>
				POL_CELLPHONES = '#FORM.POL_CELLPHONES#',
			<CFELSE>
				POL_CELLPHONES = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.POL_EATDRINK')>
				POL_EATDRINK = '#FORM.POL_EATDRINK#',
			<CFELSE>
				POL_EATDRINK = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.POL_FINES')>
				POL_FINES = '#FORM.POL_FINES#',
			<CFELSE>
				POL_FINES = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.POL_GENERAL')>
				POL_GENERAL = '#FORM.POL_GENERAL#',
			<CFELSE>
				POL_GENERAL = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.POL_NOISE')>
				POL_NOISE = '#FORM.POL_NOISE#',
			<CFELSE>
				POL_NOISE = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.POL_SLEEPING')>
				POL_SLEEPING = '#FORM.POL_SLEEPING#',
			<CFELSE>
				POL_SLEEPING = 'No',
			</CFIF>
				RECCHECKED = 'YES'
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<CFQUERY name="CheckPoliciesGroup" datasource="#application.type#LIBQUAL">
		SELECT	LQC.COMMENTID, LQC.POL_CELLPHONES, LQC.POL_EATDRINK, LQC.POL_FINES, LQC.POL_GENERAL,
				LQC.POL_NOISE, LQC.POL_SLEEPING
		FROM		LIBQUAL_COMMENTS LQC
		WHERE 	COMMENTID = <CFQUERYPARAM value="#FORM.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	LQC.COMMENTID
	</CFQUERY>

	<CFQUERY name="ModifyLibqual_POLGroup" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF CheckPoliciesGroup.POL_CELLPHONES EQ 'No' AND CheckPoliciesGroup.POL_EATDRINK EQ 'No' 
			  AND CheckPoliciesGroup.POL_FINES      EQ 'No' AND CheckPoliciesGroup.POL_GENERAL  EQ 'No' 
			  AND CheckPoliciesGroup.POL_NOISE      EQ 'No' AND CheckPoliciesGroup.POL_SLEEPING EQ 'No'>
				POLICIESGROUP = 'No'
			<CFELSE>
				POLICIESGROUP = 'YES'
			</CFIF>
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<H1>LIBQUAL Comments MODIFIED!</H1>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("LIBQUAL Comments MODIFIED!");
			window.close();
		 -->
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFIF FORM.PROCESSCOMMENTS EQ "SERVICE">

	<CFQUERY name="ModifyLibqual_SRVComments" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF IsDefined('FORM.SRV_CIRCUIT')>
				SRV_CIRCUIT = '#FORM.SRV_CIRCUIT#',
			<CFELSE>
				SRV_CIRCUIT = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_CIRCDESK')>
				SRV_CIRCDESK = '#FORM.SRV_CIRCDESK#',
			<CFELSE>
				SRV_CIRCDESK = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_COPYSRVCS')>
				SRV_COPYSRVCS = '#FORM.SRV_COPYSRVCS#',
			<CFELSE>
				SRV_COPYSRVCS = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_ECR')>
				SRV_ECR = '#FORM.SRV_ECR#',
			<CFELSE>
				SRV_ECR = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_ELECTRONICREF')>
				SRV_ELECTRONICREF = '#FORM.SRV_ELECTRONICREF#',
			<CFELSE>
				SRV_ELECTRONICREF = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_GOVTPUBS')>
				SRV_GOVTPUBS = '#FORM.SRV_GOVTPUBS#',
			<CFELSE>
				SRV_GOVTPUBS = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_HOURS')>
				SRV_HOURS = '#FORM.SRV_HOURS#',
			<CFELSE>
				SRV_HOURS = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_INSTREDOR')>
				SRV_INSTREDOR = '#FORM.SRV_INSTREDOR#',
			<CFELSE>
				SRV_INSTREDOR = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_ILL')>
				SRV_ILL = '#FORM.SRV_ILL#',
			<CFELSE>
				SRV_ILL = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_LIBRINTERACT')>
				SRV_LIBRINTERACT = '#FORM.SRV_LIBRINTERACT#',
			<CFELSE>
				SRV_LIBRINTERACT = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_LINKPLUS')>
				SRV_LINKPLUS = '#FORM.SRV_LINKPLUS#',
			<CFELSE>
				SRV_LINKPLUS = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_MEDIACNTR')>
				SRV_MEDIACNTR = '#FORM.SRV_MEDIACNTR#',
			<CFELSE>
				SRV_MEDIACNTR = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_CPMC')>
				SRV_CPMC = '#FORM.SRV_CPMC#',
			<CFELSE>
				SRV_CPMC = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_REFDESK')>
				SRV_REFDESK = '#FORM.SRV_REFDESK#',
			<CFELSE>
				SRV_REFDESK = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_RBR')>
				SRV_RBR = '#FORM.SRV_RBR#',
			<CFELSE>
				SRV_RBR = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_SCC')>
				SRV_SCC = '#FORM.SRV_SCC#',
			<CFELSE>
				SRV_SCC = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_SPCOLL')>
				SRV_SPCOLL = '#FORM.SRV_SPCOLL#',
			<CFELSE>
				SRV_SPCOLL = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_STAFFINTERACT')>
				SRV_STAFFINTERACT = '#FORM.SRV_STAFFINTERACT#',
			<CFELSE>
				SRV_STAFFINTERACT = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_STUDNTINTERACT')>
				SRV_STUDNTINTERACT = '#FORM.SRV_STUDNTINTERACT#',
			<CFELSE>
				SRV_STUDNTINTERACT = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_TELEPHONE')>
				SRV_TELEPHONE = '#FORM.SRV_TELEPHONE#',
			<CFELSE>
				SRV_TELEPHONE = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.SRV_WEBOPACSRVC')>
				SRV_WEBOPACSRVC = '#FORM.SRV_WEBOPACSRVC#',
			<CFELSE>
				SRV_WEBOPACSRVC = 'No',
			</CFIF>
				RECCHECKED = 'YES'
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<CFQUERY name="CheckServiceGroup" datasource="#application.type#LIBQUAL">
		SELECT	LQC.COMMENTID, LQC.SRV_CIRCUIT, LQC.SRV_CIRCDESK, LQC.SRV_COPYSRVCS, LQC.SRV_ECR, LQC.SRV_ELECTRONICREF,
				LQC.SRV_GOVTPUBS, LQC.SRV_HOURS,LQC.SRV_INSTREDOR, LQC.SRV_ILL, LQC.SRV_LIBRINTERACT, LQC.SRV_LINKPLUS,
				LQC.SRV_MEDIACNTR,LQC.SRV_CPMC, LQC.SRV_REFDESK, LQC.SRV_RBR, LQC.SRV_SCC, LQC.SRV_SPCOLL, LQC.SRV_STAFFINTERACT,
				LQC.SRV_STUDNTINTERACT, LQC.SRV_TELEPHONE, LQC.SRV_WEBOPACSRVC
		FROM		LIBQUAL_COMMENTS LQC
		WHERE 	COMMENTID = <CFQUERYPARAM value="#FORM.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	LQC.COMMENTID
	</CFQUERY>

	<CFQUERY name="ModifyLibqual_SRVGroup" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF CheckServiceGroup.SRV_CIRCUIT        EQ 'No' AND CheckServiceGroup.SRV_CIRCDESK      EQ 'No'
			  AND CheckServiceGroup.SRV_COPYSRVCS      EQ 'No' AND CheckServiceGroup.SRV_ECR           EQ 'No'
			  AND CheckServiceGroup.SRV_ELECTRONICREF  EQ 'No' AND CheckServiceGroup.SRV_GOVTPUBS      EQ 'No'
			  AND CheckServiceGroup.SRV_HOURS          EQ 'No' AND CheckServiceGroup.SRV_INSTREDOR     EQ 'No'
			  AND CheckServiceGroup.SRV_ILL            EQ 'No' AND CheckServiceGroup.SRV_LIBRINTERACT  EQ 'No'
			  AND CheckServiceGroup.SRV_LINKPLUS       EQ 'No' AND CheckServiceGroup.SRV_MEDIACNTR     EQ 'No'
			  AND CheckServiceGroup.SRV_CPMC           EQ 'No' AND CheckServiceGroup.SRV_REFDESK       EQ 'No'
			  AND CheckServiceGroup.SRV_RBR            EQ 'No' AND CheckServiceGroup.SRV_SCC           EQ 'No'
			  AND CheckServiceGroup.SRV_SPCOLL         EQ 'No' AND CheckServiceGroup.SRV_STAFFINTERACT EQ 'No'
			  AND CheckServiceGroup.SRV_STUDNTINTERACT EQ 'No' AND CheckServiceGroup.SRV_TELEPHONE     EQ 'No'
			  AND CheckServiceGroup.SRV_WEBOPACSRVC    EQ 'No'>
				SERVICEGROUP = 'No'
			<CFELSE>
				SERVICEGROUP = 'YES'
			</CFIF>
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<H1>LIBQUAL Comments MODIFIED!</H1>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("LIBQUAL Comments MODIFIED!");
			window.close();
		 -->
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFIF FORM.PROCESSCOMMENTS EQ "TECHNOLOGY">

	<CFQUERY name="ModifyLibqual_TECHComments" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF IsDefined('FORM.TECH_COMPTECHGENRL')>
				TECH_COMPTECHGENRL = '#FORM.TECH_COMPTECHGENRL#',
			<CFELSE>
				TECH_COMPTECHGENRL = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.TECH_OTHERHW')>
				TECH_OTHERHW = '#FORM.TECH_OTHERHW#',
			<CFELSE>
				TECH_OTHERHW = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.TECH_OTHERLIBCOMP')>
				TECH_OTHERLIBCOMP = '#FORM.TECH_OTHERLIBCOMP#',
			<CFELSE>
				TECH_OTHERLIBCOMP = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.TECH_PERCOMPLAB')>
				TECH_PERCOMPLAB = '#FORM.TECH_PERCOMPLAB#',
			<CFELSE>
				TECH_PERCOMPLAB = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.TECH_PRINTING')>
				TECH_PRINTING = '#FORM.TECH_PRINTING#',
			<CFELSE>
				TECH_PRINTING = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.TECH_REFCOMPLAB')>
				TECH_REFCOMPLAB = '#FORM.TECH_REFCOMPLAB#',
			<CFELSE>
				TECH_REFCOMPLAB = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.TECH_REMOTEACCESS')>
				TECH_REMOTEACCESS = '#FORM.TECH_REMOTEACCESS#',
			<CFELSE>
				TECH_REMOTEACCESS = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.TECH_RBRLAB')>
				TECH_RBRLAB = '#FORM.TECH_RBRLAB#',
			<CFELSE>
				TECH_RBRLAB = 'No',
			</CFIF>
			<CFIF IsDefined('FORM.TECH_SCCLAB')>
				TECH_SCCLAB = '#FORM.TECH_SCCLAB#',
			<CFELSE>
				TECH_SCCLAB = 'No',
			</CFIF>
				RECCHECKED = 'YES'
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<CFQUERY name="CheckTechnologyGroup" datasource="#application.type#LIBQUAL">
		SELECT	LQC.COMMENTID, LQC.TECH_COMPTECHGENRL, LQC.TECH_OTHERHW, LQC.TECH_OTHERLIBCOMP,
				LQC.TECH_PERCOMPLAB, LQC.TECH_PRINTING, LQC.TECH_REFCOMPLAB, LQC.TECH_REMOTEACCESS,
				LQC.TECH_RBRLAB, LQC.TECH_SCCLAB
		FROM		LIBQUAL_COMMENTS LQC
		WHERE 	COMMENTID = <CFQUERYPARAM value="#FORM.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	LQC.COMMENTID
	</CFQUERY>

	<CFQUERY name="ModifyLibqual_TECHGroup" datasource="#application.type#LIBQUAL">
		UPDATE	LIBQUAL_COMMENTS
		SET
			<CFIF CheckTechnologyGroup.TECH_COMPTECHGENRL EQ 'No' AND CheckTechnologyGroup.TECH_OTHERHW    EQ 'No' 
			  AND CheckTechnologyGroup.TECH_OTHERLIBCOMP  EQ 'No' AND CheckTechnologyGroup.TECH_PERCOMPLAB EQ 'No' 
			  AND CheckTechnologyGroup.TECH_PRINTING      EQ 'No' AND CheckTechnologyGroup.TECH_REFCOMPLAB EQ 'No' 
			  AND CheckTechnologyGroup.TECH_REMOTEACCESS  EQ 'No' AND CheckTechnologyGroup.TECH_RBRLAB     EQ 'No' 
			  AND CheckTechnologyGroup.TECH_SCCLAB        EQ 'No'>
				TECHNOLOGYGROUP = 'No'
			<CFELSE>
				TECHNOLOGYGROUP = 'YES'
			</CFIF>
		WHERE 	COMMENTID = #val(FORM.COMMENTID)#
	</CFQUERY>

	<H1>LIBQUAL Comments MODIFIED!</H1>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("LIBQUAL Comments MODIFIED!");
			window.close();
		 -->
	</SCRIPT>
	<CFEXIT>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>