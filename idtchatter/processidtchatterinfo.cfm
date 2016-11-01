<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processidtchatterinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/07/2011 --->
<!--- Date in Production: 11/07/2011 --->
<!--- Module: Process Information to IDT Chatter --->
<!-- Last modified by John R. Pastori on 11/07/2011 using ColdFusion Studio. -->

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Chatter </TITLE>
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFSET ChatSeeAllKeys = 0>

<CFIF FORM.PROCESSIDTCHATTER EQ "ADD" OR FORM.PROCESSIDTCHATTER EQ "MODIFY">

	<CFTRANSACTION action="begin">
	<CFQUERY name="UpdateChatInfo" datasource="#application.type#IDTCHATTER">
		UPDATE	IDTCHATTERINFO
		SET		CHATINFOTOPICID = #val(FORM.CHATINFOTOPICID)#, 
                    CHATINFOSUBTOPICID = #val(FORM.CHATINFOSUBTOPICID)#, 
                    CHATTER = UPPER('#FORM.CHATTER#'),
               <CFIF IsDefined('FORM.ORIGINATORID')>
               	ORIGINATORID =#val(FORM.ORIGINATORID)#,
               </CFIF>
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#MODIFIEDDATE#', 'DD-MON-YYYY')
		WHERE	CHATINFOID = #val(Cookie.CHATINFOID)#
	</CFQUERY>
     <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
	
     <CFQUERY name="LookupChatSeeAll" datasource="#application.type#IDTCHATTER"  blockfactor="100">
          SELECT	SEEALSOID, CHATINFOID, CHATSEEALSOINFO
          FROM		CHATSEEALSO
          WHERE	CHATINFOID = #val(Cookie.CHATINFOID)#
     </CFQUERY>
          
	<CFIF LookupChatSeeAll.Recordcount GT 0>
		<CFSET ChatSeeAllKeys = #ValueList(LookupChatSeeAll.SEEALSOID)#>
          <STRONG>Chat See All Keys</STRONG> = #ValueList(LookupChatSeeAll.SEEALSOID)#
     </CFIF>
     
     <CFIF IsDefined('FORM.CHATSEEALSOINFO1') AND #FORM.CHATSEEALSOINFO1# NEQ ''>
		<CFIF LookupChatSeeAll.Recordcount EQ 0>

               <CFQUERY name="GetMaxUniqueID" datasource="#application.type#IDTCHATTER">
                    SELECT	MAX(SEEALSOID) AS MAX_ID
                    FROM		CHATSEEALSO
               </CFQUERY>

               <CFSET FORM.SEEALSOID1 = #val(GetMaxUniqueID.MAX_ID+1)#>
               <CFQUERY name="AddSeeAlso1" datasource="#application.type#IDTCHATTER">
                    INSERT INTO	CHATSEEALSO (SEEALSOID, CHATINFOID, CHATSEEALSOINFO)
                    VALUES		(#val(FORM.SEEALSOID1)#, #val(Cookie.CHATINFOID)#, '#FORM.CHATSEEALSOINFO1#')
               </CFQUERY>
 
          <CFELSE>
 
          	<CFQUERY name="ModifySeeAlso1" datasource="#application.type#IDTCHATTER">
                    UPDATE	CHATSEEALSO
                    SET		CHATSEEALSOINFO = '#FORM.CHATSEEALSOINFO1#'
                    WHERE	CHATINFOID = #val(Cookie.CHATINFOID)# AND
                              SEEALSOID = #val(listGetAt(ChatSeeAllKeys,1))#
               </CFQUERY>
          </CFIF>
     </CFIF>
     
     <CFIF IsDefined('FORM.CHATSEEALSOINFO2') AND #FORM.CHATSEEALSOINFO2# NEQ ''>
          <CFIF LookupChatSeeAll.Recordcount LT 2>
 
             	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#IDTCHATTER">
                    SELECT	MAX(SEEALSOID) AS MAX_ID
                    FROM		CHATSEEALSO
               </CFQUERY>
          
               <CFSET FORM.SEEALSOID2 = #val(GetMaxUniqueID.MAX_ID+1)#>
               <CFQUERY name="AddSeeAlso2" datasource="#application.type#IDTCHATTER">
                    INSERT INTO	CHATSEEALSO (SEEALSOID, CHATINFOID, CHATSEEALSOINFO)
                    VALUES		(#val(FORM.SEEALSOID2)#, #val(Cookie.CHATINFOID)#, '#FORM.CHATSEEALSOINFO2#')
               </CFQUERY>

           <CFELSE>

           	<CFQUERY name="ModifySeeAlso2" datasource="#application.type#IDTCHATTER">
                    UPDATE	CHATSEEALSO
                    SET		CHATSEEALSOINFO = '#FORM.CHATSEEALSOINFO2#'
                    WHERE	CHATINFOID = #val(Cookie.CHATINFOID)# AND
                              SEEALSOID = #val(listGetAt(ChatSeeAllKeys,2))#
               </CFQUERY>    	
          </CFIF>
     </CFIF>
 
     <CFIF IsDefined('FORM.CHATSEEALSOINFO3') AND #FORM.CHATSEEALSOINFO3# NEQ ''>
     	<CFIF LookupChatSeeAll.Recordcount LT 3>
          
          	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#IDTCHATTER">
                    SELECT	MAX(SEEALSOID) AS MAX_ID
                    FROM		CHATSEEALSO
               </CFQUERY>
          
               <CFSET FORM.SEEALSOID3 = #val(GetMaxUniqueID.MAX_ID+1)#>
               <CFQUERY name="AddSeeAlso3" datasource="#application.type#IDTCHATTER">
                    INSERT INTO	CHATSEEALSO (SEEALSOID, CHATINFOID, CHATSEEALSOINFO)
                    VALUES		(#val(FORM.SEEALSOID3)#, #val(Cookie.CHATINFOID)#, '#FORM.CHATSEEALSOINFO3#')
               </CFQUERY>
        <CFELSE>
			
                <CFQUERY name="ModifySeeAlso3" datasource="#application.type#IDTCHATTER">
                    UPDATE	CHATSEEALSO
                    SET		CHATSEEALSOINFO = '#FORM.CHATSEEALSOINFO3#'
                    WHERE	CHATINFOID = #val(Cookie.CHATINFOID)# AND
                              SEEALSOID = #val(listGetAt(ChatSeeAllKeys,3))#
               </CFQUERY>      
        </CFIF>
     </CFIF>
     
     <CFIF FORM.PROCESSIDTCHATTER EQ "ADD">     
		<H1>Data ADDED!</H1>
          <CFIF IsDefined('URL.STAFFLOOP') OR IsDefined('URL.SRCALL') OR (IsDefined('client.SRCALL') AND #client.SRCALL# EQ 'YES')>
			<SCRIPT language="JavaScript">
                    <!-- 
					alert("Data Added!");
                         window.close();
                    -->
               </SCRIPT>
               <CFEXIT>
          </CFIF>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSIDTCHATTER EQ "DELETE" OR FORM.PROCESSIDTCHATTER EQ "CANCELADD">
	<CFQUERY name="DeleteChatInfo" datasource="#application.type#IDTCHATTER">
		DELETE FROM	CHATSEEALSO
		WHERE		CHATINFOID = #val(Cookie.CHATINFOID)#
	</CFQUERY> 
	<CFQUERY name="DeleteChatInfo" datasource="#application.type#IDTCHATTER">
		DELETE FROM	IDTCHATTERINFO
		WHERE		CHATINFOID = #val(Cookie.CHATINFOID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF IsDefined('URL.STAFFLOOP') OR IsDefined('URL.SRCALL') OR (IsDefined('client.SRCALL') AND #client.SRCALL# EQ 'YES')>
          <SCRIPT language="JavaScript">
               <!-- 
				alert("Data Deleted!");
                    window.close();
               -->
          </SCRIPT>
          <CFEXIT>
     </CFIF>

	<CFIF FORM.PROCESSIDTCHATTER EQ "DELETE">
  		
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="0; URL=#Cookie.INDEXDIR#/index.cfm" />
		<CFEXIT>
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>