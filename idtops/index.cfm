<!doctype html public "-//w3c//dtd html 3.2//en">
<!--- Program: index.cfm --->
<!--- By: Carol Phillips --->
<!--- Date Written: 08/05/2009 --->
<!--- Date in Production: 08/05/2009 --->
<!--- Module: LFOLKS IST Ops Home Page--->
<!-- Last modified by John R. Pastori on 08/05/2009 using ColdFusion Studio. -->
<!-- Last modified by phillips on 03/06/2009 using BBEDIT -->

<CFSET AUTHOR_NAME = "Carol Phillips">
<CFSET AUTHOR_EMAIL = "phillips@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/istops/index.cfm">
<CFSET CONTENT_UPDATED = "August 05, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
<LINK rel="STYLESHEET" href="/style/main.css" type="text/css" />
<STYLE type="text/css"></STYLE>
<TITLE>IDT - InfoSys Ops Manual</TITLE>
<META name="GENERATOR" content="Arachnophilia 4.0" />
<META name="FORMATTER" content="Arachnophilia 4.0" />
</HEAD>
<BODY>

<CFOUTPUT>
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/idtops">
<CFINCLUDE template="/include/coldfusion/header.cfm">

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>InfoSys Operations Manual</H1></TD>
	</TR>
</TABLE>
<CENTER> 
<P></P>
 <!A HREF="index.cfm">Info. & Tech. Support    |  <A href="indexmc.cfm">Media Center</A> |  <A href="indexpac.cfm">PAC Support</A>  | <A href="indexsans.cfm">SANS/ACS</A>  |  <A href="indexti.cfm">TI</A>   |  <A href="indexscc.cfm">SCC</A><BR /><BR />   

<FONT color="##FF0000"><EM>NOTE:  Most resources below are in .pdf format and will require the use of Adobe Acrobat Reader.</EM></FONT><BR />


<H2>Info. & Tech. Support Procedures</H2>
<STRONG><A name="Quick Index">Quick Index</A></STRONG><BR />
<A href="##News">Announcements, Contacts and News</A>   |  <A href="##Knowledge">KnowledgeBase</A>  |   <A href="##Info">InfoSys Service Desk</A>  <BR />
<A href="##Ops">Operations Support</A>  |   <A href="##site">Site Consultant and Administrator</A>  <BR />
<A href="##Unit">Unit/Customer Resources</A>  
</CENTER>
<HR />

<P>
<BIG><STRONG><A name="News">Announcements, Contacts and News </A></STRONG></BIG><BR />
</P><UL>
<LI><A href="/#application.type#apps/idtops/opsinfo/aftercontfull.pdf">After Hours/Weekend Service Contacts (Full List)</A>
</LI><LI><A href="http://www-rohan.sdsu.edu/solutions.shtml" target="_blank">Finding Computing Solutions</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/idtemergency.pdf">IDT Emergency Procedures</A> and <A href="/#application.type#apps/idtops/opsinfo/emergpackinvent.pdf">Emergency Pack Inventory</A>
</LI><LI><A href="/#application.type#apps/idtcustomer/resources/itsliaison.pdf">ITS Liaisons</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/LIBliaison.pdf">Library Liaisons</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/phonebomb.pdf">Threatening Phone Call Checklist</A>
</LI><LI><A href="/#application.type#apps/idtcustomer/resources/unitliaisons.pdf">Unit Liaisons for InfoSys</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/whoyagonnacall.pdf">Who Ya Gonna Call</A>
</LI></UL>
<P></P><P>
Return to <A href="##Quick Index">Quick Index</A>
</P>
<HR />

