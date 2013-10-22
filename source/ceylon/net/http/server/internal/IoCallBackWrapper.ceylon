import ceylon.net.http.server { HttpException=Exception, SendCallback, Response }
import io.undertow.io { IoCallback, Sender }
import io.undertow.server { HttpServerExchange }
import java.io { IOException }

by("Matej Lazar")
shared class IoCallbackWrapper(SendCallback sendCallback, Response response) 
        satisfies IoCallback {
    
    shared actual void onComplete(HttpServerExchange? httpServerExchange, Sender? sender) {
        sendCallback.onCompletion(response);
    }

    shared actual void onException(HttpServerExchange? httpServerExchange, Sender? sender, IOException? iOException) {
        if (exists iOException) {
            sendCallback.onError(response, HttpException("Http error.", iOException));
        } else {
            sendCallback.onError(response, HttpException("Http error, no details available."));
        }
    }
}
