import ceylon.net.httpd { WebEndpointAsync, HttpResponse, HttpCompletionHandler, HttpRequest, WebEndpointConfig }
import ceylon.file { Path, parsePath, File }
import ceylon.io.buffer { ByteBuffer, newByteBuffer }
import ceylon.io { newOpenFile }
shared class StaticFileEndpoint() satisfies WebEndpointAsync {
	
	variable String? basePath := null;
		
	shared actual void init(WebEndpointConfig webEndpointConfig) {
		basePath := webEndpointConfig.parameter("files-dir");
	}
	
	shared actual void service(HttpRequest request, HttpResponse response, HttpCompletionHandler completionHandler) {
		String path = request.relativePath();
		if (exists b = basePath) {
			Path filePath = parsePath("" b "" path "");
			if (is File file = filePath.resource) {
	            //TODO log
	            print("Serving file: " filePath.absolutePath.string "");
	
	            value openFile = newOpenFile(file);
	            
	            try {
	                variable Integer available := file.size;
	                response.addHeader("content-length", "" available "");
	                if (is String cntType = file.contentType) {
						response.addHeader("content-type", cntType);                    
	                }
	                
	                //TODO use org.xnio.channels.Channels.transferBlocking to transfer bytes efficiently between two channels
	                //fails on large files
	                ByteBuffer buffer = newByteBuffer(available);
	//                while (available > 0) {
	                 	value read = openFile.read(buffer);
	//                 	available -= read;
	   	             	response.writeBytes(buffer.bytes());
	//   	             	buffer.flip();
	//             	}
	            }
	            finally {
	                openFile.close();
	            }
	        }
	        else {
	            response.responseStatus(404);
	            //TODO
	            print("file does not exist");
	        }
	    } else {
            response.responseStatus(500);
            //TODO
            print("Missing init param filesPath.");
	    }
		completionHandler.handleComplete();
	}

}