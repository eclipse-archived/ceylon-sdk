import io.undertow.websockets.spi { WebSocketHttpExchange }
import ceylon.collection { LinkedList, MutableList }
import ceylon.net.http.server.websocket { 
    WebSocketEndpoint, WebSocketFragmentedEndpoint, WebSocketChannel, WebSocketBaseEndpoint }
import io.undertow.websockets.core.handler { WebSocketConnectionCallback }
import io.undertow.websockets.core { UtWebSocketChannel = WebSocketChannel }
import org.xnio { IoUtils { safeClose }}

by("Matej Lazar")
shared class CeylonWebSocketHandler() satisfies WebSocketConnectionCallback {

    MutableList<WebSocketEndpoint> endpointList = LinkedList<WebSocketEndpoint>();

    shared List<WebSocketEndpoint> endpoints => endpointList;

    shared void addEndpoint(WebSocketEndpoint endpoint) {
        endpointList.add(endpoint);
    }

    shared actual void onConnect(WebSocketHttpExchange exchange, UtWebSocketChannel channel) {
        value webSocketChannel = DefaultWebSocketChannel(exchange, channel);

        WebSocketBaseEndpoint? endpoint = getEndpointMatchingPath(webSocketChannel.requestPath);
        if (exists endpoint) {
            try {
                endpoint.onOpen(webSocketChannel);
                
                channel.receiveSetter.set(frameHandler(endpoint, webSocketChannel));
                
                channel.resumeReceives();
            } catch (Exception e) {
                safeClose(channel);
            }
        } else {
            //TODO warning no endpoint for requested URI
            //response 404 ?
            print("WARN: No endpoint for requested path.");
        }
    }

    CeylonWebSocketFrameHandler|CeylonWebSocketFragmentedFrameHandler frameHandler(
            WebSocketBaseEndpoint endpoint,
            WebSocketChannel webSocketChannel) {
        switch (endpoint)
        case (is WebSocketEndpoint) {
            return CeylonWebSocketFrameHandler(endpoint, webSocketChannel);
        }
        case (is WebSocketFragmentedEndpoint) {
            return CeylonWebSocketFragmentedFrameHandler(endpoint, webSocketChannel);
        } else {
            //TODO remove, as all cases are handled
            throw;
        }
    }

    //TODO move to abstract
    WebSocketEndpoint|Null getEndpointMatchingPath(String requestPath) {
        for (endpoint in endpoints) {
            if (endpoint.path.matches(requestPath)) {
                return endpoint;
            }
        }
        return null;
    }
}
