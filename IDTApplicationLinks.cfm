<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: ISTApplicationLinks.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2011 --->
<!--- Date in Production: 06/23/2011 --->
<!--- Module: IDT Application Links --->
<!-- Last modified by John R. Pastori on 06/23/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "programsecuritycheck.cfm">

<CFOUTPUT>
	
     <CFSET SYSTEMACCESSFLAG = "">
	<cfquery name="ListIDTDatabaseSystems" DATASOURCE="#application.type#LIBSECURITY" BLOCKFACTOR="12">
          SELECT	DBSYSTEMID, DBSYSTEMNUMBER, DBSYSTEMNAME, DBSYSTEMDIRECTORY, DBSYSTEMGROUP
          FROM		DBSYSTEMS
          WHERE	DBSYSTEMID > 0 AND
          		DBSYSTEMGROUP = 'IDT'
          ORDER BY	DBSYSTEMNAME
     </cfquery>

	<tr>
		<th align="center" valign="top" colspan="2">
			<H2>IDT APPLICATIONS</H2>
		</th>
	</tr>
	<tr>
		<td align="CENTER" valign="top" colspan="2">
               <CFLOOP QUERY="ListIDTDatabaseSystems">
               
                    <CFSET SYSTEMACCESSFLAG = "Client.ACCESSING" & #UCase(ListIDTDatabaseSystems.DBSYSTEMDIRECTORY)#>
                    <CFIF LISTFIND(#Client.ValidatedSystems#, #ListIDTDatabaseSystems.DBSYSTEMNUMBER#) GT 0 AND #EVALUATE(SYSTEMACCESSFLAG)# EQ "NO">
                         <a href="/#application.type#apps/#ListIDTDatabaseSystems.DBSYSTEMDIRECTORY#/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES">#ListIDTDatabaseSystems.DBSYSTEMNAME#</a>&nbsp;&nbsp;
                    </CFIF>
                    
               </CFLOOP>
               <br /><b><a href="/#application.type#apps/index.cfm?logout=Yes">Log Out</a></b> <br /><br />
		</td>
	</tr>

</CFOUTPUT>