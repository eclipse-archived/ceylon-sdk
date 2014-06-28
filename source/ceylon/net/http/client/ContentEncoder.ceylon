import ceylon.net.http { contentTypeFormUrlEncoded }
import ceylon.net.uri { Parameter }
import ceylon.collection { StringBuilder }

by("Matej Lazar")
shared interface ContentEncoder {
    shared formal String encode(Map<String, List<Parameter>> parameters); 
}

ContentEncoder createEncoder(String contentType) {
    if (contentType.startsWith(contentTypeFormUrlEncoded)) {
        return UrlEncoder(); 
    } else {
        //TODO implement other encoders
        throw Exception("Could not find encoder for content-type: ``contentType``");
    }
}

class UrlEncoder() satisfies ContentEncoder {
    shared actual String encode(Map<String, List<Parameter>> parameters) {
        value builder = StringBuilder();
        variable value first = true;
        for (params in parameters) {
            for (param in params.item) {
                if (first) {
                    first = false;
                } else {
                    builder.append("&");
                }
                builder.append(param.string);
            }
        }
        return builder.string;
    }
}
