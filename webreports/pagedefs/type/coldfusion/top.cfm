<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: top.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/28/2006 --->
<!--- Date in Production: 03/28/2006 --->
<!--- Module: Web Reports - Article Databases by Subject Infodome Web Page --->
<!-- Last modified by John R. Pastori on 03/28/2006 using ColdFusion Studio. -->

	<MAP name="header_map">
		<AREA shape="rect" coords="1,3,627,52" href="index.cfm?logout=No">
	</MAP>

</HEAD>

<BODY topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<A NAME="##top"></A>
<CFIF NOT IsDefined('URL.PRINT')>
<table cellspacing="0" cellpadding="0" border="0" width="800" valign="top">
	<TR>
		<TD colspan="1" valign="bottom" nowrap>
			<IMG alt="" vspace="0" align="left" hspace="0" src="/images/header1_169x54.gif">
		</TD>
		<!-- this is where we want our image map (hdrtext2.gif) -->
		<TD colspan="2" align="left">
			<IMG usemap="#header_map" border="0" vspace="0" align="left" hspace="0" src="/images/hdrtext2.gif" alt="">
		</TD>
	</TR>
	<tr><!-- 1st ROW Master Table -->
		<!-- Primary left-side menu --> 
		<!-- added 6/22 zb -->
		<TD width="169" valign="top">
		<!-- 1st CELL Master Table -->
			<!-- START Nav Links Table -->

			<TABLE cellpadding="0" cellspacing="0" width="100%" VALIGN="top" border="0" >
				<TR><!-- 1st ROW Nav Links -->
				    <!-- center left-side menu cell -->
					<TD valign="top" class="navgradient"><!-- 1st CELL Nav Links --> <!-- *** class="navlinks" added by BLF on 8/2 *** -->
						<CFINCLUDE TEMPLATE="navbar.cfm">
					</TD><!-- END COL1 ROW1 Nav Links -->
				</TR><!-- END ROW1 Nav Links-->
				<TR><!-- ROW2 Nav Links -->
					<TD><!-- COL1 ROW2 Nav Links -->
						&nbsp;&nbsp;<!--- <CFINCLUDE TEMPLATE="navbottom.html"> --->
					</TD><!-- END COL1 ROW2 Nav Links -->
				</TR><!-- END ROW2 Nav Links-->
			</TABLE><!-- END Nav Links Table -->

		</TD><!-- END COL1 ROW1 Master -->		

		<!-- Vertical Stripe (COL2 ROW1 Master) -->
		<TD bgcolor="#8800FF" width="0">&nbsp;</TD>
		<td valign="top" align="left"><!-- START COL3 ROW1 Master -->
			<!-- START Content Table -->
</CFIF>
			<table cellspacing="0" cellpadding="15" border="0" width="95%" valign="top">
				<TR><!-- ROW1 Content Table -->
					<TD valign="top" class="background"><!-- COL1 ROW1 Content Table -->
						<CENTER><P>
					<CFOUTPUT>
					<CFIF FIND('articledbbysubject.cfm', #DOCUMENT_URI#, 1) NEQ 0>
						<H1>#ListSubjectCategories.SUBJECTCATNAME# Periodical Indexes and Databases</H1>
					<CFELSEIF FIND('fulltext.cfm', #DOCUMENT_URI#, 1) NEQ 0>
						<H1>Fulltext Databases and Electronic Journals Publishers</H1>
					<CFELSE>
						<H1>Article Databases</H1>
					</CFIF>
					</CFOUTPUT>
						</P></CENTER>
						<DIV class="seealso">
						<STRONG>Databases are available to anybody from within the library building. 
						Remote access is available to SDSU users only unless otherwise noted.</STRONG></DIV>
						<BR><BR>

						<TABLE>
							<TR>
								<TD nowrap valign="top"><DIV class="seealso">See also:  </DIV></TD>
								<TD><DIV class="seealso">
									<A href="http://sfx.calstate.edu:3023/sdsu/cgi/core/citation-linker.cgi">Citation Linker</A> |
									<A href="/research/guides/dbcomp.shtml">Database Search Features</A> | 
									<A href="/research/databases/licagr.shtml">License agreements</A> | 
									<A href="/research/access.shtml">Remote access to databases</A> | 
									<A href="/research/ejournals/sfx/help.html">
									<IMG src="/images/sfx_swish.gif" alt="sfx enabled database" border="0">What does the 'Find Full Text' button mean?</A>
									</DIV>
								</TD>
							</TR>
						</TABLE>

<BR>
