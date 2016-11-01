 
if (document.images) {	

	homeon = new Image(43, 25);
	homeon.src = "../../images/HNR_home.gif"
	homeoff = new Image(43, 25);
	homeoff.src = "../../images/HN_home.gif"

	emergencieson = new Image(80, 25);
	emergencieson.src = "../../images/HNR_emergencies.gif"
	emergenciesoff = new Image(80, 25);
	emergenciesoff.src = "../../images/HN_emergencies.gif"
	
	servicereqon = new Image(104, 25);
	servicereqon.src = "../../images/HNR_servicereq.gif"
	servicereqoff = new Image(104, 25);
	servicereqoff.src = "../../images/HN_servicereq.gif"
	
	estimatesconsulton = new Image(162, 25);
	estimatesconsulton.src = "../../images/HNR_estimatesconsult.gif"
	estimatesconsultoff = new Image(162, 25);
	estimatesconsultoff.src = "../../images/HN_estimatesconsult.gif"
	
	abouton = new Image(123, 25);
	abouton.src = "../../images/HNR_about.gif"
	aboutoff = new Image(123, 25);
	aboutoff.src = "../../images/HN_about.gif"
	
	contacton = new Image(79, 25);
	contacton.src = "../../images/HNR_contact.gif"
	contactoff = new Image(79, 25);
	contactoff.src = "../../images/HN_contact.gif"
 }

function On(imgName) {
      if (document.images) 
          document.images[imgName].src = eval(imgName + "on.src");
}

function Off(imgName) {
      if (document.images)
             document.images[imgName].src = eval(imgName + "off.src");
} 


defaultStatus = '';


function pop_up(location,width,height)
{	
	window.open( location , 'pop_up_window' , eval("'status=no,location=no,menubar=no,toolbar=no,resizable=yes,scrollbars=yes," + "width=" + width + ",height=" + height + "'"));
}
