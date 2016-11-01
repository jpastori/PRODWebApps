<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: csv_importmmohardwarerecs.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: Import MMO Hardware CSV Records --->
<!-- Last modified by John R. Pastori on 09/25/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/csv_importmmohardwarerecs.cfm">
<CFSET CONTENT_UPDATED = "September 25, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HEAD>
	<META http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<TITLE>Import MMO Hardware CSV Records</TITLE>
     <LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<!--- Drop and Create Oracle MMO Hardware Table. --->

	<CFDBINFO type="tables" datasource="#application.type#HARDWARE" name="HITABLENAMES">
     
     <CFQUERY name="MMOHardwareTableExists" dbtype="query">
     	SELECT	TABLE_NAME, TABLE_TYPE 
          FROM 	HITABLENAMES 
          WHERE 	TABLE_TYPE='TABLE' AND
          		TABLE_NAME = 'MMOHARDWARE'
     </CFQUERY>

     <CFIF #MMOHardwareTableExists.RecordCount# GT 0>

		<BR><BR>
		The table contains the Table_Name: #MMOHardwareTableExists.TABLE_NAME# which has a Table_Type of: #MMOHardwareTableExists.TABLE_TYPE#
		<BR><BR>

          <CFQUERY name="DropMMOHardwareRecsTable" datasource="#application.type#HARDWARE">
               DROP TABLE MMOHARDWARE CASCADE CONSTRAINTS PURGE
          </CFQUERY>

     </CFIF>
     
     <CFQUERY name="CreateMMOHardwareRecsTable" datasource="#application.type#HARDWARE">
     	CREATE TABLE	MMOHARDWARE
					("MMOHW_ID" NUMBER(6) DEFAULT 0 NOT NULL,
					"STATEFOUNDNUMBER" VARCHAR2(15) DEFAULT NULL,
                         "SERIALNUMBER" VARCHAR2(50) DEFAULT NULL,
					"BUILDINGCODE" VARCHAR2(10) DEFAULT NULL,
					"ROOMNUMBER" VARCHAR2(10) DEFAULT NULL,
					"SPACE" VARCHAR2(5) DEFAULT NULL,
					"PURCHASEORDERNUMBER" VARCHAR2(50) DEFAULT NULL,
                         "ORGCODE" VARCHAR2(8) DEFAULT NULL,
					CONSTRAINT "MMOHWKEY" PRIMARY KEY("MMOHW_ID") 
                              USING INDEX  
                              TABLESPACE "HARDWAREINDEXES" 
                              STORAGE ( INITIAL 64K NEXT 0K MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0)
                              PCTFREE 10 INITRANS 2 MAXTRANS 255)  
					TABLESPACE "HARDWARE" PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
					STORAGE ( INITIAL 64K NEXT 0K MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) 
					LOGGING 
					MONITORING
                         
      </CFQUERY>
	
     <CFSET ReadRecordCount = 0>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Import MMO Hardware CSV Records</H1></TH>
		</TR>
	</TABLE>
     <TABLE width="100%" align="center" border="0">
          <TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
               <TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
          </TR>
     </TABLE>


<!--- Get and Read the CSV-TXT file --->
	<CFFILE action="read" file="/home/www/lfolkscf/htdocs/PRODapps/hardwareinventory/MMOData.csv" variable="csvfile">
     
<!--- loop through the CSV-TXT file on line breaks and insert into database --->
     <CFLOOP index="index" list="#csvfile#" delimiters="#chr(10)##chr(13)#">
     
     	
     
         <CFQUERY name="ImportCSVRecs" datasource="#application.type#HARDWARE">
              INSERT INTO MMOHARDWARE (MMOHW_ID, STATEFOUNDNUMBER, SERIALNUMBER, BUILDINGCODE, ROOMNUMBER, SPACE, PURCHASEORDERNUMBER, ORGCODE)
              VALUES     (#val(ReadRecordCount)#, 
					'#listgetAt('#index#',1, ',', 'yes')#',
					'#listgetAt('#index#',2, ',', 'yes')#',
					'#listgetAt('#index#',3, ',', 'yes')#',
					'#listgetAt('#index#',4, ',', 'yes')#',
					'#listgetAt('#index#',5, ',', 'yes')#',
					'#listgetAt('#index#',6, ',', 'yes')#',
                         '#listgetAt('#index#',7, ',', 'yes')#'
					)
        </CFQUERY>
        
        <CFSET ReadRecordCount = #ReadRecordCount# + 1>

     </CFLOOP>
     
     
     <TABLE width="100%" align="LEFT">
     	<TR align="center">
               <TH align="center"><HR></TH>
          </TR>
          <TR>
			<TD colspan="7" align="center">	
                    Records Created Count = #ReadRecordCount#
               </TD>
          </TR>
          <TR>
               <TH align="center"><HR></TH>
          </TR>
          <TR>
<CFFORM action="/#application.type#apps/hardwareinventory/mmohardwarereccompare.cfm" method="POST">
               <TD align="left">
               	<INPUT type="image" src="/images/buttonCompMMOHIRecs.jpg" value="Compare MMO & Hardware Inventory Records" alt="Compare MMO & Hardware Inventory Records" tabindex="2" />
               </TD>
</CFFORM>
          </TR>
	</TABLE>
     
</CFOUTPUT>
</BODY>
</HTML>
