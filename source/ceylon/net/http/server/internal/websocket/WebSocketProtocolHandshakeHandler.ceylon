import io.undertow.websockets.core.handler { UtWebSocketProtocolHandshakeHandler = WebSocketProtocolHandshakeHandler }
import io.undertow.server { HttpHandler, HttpServerExchange }

by ("Matej Lazar")
shared class WebSocketProtocolHandshakeHandler(CeylonWebSocketHandler webSocketHandler, HttpHandler next)
        extends UtWebSocketProtocolHandshakeHandler(webSocketHandler, next) {

    shared actual void handleRequest(HttpServerExchange exchange) {
        if (webSocketHandler.endpointExists(exchange.requestPath)) {
            super.handleRequest(exchange);
        } else {
            exchange.responseCode = 404;
            exchange.endExchange();
            return;
        }
    }
}
