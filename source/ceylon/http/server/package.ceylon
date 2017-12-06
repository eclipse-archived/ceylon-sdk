/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A HTTP server. This package defines the API for creating
 a [[new server|newServer]] and defining endpoints using:
 
 - [[Endpoint]] for synchronously processed endpoints,
 - [[AsynchronousEndpoint]] for asynchronously processed 
   endpoints, and
 - [[ceylon.http.server.websocket::WebSocketEndpoint]]
   for web socket endpoints.
 
 See [[package ceylon.http.server.endpoints]] for 
 predefined covenience endpoints for 
 [[serving static files|ceylon.http.server.endpoints::serveStaticFile]] 
 and [[HTTP redirection|ceylon.http.server.endpoints::redirect]]."
by("Matej Lazar")
shared package ceylon.http.server;
