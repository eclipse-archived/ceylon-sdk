"A HTTP server. This package defines the API for creating
 a [[new server|newServer]] and defining endpoints using:
 
 - [[Endpoint]] for synchronously processed endpoints,
 - [[AsynchronousEndpoint]] for asynchronously processed 
   endpoints, and
 - [[ceylon.net.http.server.websocket::WebSocketEndpoint]]
   for web socket endpoints.
 
 See [[package ceylon.net.http.server.endpoints]] for 
 predefined covenience endpoints for 
 [[serving static files|ceylon.net.http.server.endpoints::serveStaticFile]] 
 and [[HTTP redirection|ceylon.net.http.server.endpoints::redirect]]."
by("Matej Lazar")
shared package ceylon.net.http.server;
