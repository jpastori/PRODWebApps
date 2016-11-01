<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: bottom.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/28/2006 --->
<!--- Date in Production: 03/28/2006 --->
<!--- Module: Web Reports - Article Databases by Subject Infodome Web Page --->
<!-- Last modified by John R. Pastori on 03/28/2006 using ColdFusion Studio. -->

						<CFOUTPUT>
						<div align="center">
						<P>
						<font size="3">
						<A href="##top">
						Top of Document
						</A>
						|
						<A href="/DEVapps/webreports/index.cfm?logout=No">
						<!--- Infodome Home --->Web Reports Home</a>
						|
						<CFIF IsDefined('URL.PRINT')>
							<a href="https://#SERVER_NAME##DOCUMENT_URI# ">Web browser version</a>
 						<CFELSE>
							<img src="/images/printer.gif" alt="Printer Icon" align="absbottom">
							<a href="https://#SERVER_NAME##DOCUMENT_URI#?PRINT=YES">Printer-friendly version</a>
						</CFIF>
						</a></font>
						</p
						></div>
						<hr>

						<table align="center" width="500"> <!-- TABLE 6 (footer: credits, search, etc. . .) -->
							<tr> <!-- ROW 6,1 -->
								<!-- /CELL 6,1,1 -->
								<td align="center">
									<font face="Verdana,Arial,Helvetica" size="-2"> <!-- CELL 6,1,2 -->
									<a href="/search.shtml" class="navbar"><STRONG>Search This Site</STRONG></a></font></td> <!-- /CELL 6,1,2 -->
								<td align="center">
									<font face="Verdana,Arial,Helvetica" size="-2"> <!-- CELL 6,1,3 -->
									<a href="/feedback.shtml" class="navbar"><STRONG>Send Feedback</STRONG></a></font>
								</td>
								<td align="center">
									<font face="Verdana,Arial,Helvetica" size="-2"> <!-- CELL 6,1,5 -->
									<a href="http://www.sdsu.edu/" class="navbar">
									<img src="/images/sdsu_logo.gif" alt="" border="0"></a></font>
								</td> <!-- /CELL 6,1,5 -->
							</tr> <!-- /ROW 6,1 -->
						</table> <!-- /TABLE 6 -->


						<p>
							<font size="-1">
							This page <strong>https://#SERVER_NAME##DOCUMENT_URI# </strong> is maintained by #author_name#<strong>
							(<A href="mailto:#author_email#">#author_email#</a>).</strong><br>
							Please use our <A href="/feedback.shtml">Feedback Form</A> for your questions, comments, and suggestions.
						</P>
						<P>
							<i>File was last updated #content_updated# <i>
						</P>
						</CFOUTPUT>
					</td><!-- END COL1 ROW1 Content Table -->
				</tr><!-- END ROW1 Content Table -->
			</table><!-- END Content Table -->
<CFIF NOT IsDefined('URL.PRINT')>
		</td><!-- END COL3 ROW1 Master -->
	</tr><!-- END ROW 1 Master -->
</table><!-- END Master Table -->
</CFIF>
</BODY>
</HTML>