<P>
<BIG><STRONG><A name="Knowledge">KnowledgeBase</A></STRONG></BIG><BR />
</P><UL>
<LI><A href="/#application.type#apps/idtops/opsinfo/securityapp.pdf">Access - Library Web Applications Security - ADMIN Level & above</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/securitygdelines.pdf">Access - Library Web Applications Security Guidelines - ADMIN Level & above</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/publicdeskapp.pdf">Access - Public Desk database (part of Web Reports App) - MAINT Level & above</A>, or
<A href="/#application.type#apps/idtops/opsinfo/mntlesspdmenu.pdf"> - MAINTLESS Level</A>, or
<A href="/#application.type#apps/idtops/opsinfo/userpdmenu.pdf"> - USER Level</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/namecompaccts.pdf">Acct - Naming Conventions for Computing Accounts</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/hwapp.pdf">HW - IDT Hardware Inventory Application - MAINT Level & above</A>, or
<A href="/#application.type#apps/idtops/opsinfo/mntlesshwmenu.pdf"> - MAINTLESS Level</A>, or
<A href="/#application.type#apps/idtops/opsinfo/userhwmenu.pdf"> - USER Level</A>
</LI><LI><A href="/#application.type#apps/idtcustomer/resources/infoclassification.pdf">Info - SDSU Information Classification Standard</A>
</LI><LI><A href="/#application.type#apps/idtcustomer/resources/tabletpcproc.pdf">Info - Tablet PCs in Library Instruction, Procedures for Use</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/dbnotes.pdf">ISD - InfoSys Service Desk Database Notes</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/isdgdeline.pdf">ISD - InfoSys Service Desk Guidelines and Policies</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/idtlsagde.pdf">ISD - InfoSys Student Assistant Guide</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/supplycabcontents.pdf">ISD - IDT Supply Cabinet Contents </A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/facscheme.pdf">Maint - IDT Facilities Scheme and Map</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/inventstrage.pdf">Maint - IDT Inventory Storage Guidelines</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/idtsecurity.pdf">Maint - IDT Security Guidelines</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/waste.pdf">Maint - Regulated and Hazardous Waste</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/relrep.pdf">Maint - Relocation, Repair or Replacement Guidelines</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/millcheck.pdf">MIL - Checking Status of LIBPAC (Millennium)</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/facjackapp.pdf">Net - Facilities/Wall Jack Application</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/jackstatus.pdf">Net - Wall Jack Status</A>
</LI><LI><A href="https://arwen.sdsu.edu/share/PACSUP/PACLIAISON/PACrsrcs/PAC.rsrcs.htm" target="_blank">PAC - PAC Resources</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/purchapp.pdf">Purch - IDT Purchasing Application - MAINT Level & above</A>, or
<A href="/#application.type#apps/idtops/opsinfo/mntlesspurchmenu.pdf"> - MAINTLESS Level</A>, or
<A href="/#application.type#apps/idtops/opsinfo/userpurchmenu.pdf"> - USER Level</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/reseval.pdf">Purch - Resource Evaluation Guidelines </A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/pcatstaff.pdf">SR - SR Problem/Sub Category and Staff Referral</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/srapp.pdf">SR - IDT Service Request Application - MAINT Level & above</A>, or
<!A HREF="/#application.type#apps/idtops/opsinfo/mntlesssrmenu.pdf"> - MAINTLESS Level</A>, or
<!A HREF="/#application.type#apps/idtops/opsinfo/usersrmenu.pdf"> - USER Level</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/sdapp.pdf">SR - Library Shared Data Aplication - MAINT Level & above</A>, or
<A href="/#application.type#apps/idtops/opsinfo/mntlesssdmenu.pdf"> - MAINTLESS Level</A>, or
<A href="/#application.type#apps/idtops/opsinfo/usersdmenu.pdf"> - USER Level</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/serversfull.pdf">SR - Server Services Managed by Information and Digital Technologies</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/srchoices.pdf">SR - Standard Service Requests Choice Combinations</A>
</LI><LI><A href="http://rohan.sdsu.edu/~bats/PDF/pdfhandouts.html" target="_blank">SW - BATS Workshop Handouts</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/swapp.pdf">SW - IDT Software Inventory Application - MAINT Level & above</A>, or
<A href="/#application.type#apps/idtops/opsinfo/mntlessswmenu.pdf"> - MAINTLESS Level</A>, or
<A href="/#application.type#apps/idtops/opsinfo/userswmenu.pdf"> - USER Level</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/libsoft.pdf">SW - Library Supported Software</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/basicsw.pdf">SW - Library Supported Software, Basic Usage of </A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/swsitevp.pdf">SW - Site Licensing and Volume Purchasing</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/swdistribute.pdf">SW - Software Distribution for Work at Home</A>
</LI><LI><A href="http://rohan.sdsu.edu/aboutgraph.shtml" target="_blank">Web - About the ROHAN Graphics</A>
</LI><LI><A href="http://rohan.sdsu.edu/aboutserver.html" target="_blank">Web - About the ROHAN Web Server</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/rwebftp.pdf">Web - FTP Instructions for the Academic Computing Web Site</A>
</LI><LI><A href="http://rohan.sdsu.edu/hpguide.shtml" target="_blank">Web - Guide to Making a Home Page on ROHAN</A>
</LI><LI><A href="http://lfolks.sdsu.edu/groups/webteam/pagemasters.html" target="_blank">Web - Infodome PageMasters</A>
</LI><LI><A href="http://lfolks.sdsu.edu/groups/webteam/index.html" target="_blank">Web - Infodome Web Team </A>     
</LI><LI><A href="http://rohan.sdsu.edu/graphlib.html" target="_blank">Web - ROHAN Graphics Library</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/webgdelines.pdf">Web - ROHAN Web Document Guidelines</A>
</LI><LI><A href="http://rohan.sdsu.edu/aboutresp.html" target="_blank">Web - ROHAN Web Responsibilities</A>
</LI><LI><A href="http://www.sa.sdsu.edu/communications/styleguide//" target="_blank">Web - WWW Style Guide for SDSU</A>
</LI></UL>
<P></P><P>
Return to <A href="##Quick Index">Quick Index</A>
</P>
<HR />

