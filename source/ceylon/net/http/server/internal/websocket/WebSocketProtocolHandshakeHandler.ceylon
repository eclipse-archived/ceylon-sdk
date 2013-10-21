import io.undertow.websockets.core.handler { UtWebSocketProtocolHandshakeHandler = WebSocketProtocolHandshakeHandler }
import io.undertow.server { HttpHandler, HttpServerExchange }
import io.undertow.websockets.spi { AsyncWebSocketHttpServerExchange }
import io.undertow.websockets.core.protocol { Handshake }
import io.undertow.websockets.core.protocol.version00 { Hybi00Handshake }
import io.undertow.websockets.core.protocol.version07 { Hybi07Handshake }
import io.undertow.websockets.core.protocol.version08 { Hybi08Handshake }
import io.undertow.websockets.core.protocol.version13 { Hybi13Handshake }
import ceylon.collection { HashSet }
import io.undertow.util { Headers { headerUpgrade = UPGRADE } }

by ("Matej Lazar")
shared class WebSocketProtocolHandshakeHandler(CeylonWebSocketHandler webSocketHandler, HttpHandler next)
        extends UtWebSocketProtocolHandshakeHandler(webSocketHandler, next) {

    Set<Handshake> handshakes = HashSet({
        Hybi13Handshake(),
        Hybi08Handshake(),
        Hybi07Handshake(),
        Hybi00Handshake()
    });

    shared actual void handleRequest(HttpServerExchange exchange) {
        //if no upgrade header it is not a valid WS handshake
        if (!exchange.requestHeaders.contains(headerUpgrade)) {
            next.handleRequest(exchange);
            return;
        }
    
        AsyncWebSocketHttpServerExchange facade = AsyncWebSocketHttpServerExchange(exchange);
        variable Handshake? handshaker = null;
        for (Handshake method in handshakes) {
            if (method.matches(facade)) {
                handshaker = method;
                break;
            }
        }

        if (exists h = handshaker) {
            handleWebSocketRequest(exchange, facade, h);
        } else {
            next.handleRequest(exchange);
            return;
        }
    }
    
    void handleWebSocketRequest(HttpServerExchange exchange, AsyncWebSocketHttpServerExchange facade, Handshake h) {
        if (webSocketHandler.endpointExists(exchange.requestPath)) {
            h.handshake(facade, webSocketHandler);
        } else {
            exchange.responseCode = 404;
            exchange.endExchange();
            return;
        }
    }

}
