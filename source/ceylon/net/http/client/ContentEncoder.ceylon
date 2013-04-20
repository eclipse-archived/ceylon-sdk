import ceylon.net.http { contentTypeFormUrlEncoded }

by("Matej Lazar")
shared interface ContentEncoder {
    shared formal String encode(Map<String, String> parameters); 
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
    shared actual String encode(Map<String,String> parameters) {
        value builder = StringBuilder();
        variable value first = true;
        for (parameter in parameters) {
            if (first) {
                first = false;
            } else {
                builder.append("&");
            }
            builder.append(parameter.key);
            builder.append("=");
            builder.append(parameter.item);
        }
        return builder.string;
    }
}
