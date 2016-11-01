<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: idtchatterchangesreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/20/2013 --->
<!--- Date in Production: 11/20/2013 --->
<!--- Module: IDT Chatter Changes --->
<!-- Last modified by John R. Pastori on 11/20/2013 using ColdFusion Studio. -->

<CFOUTPUT>

<!--- 
*********************************************************************************
* The following code is the IDT Chatter Changes Generation and Display Process. *
*********************************************************************************
 --->
 

<CFSET BEGINMODIFIEDDATE = DateFormat(#NOW()# - 30, 'DD-MMM-YYYY')>
<CFSET ENDMODIFIEDDATE = DateFormat(#NOW()#, 'DD-MMM-YYYY')>
<!--- FROM BEGIN MODIFIED DATE = #BEGINMODIFIEDDATE# TO END MODIFIED DATE = #ENDMODIFIEDDATE#<BR><BR> --->

<CFQUERY name="LookupChatInfo" datasource="#application.type#IDTCHATTER">
	SELECT	ICI.CHATINFOID, ICI.CHATINFOTOPICID, ICT.TOPICID, ICT.TOPICINFO, ICI.CHATINFOSUBTOPICID, ICST.SUBTOPICID, 
			ICST.SUBTOPICINFO, ICI.CHATTER, ICI.ORIGINATORID, CUST.FULLNAME AS ORIGINNAME, ICI.MODIFIEDBYID, MODBY.FULLNAME AS MODBYNAME,
			ICI.MODIFIEDDATE, ICT.TOPICINFO || ' - ' || ICST.SUBTOPICINFO || ' - ' || ICI.CHATINFOID AS KEYFINDER
	FROM		IDTCHATTERINFO ICI, IDTCHATTOPICS ICT, IDTCHATSUBTOPICS ICST, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS MODBY
	WHERE	(ICI.CHATINFOID> 0 AND
			ICI.CHATINFOTOPICID = ICT.TOPICID  AND
			ICI.CHATINFOSUBTOPICID = ICST.SUBTOPICID AND
			ICI.ORIGINATORID = CUST.CUSTOMERID AND
			ICI.MODIFIEDBYID = MODBY.CUSTOMERID) AND
			(ICI.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY'))
	ORDER BY	KEYFINDER
</CFQUERY>

<CFIF #LookupChatInfo.RecordCount# EQ 0>

	<table width="100%" align="center" border="3">
          <tr align="center">
               <th align="center">
                    <h1>IDT Chatter: There have been NO changes in the last 30 days</h1>
                    <h2>From #DateFormat(BEGINMODIFIEDDATE, 'MM/DD/YYYY')# to #DateFormat(ENDMODIFIEDDATE, 'MM/DD/YYYY')#</h2>
               </th>
          </tr>
     </table>
     
<CFELSE>

     <table width="100%" align="center" border="3">
          <tr align="center">
               <th align="center">
                    <h1>IDT Chatter Changes in Previous 30 Days</h1>
                    <h2>From #DateFormat(BEGINMODIFIEDDATE, 'MM/DD/YYYY')# to #DateFormat(ENDMODIFIEDDATE, 'MM/DD/YYYY')#</h2>
               </th>
          </tr>
     </table>
     <br>
     <table align="left" border="0">
          <tr>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<td align="left"><input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /></td>
</CFFORM>
          </tr>
     </table>
     <br><br><br>
     <table align="left" border="0">
          <tr>
               <th align="CENTER" colspan="4">
                    <h2>#LookupChatInfo.RecordCount# IDT Chatter records were selected.</h2>
               </th>
          </tr>

	<CFSET FIRSTRECORD = "YES">
     <CFSET TOPICHEADER = "">
     <CFSET SUBTOPICHEADER = "">
          
     <CFLOOP query="LookupChatInfo">
     
		<CFIF #FIRSTRECORD# EQ "YES">
               <CFSET FIRSTRECORD = "NO">
               <CFSET TOPICHEADER = #LookupChatInfo.TOPICINFO#>
               <CFSET SUBTOPICHEADER = #LookupChatInfo.SUBTOPICINFO#>
          <tr>
               <td colspan="4"><hr width="100%" size="5" noshade /></td>
          </tr>
          </CFIF>
          <CFIF SUBTOPICHEADER NEQ #LookupChatInfo.SUBTOPICINFO# AND #FIRSTRECORD# EQ "NO">
               <CFSET SUBTOPICHEADER = #LookupChatInfo.SUBTOPICINFO#>
          <tr>
               <td colspan="4"><hr></td>
          </tr>
          </CFIF>
          <CFIF TOPICHEADER NEQ #LookupChatInfo.TOPICINFO# AND #FIRSTRECORD# EQ "NO">
               <CFSET TOPICHEADER = #LookupChatInfo.TOPICINFO#>
          <tr>
               <td colspan="4"><hr width="100%" size="5" noshade /></td>
          </tr>
          </CFIF>
          <tr>
               <th align="left" width="5%" nowrap>Topic:</th>
               <td align="LEFT" width="25%"><h5><strong>#LookupChatInfo.TOPICINFO#</strong></h5></td>
               <th align="left" width="5%" nowrap>Sub-Topic:</th>
               <td align="LEFT" width="25%"><h5><strong>#LookupChatInfo.SUBTOPICINFO#</strong></h5></td>
          </tr>
          <tr>
               <th align="LEFT" width="5%" nowrap><strong>Chat Key:</strong></th>
          <CFIF #CGI.HTTP_REFERER# EQ "https://lfolks.sdsu.edu/PRODapps/idtchatter/index.cfm">
               <td align="LEFT" width="25%">
               	<div><a href="/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=MODIFYDELETE&LOOKUPCHATID=FOUND&CHATINFOID=#LookupChatInfo.CHATINFOID#" target="_blank">#LookupChatInfo.CHATINFOID#</a></div>
               </td>
          <CFELSE>
          	<td align="LEFT" width="25%">
               	<div><a href="https://lfolks.sdsu.edu/PRODapps/idtchatter/idtchatterinfo.cfm?PROCESS=MODIFYDELETE&LOOKUPCHATID=FOUND&CHATINFOID=#LookupChatInfo.CHATINFOID#">#LookupChatInfo.CHATINFOID#</a></div>
               </td>
          </CFIF>
          	<th align="LEFT" width="5%" nowrap><strong>Modified Date:</strong></th>
               <td align="LEFT" width="25%"><div>#DateFormat(LookupChatInfo.MODIFIEDDATE, "MM/DD/YYYY")#</div></td>	
          </tr>
          <tr>
               <th align="LEFT" valign="TOP" width="5%" nowrap><strong>Chatter:</strong></th>
               <td align="LEFT" width="25%" colspan="4"><div>#LEFT(LookupChatInfo.CHATTER, 150)#</div></td>
          </tr>
     </CFLOOP>
          <tr>
               <td align="LEFT" colspan="4"><hr width="100%" size="5" noshade /></td>
          </tr>
          <tr>
               <th align="CENTER" width="60%" colspan="4">
                    <h2>#LookupChatInfo.RecordCount# IDT Chatter records were selected.</h2>
               </th>
          </tr>
     </table>
     <br>
     <table align="left" border="0">
          <tr>
     <CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
                    <td align="left" width="60%" colspan="4"><input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /></td>
     </CFFORM>
          </tr>
          <tr>
               <td align="left" width="60%" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
          </tr>
     </table>
 
</CFIF>
 
</CFOUTPUT>