<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: matrlreqsdupslookup.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/23/2009 --->
<!--- Date in Production: 03/23/2009 --->
<!--- Module: Special Collections - Material Requests & Duplications Reports Lookup Screen --->
<!-- Last modified by John R. Pastori on 03/23/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATERESEARCHERID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="RESEARCHERID">Researcher Name</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATETOPIC">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="TOPIC">Topic</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATERESEARCHERID" id="NEGATERESEARCHERID" value="" align="LEFT" required="No" tabindex="2">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="RESEARCHERID" id="RESEARCHERID" size="1" query="ListResearcherInfo" value="RESEARCHERID" display="FULLNAME" selected="0" required="No" tabindex="3"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATETOPIC" id="NEGATETOPIC" value="" align="LEFT" required="No" tabindex="4">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="TOPIC" id="TOPIC" value="" size="50" maxlength="100" tabindex="5">
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATECOLLECTIONID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="COLLECTIONID">Collection Name</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATECALLNUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="CALLNUMBER">Call Number</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOLLECTIONID" id="NEGATECOLLECTIONID" value="" align="LEFT" required="No" tabindex="6">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="COLLECTIONID" id="COLLECTIONID" size="1" query="ListCollections" value="COLLECTIONID" display="COLLECTIONNAME" selected="0" required="No" tabindex="7"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECALLNUMBER" id="NEGATECALLNUMBER" value="" align="LEFT" required="No" tabindex="8">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="text" name="CALLNUMBER" id="CALLNUMBER" size="20" maxlength="20" value="" tabindex="9">
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEBOXNUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="BOXNUMBER">Box Number</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESERVICEDATE">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SERVICEDATE">
				(1) a single Service Date or (2) a series of dates separated <br />
				&nbsp;by commas,NO spaces or (3) two dates separated by a<br />
				&nbsp;semicolon for range.</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBOXNUMBER" id="NEGATEBOXNUMBER" value="" align="LEFT" required="No" tabindex="10">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="BOXNUMBER" id="BOXNUMBER" size="20" maxlength="20" value="" tabindex="11">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESERVICEDATE" id="NEGATESERVICEDATE" value="" align="LEFT" required="No" tabindex="12">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="SERVICEDATE" id="SERVICEDATE" value="" required="No" size="50" tabindex="13"><br>
				<com>Date Format: MM/DD/YYYY</com>
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEASSISTANTNAMEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="ASSISTANTNAMEID">Assistant Name</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESECONDASSISTANTNAMEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SECONDASSISTANTNAMEID">2nd Assistant Name</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEASSISTANTNAMEID" id="NEGATEASSISTANTNAMEID" value="" align="LEFT" required="No" tabindex="14">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="ASSISTANTNAMEID" id="ASSISTANTNAMEID" query="ListAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="15"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESECONDASSISTANTNAMEID" id="NEGATESECONDASSISTANTNAMEID" value="" align="LEFT" required="No" tabindex="16">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="SECONDASSISTANTNAMEID" id="SECONDASSISTANTNAMEID" query="ListSecondAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="17"></CFSELECT>
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATERESERVICEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SERVICEID">Service Name</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEREAPPROVEDBYID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="APPROVEDBYID">Approved By</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESERVICEID" id="NEGATESERVICEID" value="" align="LEFT" required="No" tabindex="18">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="SERVICEID" id="SERVICEID" size="1" query="ListServices" value="SERVICEID" display="SERVICENAME" required="No" tabindex="19"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAPPROVEDBYID" id="NEGATEAPPROVEDBYID" value="" align="LEFT" required="No" tabindex="20">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="APPROVEDBYID" id="APPROVEDBYID" query="ListActiveApprovers" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="21"></CFSELECT>
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATETOTALCOPIESMADE">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="TOTALCOPIESMADE">Total Copies Made</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATECOSTFORSERVICE">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="COSTFORSERVICE">Cost For Service</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATETOTALCOPIESMADE" id="NEGATETOTALCOPIESMADE" value="" align="LEFT" required="No" tabindex="22">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="TOTALCOPIESMADE" id="TOTALCOPIESMADE" size="20" maxlength="20" value="" tabindex="23">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOSTFORSERVICE" id="NEGATECOSTFORSERVICE" value="" align="LEFT" required="No" tabindex="24">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="COSTFORSERVICE" id="COSTFORSERVICE" size="20" maxlength="20" value="" tabindex="25">
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEPAIDTYPEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PAIDTYPEID">Paid Types</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATECOMMENTS">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="COMMENTS">Comments</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPAIDTYPEID" id="NEGATEPAIDTYPEID" value="" align="LEFT" required="No" tabindex="26">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="PAIDTYPEID" id="PAIDTYPEID" query="ListPaidTypes" value="PAIDTYPEID" display="PAIDTYPENAME" selected="0" tabindex="27"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="28">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="COMMENTS" id="COMMENTS" required="No" align="left" size="60" tabindex="29">
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEMODIFIEDBYID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="MODIFIEDBYID">Modified By</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEMODIFIEDDATE">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="MODIFIEDDATE">
				(1) a single Modified Date or (2) a series of dates separated <br />
				&nbsp;by commas,NO spaces or (3) two dates separated by a<br />
				&nbsp;semicolon for range.</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="30">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListModifiedBy" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="31"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="32">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="33"><br>
				<com>Date Format: MM/DD/YYYY</com>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4"><hr align="left" width="100%" size="5" noshade /></td>
		</tr>
		<tr>
			<th colspan="4">
				<h2>Clicking the "Match All" Button with no selections equals ALL records for the requested report.</h2><br>
				<COM>Click the "Match All" Button when using the NEGATE checkboxes to get the correct records for your report.</COM>
			</th>
		</tr>
</CFOUTPUT>