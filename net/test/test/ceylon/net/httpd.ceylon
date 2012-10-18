import ceylon.net.httpd { Httpd, WebEndpointMapping, newHttpdInstance = newInstance }
void testHttpd() {
	Httpd httpd = newHttpdInstance();
	httpd.addWebEndpointMapping(WebEndpointMapping("/path", "com.redhat.ceylon.demo.web.helloworld", "com.redhat.ceylon.demo.web.helloworld.Web", "1.0.0"));
	httpd.addWebEndpointMapping(WebEndpointMapping("/async", "com.redhat.ceylon.demo.web.helloworld", "com.redhat.ceylon.demo.web.helloworld.WebAsync", "1.0.0"));
	httpd.start();
	
}