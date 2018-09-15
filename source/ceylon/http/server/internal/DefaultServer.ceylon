/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    MutableList,
    LinkedList
}
import ceylon.http.server {
    Server,
    Options,
    Status { ... },
    InternalException,
    HttpEndpoint,
    TemplateMatcher,
    ServerException
}
import ceylon.http.server.internal.websocket {
    CeylonWebSocketHandler,
    WebSocketProtocolHandshakeHandler
}
import ceylon.http.server.websocket {
    WebSocketBaseEndpoint
}
import ceylon.io {
    SocketAddress
}

import io.undertow {
    UndertowOptions
}
import io.undertow.server {
    HttpHandler,
    XnioByteBufferPool
}
import io.undertow.server.handlers {
    PathTemplateHandler
}
import io.undertow.server.handlers.encoding {
    ContentEncodingRepository,
    EncodingHandler,
    DeflateEncodingProvider,
    GzipEncodingProvider
}
import io.undertow.server.handlers.error {
    SimpleErrorPageHandler
}
import io.undertow.server.protocol.http {
    HttpOpenListener
}
import io.undertow.server.session {
    InMemorySessionManager,
    SessionAttachmentHandler,
    SessionCookieConfig
}

import java.io {
    IOException
}
import java.lang {
    Runtime,
    JInt=Integer,
    JThread=Thread
}
import java.net {
    InetSocketAddress
}

import org.xnio {
    XnioWorker,
    OptionMap,
    XnioOptions=Options,
    ByteBufferSlicePool,
    BufferAllocator,
    ChannelListeners
}
import org.xnio.nio {
    NioXnioProvider
}

by("Matej Lazar")
shared class DefaultServer({<HttpEndpoint|WebSocketBaseEndpoint>*} endpoints)
        satisfies Server {

    value httpEndpoints = Endpoints();
    value webSocketHandler = CeylonWebSocketHandler();

    variable XnioWorker? worker = null;

    MutableList<Anything(Status)> statusListeners 
            = LinkedList<Anything(Status)>();

    for (endpoint in endpoints) {
        switch (endpoint)
        case (HttpEndpoint) {
            httpEndpoints.add(endpoint);
        }
        case (WebSocketBaseEndpoint) {
            webSocketHandler.addEndpoint(endpoint);
        }
    }

    HttpHandler getHandlers(Options options, HttpHandler next) {
        value protocolHandshakeHandler 
                = WebSocketProtocolHandshakeHandler(webSocketHandler,next);
        
        value sessionHandler 
                = SessionAttachmentHandler(
                    InMemorySessionManager(options.sessionId),
                    SessionCookieConfig());
        sessionHandler.setNext(protocolHandshakeHandler);
        
        value errPageHandler = SimpleErrorPageHandler(sessionHandler);
        errPageHandler.setNext(sessionHandler);

        value contentEncodingRepository = ContentEncodingRepository();
        contentEncodingRepository.addEncodingHandler("gzip", GzipEncodingProvider(), 50);
        contentEncodingRepository.addEncodingHandler("deflate", DeflateEncodingProvider(), 10);
        EncodingHandler encodingHandler = EncodingHandler(contentEncodingRepository);
        encodingHandler.setNext(errPageHandler);

        return encodingHandler;
    }
    
    shared actual void start(SocketAddress socketAddress, Options options) {
        notifyListeners(starting);
        //TODO log
        print("Starting on ``socketAddress.address``:``socketAddress.port``");
        
        value openListener
                = HttpOpenListener(
                    XnioByteBufferPool(
                        ByteBufferSlicePool(BufferAllocator.directByteBufferAllocator,
                            8192, 8192 * 8192)),
                    OptionMap.builder()
                        .set(UndertowOptions.bufferPipelinedData,false)
                        .map);
        
        value pathTemplateHandler
                = PathTemplateHandler(
                    CeylonRequestHandler(options, 
                        httpEndpoints));
        for (endpoint in httpEndpoints.endpoints) {
            if (is TemplateMatcher matcher = endpoint.path) {
                assert(is HttpEndpoint endpoint);
                pathTemplateHandler.add(matcher.template, 
                    TemplateCeylonRequestHandler(options, endpoint));
            }
        }
        
        openListener.rootHandler 
                = getHandlers(options, pathTemplateHandler);
        
        value workerOptions
                = OptionMap.builder()
                .set(XnioOptions.workerIoThreads,
                    JInt(options.workerIoThreads))
                .set(XnioOptions.connectionLowWater,
                    JInt(options.connectionLowWatter))
                .set(XnioOptions.connectionHighWater,
                    JInt(options.connectionHighWatter))
                .set(XnioOptions.workerTaskCoreThreads,
                    JInt(options.workerTaskCoreThreads))
                .set(XnioOptions.workerTaskMaxThreads,
                    JInt(options.workerTaskMaxThreads))
                .set(XnioOptions.tcpNodelay, true)
                .set(XnioOptions.cork, true)
                .map;
        
        value serverOptions
                = OptionMap.builder()
                .set(XnioOptions.tcpNodelay, true)
                .set(XnioOptions.reuseAddresses, true)
                .map;
        
        worker = NioXnioProvider().instance.createWorker(workerOptions);
        
        if (exists w = worker) {
            try {
                w.createStreamConnectionServer(
                    InetSocketAddress(socketAddress.address,
                                      socketAddress.port),
                    ChannelListeners.openListenerAdapter(openListener),
                    serverOptions)
                        .resumeAccepts();
            } catch (IOException e) {
                print("Failed to start server.");
                notifyListeners(stopped);
                throw ServerException("Failed to start server.", e);
            }
        } else {
            throw InternalException("Missing xnio worker!");
        }
        
        object shutdownThread 
                extends JThread("Shutdown thread") {
            run = outer.stop;
        }
        shutdownThread.daemon = false;
        Runtime.runtime.addShutdownHook(shutdownThread);
        
        //TODO log
        print("Httpd started.");
        notifyListeners(started);

        if (exists w = worker) {
            w.awaitTermination();
        }
    }
    
    shared actual void startInBackground(SocketAddress socketAddress, 
            Options options) {
        object extends JThread() {
            run() => outer.start(socketAddress, options);
        }.start();
    }
    
    shared actual void stop() {
        if (exists w = worker) {
            notifyListeners(stopping);
            w.shutdown();
            //TODO log
            print("Httpd stopped.");
            notifyListeners(stopped);
            worker = null;
        }
    }
    
    void notifyListeners(Status status) {
        for (listener in statusListeners) {
            listener(status);
        }
    }

    addEndpoint(HttpEndpoint endpoint) 
            => httpEndpoints.add(endpoint);
    
    addWebSocketEndpoint(WebSocketBaseEndpoint endpoint) 
            => webSocketHandler.addEndpoint(endpoint);
    
    addListener(void listener(Status status)) 
            => statusListeners.add( listener );
}

