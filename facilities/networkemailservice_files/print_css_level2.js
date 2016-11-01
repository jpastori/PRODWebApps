
var NS4, IE, DOMstandard, CSScapable;
NS4 = (document.layers) ? 1 : 0;
IE = (document.all) ? 1 : 0;
DOMstandard = (document.getElementById) ? 1 : 0;
CSScapable = (NS4 || IE || DOMstandard) ? 1 : 0;

if(CSScapable) {
	if(NS4) 
		document.write("<link rel=\"stylesheet\" href=css/ns_style.css/" type=\"text/css\">");
	else
		document.write("<link rel=\"stylesheet\" href=css/dom_style.css/" type=\"text/css\" media=\"screen\">");
}


