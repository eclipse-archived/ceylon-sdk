import ceylon.net.http.server { HttpException=ServerException }
import io.undertow.io { IoCallback, Sender }
import io.undertow.server { HttpServerExchange }
import java.io { IOException }

by("Matej Lazar")
shared class IoCallbackWrapper(
            Callable<Anything, []> onCompletion,
            Callable<Anything, [HttpException]>? onError)
        satisfies IoCallback {

    shared actual void onComplete(HttpServerExchange? httpServerExchange, Sender? sender) 
            => onCompletion();

    shared actual void onException(HttpServerExchange? httpServerExchange, Sender? sender, IOException? iOException) {
        if (exists onError) {
            if (exists iOException) {
                onError(HttpException("Http error.", iOException));
            } else {
                onError(HttpException("Http error, no details available."));
            }
        }
    }
}
