<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: LibraryApplicationLinks.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/27/2011 --->
<!--- Date in Production: 06/27/2011 --->
<!--- Module: Library Application Links --->
<!-- Last modified by John R. Pastori on 06/27/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "programsecuritycheck.cfm">

<CFOUTPUT>
	
     <CFSET SYSTEMACCESSFLAG = "">
	<cfquery name="ListLIBDatabaseSystems" DATASOURCE="#application.type#LIBSECURITY" BLOCKFACTOR="12">
          SELECT	DBSYSTEMID, DBSYSTEMNUMBER, DBSYSTEMNAME, DBSYSTEMDIRECTORY, DBSYSTEMGROUP
          FROM		DBSYSTEMS
          WHERE	DBSYSTEMID > 0 AND
          		DBSYSTEMGROUP = 'LIB'
          ORDER BY	DBSYSTEMNAME
     </cfquery>

<tr>
		<th align="CENTER" valign="top" colspan="2">
			<H2>LIBRARY APPLICATIONS</H2>
		</th>
	</tr>
	<tr>
		<td align="CENTER" valign="top" colspan="2">
               <CFLOOP QUERY="ListLIBDatabaseSystems">
               
                    <CFSET SYSTEMACCESSFLAG = "Client.ACCESSING" & #UCase(ListLIBDatabaseSystems.DBSYSTEMDIRECTORY)#>
                    <CFIF LISTFIND(#Client.ValidatedSystems#, #ListLIBDatabaseSystems.DBSYSTEMNUMBER#) GT 0 AND #EVALUATE(SYSTEMACCESSFLAG)# EQ "NO">
                         <a href="/#application.type#apps/#ListLIBDatabaseSystems.DBSYSTEMDIRECTORY#/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES">#ListLIBDatabaseSystems.DBSYSTEMNAME#</a>&nbsp;&nbsp;
                    </CFIF>
                    
               </CFLOOP>
               <br /><b><a href="/#application.type#apps/index.cfm?logout=Yes">Log Out</a></b> <br /><br />
		</td>
	</tr>

</CFOUTPUT>