<P>
<BIG><STRONG><A name="Info">InfoSys Service Desk</A></STRONG></BIG><BR />
</P><UL>
<LI><A href="/#application.type#apps/idtops/opsinfo/vms46753.pdf">ISD - 46753 VMS Procedure</A>  
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/dattape.pdf">ISD - DAT Tape Deliver and Pickupto EBA-134 (Univ. Computer Operations)</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/isdeudora.pdf">ISD - Infosys@library.sdsu.edu Procedure</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/isdstartup.pdf">ISD - IDTDesk Workstation Startup and Shutdown</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/mailpickup.pdf">ISD - Mail Pickup and Delivery</A>   
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/officesupp.pdf">ISD - Ordering and Receiving Office Supplies at the InfoSys Service Desk</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/srdataentry.pdf">ISD - SR Data Entry from Mail Forms</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/isdequip.pdf">ISD - Xerox, FAX, and Printer: Supplies and Service</A>
</LI></UL>
<P></P><P>
Return to <A href="##Quick Index">Quick Index</A>
</P>
<HR />

<P>
<BIG><STRONG><A name="Ops">Operations Support</A></STRONG></BIG><BR />
</P><UL>
<LI><!A HREF="/#application.type#apps/idtops/opsinfo/serveraccess.pdf">Files - Access to Servers Instructions</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/hwassignment.pdf">HW - Assignment Data and Reports Instructions</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/cpuwipe.pdf">HW - CPU Wipe Instructions</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/equiploan.pdf">HW - Equipment Loan Procedure</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/hwjackupd.pdf">HW - Hardware and Wall Jack Update Procedure</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/hardckin.pdf">HW - Hardware Check-In and Assignment</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/hwrelocation.pdf">HW - Hardware Relocation Instructions</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/hwsurvey.pdf">HW - Hardware Survey Guidelines</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/imaging.pdf">HW - Imaging Checkout Laptops</A>
</LI><LI><A href="/#application.type#apps/idtops/unithreport.pdf">HW - IDT Hardware Inventory Reports - Units & Public Areas</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/minorrep.pdf">HW - Minor Repairs Procedure</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/cddup.pdf">Maint - CD Duplication Instructions</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/iso.pdf">Maint - ISO Procedure</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/idtsuitepm.pdf">Maint - IDT Suite Preventative Maintenance</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/paccircuitbackup.pdf">Maint - PAC and Circuit Unattended Backup Instructions</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/netjacktesting.pdf">Network - Jack Testing with the Fluke </A>
</LI><LI><!A HREF="/#application.type#apps/idtops/unitsreport.pdf">SW - IDT Software Inventory Unit Reports</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/applewarranty.pdf">VR - Apple Procedure for Warranty Repair</A>   
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/dhl.pdf">VR - Dell/DHL Procedure for Shipping Dell Boxes</A>   
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/fedex.pdf">VR - Federal Express Procedure</A>   
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/gatewaywarrenty.pdf">VR - Gateway Warranty Procedure</A>   
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/printerrepair.pdf">VR - Printer Procedures: Repair/Troubleshooting</A>   
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/trouble.pdf">VR - Troubleshooting Procedure</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/vendorrep.pdf">VR - Vendor Repair Procedure</A>
</LI></UL>
<P></P><P>
Return to <A href="##Quick Index">Quick Index</A>
</P>
<HR />


