<!--- Program: tskSQLInjection.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/09/2008 --->
<!--- Date in Production: 09/09/2008 --->
<!--- Module: Application ColdFusion SQL Injection Memory IP Table Reset task --->
<!--- This task is scheduled in the Coldfusion Server Scheduled Tasks function on the LFOLKS Server --->
<!-- Last modified by John R. Pastori on 09/09/2008 using ColdFusion Studio. -->


<CFLOOP from="1" to="#arrayLen(APPLICATION.ipBlackList)#" index="currPosition">
	<CFIF dateDiff("n", APPLICATION.ipBlackList[currPosition].arrayTime, NOW()) GT "60">
		<CFSET VARIABLES.temp = arrayDeleteAt(APPLICATION.ipBlackList, currPosition)>
	</CFIF>
</CFLOOP>