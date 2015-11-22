import ceylon.net.uri {
    Uri,
	Parameter
}
import ceylon.net.http {
    post,
    Header,
    contentType
}
import ceylon.io.charset {
    utf8,
    Charset
}
import ceylon.collection {
	HashSet
}
import ceylon.io.buffer {
	ByteBuffer,
	newByteBuffer
}
import ceylon.net.http.client {
	Request,
	Response
}

shared class ByteBufferWritter(ByteBuffer byteBuffer, Charset charset) {

    void writeByteToBuffer(ByteBuffer byteBuffer, Byte byte) {
        if (byteBuffer.available < 1) {
            byteBuffer.resize(byteBuffer.limit + 1024, true);
        }
        byteBuffer.put(byte);
    }

    shared ByteBufferWritter writeString(String string) {
        charset.encode(string).each((Byte byte) => writeByteToBuffer(byteBuffer, byte)); 
        return this;
    }

    shared ByteBufferWritter writeByteBuffer(ByteBuffer sourceByteBuffer) {
        sourceByteBuffer.each((Byte byte) => writeByteToBuffer(byteBuffer, byte));
        return this;
    }
}

shared class FilePart(fieldName, fileName, data) {
    shared String fieldName;
    shared String fileName;
    shared ByteBuffer|String data;
}

shared class MultipartRequest(uri, parameters, files, headers = empty, charset = utf8) {
    // creates a unique boundary based on time stamp
    String boundary = "===" + system.milliseconds.string + "===";
    
    Uri uri;
    {Header*} headers;
    {Parameter*} parameters;
    {FilePart*} files;

    Charset charset;
    String crLf = "\r\n";
    
    void writeParameter(Parameter parameter, ByteBufferWritter bufferWritter) {
        bufferWritter.writeString("--" + boundary).writeString(crLf);
        bufferWritter.writeString("Content-Disposition: form-data; name=\"" + parameter.name + "\"").writeString(crLf);
        bufferWritter.writeString("Content-Type: text/plain; charset=" + charset.name).writeString(crLf);
        bufferWritter.writeString(crLf);
        bufferWritter.writeString(parameter.val else "").writeString(crLf);
    }
    
    void writeFilePart(FilePart filePart, ByteBufferWritter bufferWritter) {
        bufferWritter.writeString("--" + boundary).writeString(crLf);
        bufferWritter.writeString("Content-Disposition: form-data; name=\"" + filePart.fieldName 
            + "\"; filename=\"" + filePart.fileName + "\"").writeString(crLf);
        bufferWritter.writeString("Content-Type: application/octet-stream").writeString(crLf);
        bufferWritter.writeString("Content-Transfer-Encoding: binary").writeString(crLf);
        bufferWritter.writeString(crLf);
        
        if (is String data = filePart.data) {
            bufferWritter.writeString(data);
        } else if (is ByteBuffer data = filePart.data) {
            bufferWritter.writeByteBuffer(data);
        } else {
            throw Exception("Unsupported data type.");
        }

        bufferWritter.writeString(crLf);
    }

    ByteBuffer multipartDataProvider() {
        ByteBuffer byteBuffer = newByteBuffer(1024);
        value bufferWritter = ByteBufferWritter(byteBuffer, charset);
        
        parameters.each((Parameter parameter) => writeParameter(parameter, bufferWritter));

        files.each((FilePart filePart) => writeFilePart(filePart, bufferWritter));

        bufferWritter.writeString(crLf);
        bufferWritter.writeString("--" + boundary + "--");
        bufferWritter.writeString(crLf);

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