<P>
<BIG><STRONG><A name="site">Site Consultant and Administrator</A></STRONG></BIG><BR />
</P><UL>
<LI><A href="/#application.type#apps/idtops/opsinfo/acacct.pdf">Accts - Academic Computing Account Services </A>   
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/adminnovell.pdf">Accts - Administering Rights via Novell Net Admin</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/disableacct.pdf">Accts - Guidelines for Disabling Accounts on ROHAN and Moria</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/acctrohan.pdf">Accts - ROHAN/Moria Accounting Procedures</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/rsrohan.pdf">Accts - ROHAN Accounting Procedure for SCC</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/rohannotes.pdf">Accts - ROHAN Usage Notes</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/surveynovell.pdf">Accts - Running Survey.bat for Novell Rights Review</A>
</LI><LI><A href="/#application.type#apps/idtcustomer/resources/phonedirservices.pdf">EM - Directory Services in Eudora (Mac/Win)</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/emailcoord.pdf">EM - Email Coordinator Procedures</A>
</LI><LI><A href="http://tns.sdsu.edu/certificate.htm">EM - Eudora 7.x Certificate Trust</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/headfoot.pdf">EM - How to Stop the Eudora Header or Footer from Printing</A>
</LI><LI><A href="/#application.type#apps/idtops/opssans/cntrlnickname.pdf">EM - How to Use the Central Recipient List of Nicknames</A>
</LI><LI><A href="/#application.type#apps/idtops/opssans/ssleudoraosx.pdf">EM - Setting Up SSL in Eudora 6.2.4 Mac OSX</A> 
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/htmlconvrt.pdf">Files - Converting Documents to HTML Files</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/rdirfiles.pdf">Files - Directory Structure on ROHAN</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/hardfilestorage.pdf">Files - Hardcopy and File Storage Guidelines</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/custdocindex.pdf">Files - IDT Customer Resources Document Index</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/dirarwen.pdf">Files - InfoSys Directory Structure on Arwen</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/dirgollum.pdf">Files - InfoSys Directory Structure on Gollum</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/dirlfolks.pdf">Files - InfoSys Directory Structure on Lfolkswiki(Lfolks)</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/rbrman.pdf">Maint - Circulation/Reserves Software Manuals Procedures</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/tnsrequest.pdf">Net - CCS (TNS) Network Repair Requests</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/xxxx.pdf">Purch - Hardware/Software Maintenance Purchasing Instructions<!/A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/purchlibidt.pdf">Purch - Library Purchasing Procedure and IDT</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/officemax.pdf">Purch - Office Max Supply Ordering Procedures</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/purchopenpo.pdf">Purch - Open PO/Contract Instructions</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/oraclefinancials.pdf">Purch - Oracle Financials Lookups</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/purchsrprocess.pdf">Purch - Spec'ing and the SR Process</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/lsahire.pdf">SA - Hiring Student Assistants</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/srreferacs.pdf">SR - Referrals for Arriving and Departing ACS Customers</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/srreferlib.pdf">SR - Referrals for Arriving and Departing Library Employees</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/mediadocgde.pdf">SW - Media/Documentation Guidelines</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/scifinderarchproc.pdf">SW - SciFinder Scholar Archive Procedure</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/swcheckin.pdf">SW - Software Check-In and Assignment</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/swcheckout.pdf">SW - Software Check-Out</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/swarchiving.pdf">SW - Steps for Software Inventory Archive Processing 
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/istgollum.pdf">Web - IDT/Gollum Updating</A>
</LI><LI><!A HREF="/#application.type#apps/idtops/opsinfo/istlfolks.pdf">Web - IDT/Lfolks Updating</A>
</LI></UL>
<P></P><P>
Return to <A href="##Quick Index">Quick Index</A>
</P>
<HR />


<P>
<BIG><STRONG><A name="Unit">Unit/Customer Resources </A></STRONG></BIG><BR />
Pre-Release/Archive 
</P><UL>
<LI><A href="/#application.type#apps/idtops/opsinfo/cpmcfiche2.pdf">CPMC - MicroFilm/Fiche Reader Operations</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/cpmcfiche.pdf">CPMC - Scanning MicroFilm/Fiche images to a Floppy Disk</A>
</LI><LI><A href="http://lfolks.sdsu.edu/files/usingnetstorage.pdf" target="_blank">Files - Using Netstorage</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/macincbattery.pdf">Mac - Increasing Battery Performance in Mac Laptops</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/macmobile.pdf">Mac - Macintosh Mobile Computing</A>
</LI><LI><A href="/#application.type#apps/idtops/opsinfo/classicdtop.pdf">Mac - Making a "Classic" OS X Desktop</A>
</LI></UL>
<P></P><P>
Return to <A href="##Quick Index">Quick Index</A>
</P>
<HR />
<CENTER> 
<P></P>
 <!A HREF="index.cfm">Info. & Tech. Support</A>   |  <A href="indexmc.cfm">Media Center</A>  |  <A href="indexpac.cfm">PAC Support</A>  | <A href="indexsans.cfm">SANS/ACS</A> 
 |  <A href="indexti.cfm">TI</A>   |  <A href="indexscc.cfm">SCC</A><BR /><BR />   

<P></P>
</CENTER>
<P>
</P>

<CFINCLUDE template="/include/coldfusion/footer.cfm">

</CFOUTPUT>

</BODY>
</HTML>