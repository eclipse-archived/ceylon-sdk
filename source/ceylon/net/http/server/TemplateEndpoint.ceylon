import ceylon.net.http {
    Method
}

"Endpoint to leverage Undertow's template mechanism for path templates and path parameters.
 The matcher given to the parent class will be ignored but is necessary."
shared class TemplateEndpoint(pathTemplate, service, acceptMethod)
      extends Endpoint(IsRoot(), service, acceptMethod) {

    "Matches a path with path parameters. The parameters are indicated
     by curly braces in the template, for example /a/{b}/c/{d} Their values can be obtained from
     the Request via the Request.pathParameter() method."
    shared String pathTemplate;
    {Method*} acceptMethod;

    void service(Request request, Response response);
}