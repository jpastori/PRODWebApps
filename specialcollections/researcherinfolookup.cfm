<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: researcherinfolookup.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/23/2009 --->
<!--- Date in Production: 03/23/2009 --->
<!--- Module: Special Collections - Researcher Information Reports Lookup Screen --->
<!-- Last modified by John R. Pastori on 03/23/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEHONORIFIC">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="HONORIFIC">Honorific</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEDATEREGISTERED">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="DATEREGISTERED">
				(1) a single Date Registered or (2) a series of dates separated <br />
				&nbsp;by commas,NO spaces or (3) two dates separated by a<br />
				&nbsp;semicolon for range.</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEHONORIFIC" id="NEGATEHONORIFIC" value="" align="LEFT" required="No" tabindex="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td align="LEFT" width="45%">
				<select size="1" name="HONORIFIC" id="HONORIFIC" tabindex="3">
					<option selected value="0">None</option>
					<option value="Mr.">Mr.</option>
					<option value="Ms.">Ms.</option>
					<option value="Miss">Miss</option>
					<option value="Mrs.">Mrs.</option>
					<option value="Dr.">Dr.</option>
				</select>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDATEREGISTERED" id="NEGATEDATEREGISTERED" value="" align="LEFT" required="No" tabindex="4">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="DATEREGISTERED" id="DATEREGISTERED" value="" required="No" size="50" tabindex="5"><br>
				<com>Date Format: MM/DD/YYYY</com>
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEFIRSTNAME">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="FIRSTNAME">First Name</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATELASTNAME">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="LASTNAME">Last Name</label>
			</th>
			
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFIRSTNAME" id="NEGATEFIRSTNAME" value="" align="LEFT" required="No" tabindex="6">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="FIRSTNAME" id="FIRSTNAME" size="25" maxlength="50" value="" tabindex="7">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATELASTNAME" id="NEGATELASTNAME" value="" align="LEFT" required="No" tabindex="8">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="text" name="LASTNAME" id="LASTNAME" size="25" maxlength="50" value="" tabindex="9">
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEINSTITUTION">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="INSTITUTION">Institution</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEDEPTMAJOR">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="DEPTMAJOR">Dept/Major</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEINSTITUTION" id="NEGATEINSTITUTION" value="" align="LEFT" required="No" tabindex="10">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="INSTITUTION" id="INSTITUTION" size="50" maxlength="100" value="" tabindex="11">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDEPTMAJOR" id="NEGATEDEPTMAJOR" value="" align="LEFT" required="No" tabindex="12">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="DEPTMAJOR" id="DEPTMAJOR" size="50" maxlength="100" value="" tabindex="13">
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEADDRESS">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="ADDRESS">Address</label>
			</th>
			<th align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</th>
			<th align="left" valign="BOTTOM" width="45%">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEADDRESS" id="NEGATEADDRESS" value="" align="LEFT" required="No" tabindex="14">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="ADDRESS" id="ADDRESS" size="50" maxlength="100" value="" tabindex="15">
			</td>
			<td align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<td align="left" valign="BOTTOM" width="45%">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATECITY">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="CITY">City</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTATEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STATEID">State/Province</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECITY" id="NEGATECITY" value="" align="LEFT" required="No" tabindex="16">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="CITY" id="CITY" size="50" maxlength="100" value="" tabindex="17">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATEID" id="NEGATESTATEID" value="" align="LEFT" required="No" tabindex="18">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="STATEID" id="STATEID" size="1" query="ListStates" value="STATEID" display="STATECODENAME" selected="0" tabindex="19"></CFSELECT>
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEZIPCODE">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="ZIPCODE">Zip/Postal Code</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATPHONE">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PHONE">Phone</label>
			</th>
			
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEZIPCODE" id="NEGATEZIPCODE" value="" align="LEFT" required="No" tabindex="20">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="ZIPCODE" id="ZIPCODE" size="10" maxlength="15" value="" tabindex="21">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPHONE" id="NEGATEPHONE" value="" align="LEFT" required="No" tabindex="22">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="PHONE" id="PHONE" size="15" maxlength="25" value="" tabindex="23">
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEFAX">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="FAX">FAX</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEEMAIL">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="EMAIL">E-Mail</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFAX" id="NEGATEFAX" value="" align="LEFT" required="No" tabindex="24">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="text" name="FAX" id="FAX" size="15" maxlength="25" value="" tabindex="25">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEEMAIL" id="NEGATEEMAIL" value="" align="LEFT" required="No" tabindex="26">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="text" name="EMAIL" id="EMAIL" size="50" maxlength="100" value="" tabindex="27">
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEIDTYPEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="IDTYPEID">ID Type</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEIDNUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="IDNUMBER">ID Number</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEIDTYPEID" id="NEGATEIDTYPEID" value="" align="LEFT" required="No" tabindex="28">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="IDTYPEID" id="IDTYPEID" query="ListIDTypes" value="IDTYPEID" display="IDTYPENAME" selected="0" tabindex="29"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEIDNUMBER" id="NEGATEIDNUMBER" value="" align="LEFT" required="No" tabindex="30">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="text" name="IDNUMBER" id="IDNUMBER" size="50" maxlength="100" value="" tabindex="31">
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTATUSID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STATUSID">Status</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEINITIALTOPIC">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="INITIALTOPIC">Initial Topic</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATUSID" id="NEGATESTATUSID" value="" align="LEFT" required="No" tabindex="32">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="STATUSID" id="STATUSID" size="1" query="ListStatus" value="STATUSID" display="STATUSNAME" selected="0" required="No" tabindex="33"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEINITIALTOPIC" id="NEGATEINITIALTOPIC" value="" align="LEFT" required="No" tabindex="34">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="text" name="INITIALTOPIC" id="INITIALTOPIC" size="50" maxlength="100" value="" tabindex="35">
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
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="36">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListModifiedBy" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="37"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="38">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="39"><br>
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