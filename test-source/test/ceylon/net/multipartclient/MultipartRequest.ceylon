import ceylon.net.uri {
    Uri,
	Parameter
}
import ceylon.net.http {
    post,
    Header,
    contentType
}
import ceylon.buffer.charset {
    utf8,
    Charset
}
import ceylon.collection {
	HashSet
}
import ceylon.buffer {
	ByteBuffer
}
import ceylon.net.http.client {
	Request,
	Response
}

class ByteBufferWriter(ByteBuffer byteBuffer, Charset charset) {

    void writeByteToBuffer(ByteBuffer byteBuffer, Byte byte) {
        if (byteBuffer.available < 1) {
            byteBuffer.resize(byteBuffer.limit + 1024, true);
        }
        byteBuffer.put(byte);
    }

    shared ByteBufferWriter writeString(String string) {
        charset.encode(string).each((Byte byte) => writeByteToBuffer(byteBuffer, byte)); 
        return this;
    }

    shared ByteBufferWriter writeByteBuffer(ByteBuffer sourceByteBuffer) {
        sourceByteBuffer.each((Byte byte) => writeByteToBuffer(byteBuffer, byte));
        return this;
    }
}

shared class FilePart(fieldName, fileName, data) {
    shared String fieldName;
    shared String fileName;
    shared ByteBuffer|String data;
}
//TODO add streamming/socket support and move to ceylon.net.http.client
shared class MultipartRequest(uri, parameters, files, headers = empty, charset = utf8) {
    // creates a unique boundary based on time stamp
    String boundary = "===" + system.milliseconds.string + "===";
    
    Uri uri;
    {Header*} headers;
    {Parameter*} parameters;
    {FilePart*} files;

    Charset charset;
    String crLf = "\r\n";
    
    void writeParameter(Parameter parameter, ByteBufferWriter bufferWriter) {
        bufferWriter.writeString("--" + boundary).writeString(crLf);
        bufferWriter.writeString("Content-Disposition: form-data; name=\"" + parameter.name + "\"").writeString(crLf);
        bufferWriter.writeString("Content-Type: text/plain; charset=" + charset.name).writeString(crLf);
        bufferWriter.writeString(crLf);
        bufferWriter.writeString(parameter.val else "").writeString(crLf);
    }
    
    void writeFilePart(FilePart filePart, ByteBufferWriter bufferWriter) {
        bufferWriter.writeString("--" + boundary).writeString(crLf);
        bufferWriter.writeString("Content-Disposition: form-data; name=\"" + filePart.fieldName 
            + "\"; filename=\"" + filePart.fileName + "\"").writeString(crLf);
        bufferWriter.writeString("Content-Type: application/octet-stream").writeString(crLf);
        bufferWriter.writeString("Content-Transfer-Encoding: binary").writeString(crLf);
        bufferWriter.writeString(crLf);
        
        if (is String data = filePart.data) {
            bufferWriter.writeString(data);
        } else if (is ByteBuffer data = filePart.data) {
            bufferWriter.writeByteBuffer(data);
        } else {
            throw Exception("Unsupported data type.");
        }

        bufferWriter.writeString(crLf);
    }

    ByteBuffer multipartDataProvider() {
        ByteBuffer byteBuffer = ByteBuffer.ofSize(1024);
        value bufferWriter = ByteBufferWriter(byteBuffer, charset);
        
        parameters.each((Parameter parameter) => writeParameter(parameter, bufferWriter));

        files.each((FilePart filePart) => writeFilePart(filePart, bufferWriter));

        bufferWriter.writeString(crLf);
        bufferWriter.writeString("--" + boundary + "--");
        bufferWriter.writeString(crLf);

        byteBuffer.flip();
        return byteBuffer;
    }

    shared Response execute() {
        value contentTypeHeaderValue = "multipart/form-data; boundary=" + boundary;
        value contentTypeHeader = contentType(contentTypeHeaderValue);
        
        value multipartHeaders = HashSet<Header>();
        headers.any((Header header) => multipartHeaders.add(header));
        multipartHeaders.add(contentTypeHeader); //Override content type header

        value request = Request{
            uri = uri;
            method = post;
            initialHeaders = headers;
            dataContentType = contentTypeHeaderValue;
            data = multipartDataProvider();
        };

        return request.execute();
    }
}
