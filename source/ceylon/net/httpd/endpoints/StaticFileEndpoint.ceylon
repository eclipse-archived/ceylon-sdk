import ceylon.net.httpd { WebEndpointAsync, HttpResponse, HttpCompletionHandler, HttpRequest, WebEndpointConfig, HttpdInternalException }
import ceylon.file { Path, File, parsePath }
import ceylon.io.buffer { ByteBuffer, newByteBuffer }
import ceylon.io { newOpenFile }


by "Matej Lazar"
shared class StaticFileEndpoint() satisfies WebEndpointAsync {
	
	//root dir of external (not from car) location
	variable String? externalPath = null;

	variable String carPath = "static";

	variable String? basePath = null;
		
	shared actual void init(WebEndpointConfig webEndpointConfig) {
		externalPath = webEndpointConfig.attribute("files-dir");
		
		if (exists c = webEndpointConfig.attribute("car-static-dir")) {
			carPath = c;	
		}
		
		if (exists ext = externalPath) {
			basePath = ext; 
		} else {
			basePath = carPath;
		}
	}
	
	shared actual void service(HttpRequest request, HttpResponse response, HttpCompletionHandler completionHandler) {
		String path = request.relativePath();

		if (exists b = basePath) {
			//TODO serve files from car
			Path filePath = parsePath(b + path);
			if (is File file = filePath.resource) {
	            //TODO log
	            print("Serving file: " filePath.absolutePath.string "");
	
	            value openFile = newOpenFile(file);
	            
	            try {
	                variable Integer available = file.size;
	                response.addHeader("content-length", "" available "");
	                if (is String cntType = file.contentType) {
						response.addHeader("content-type", cntType);                    
	                }
	                
	                //TODO transfer bytes efficiently between two channels. Use org.xnio.channels.Channels.transferBlocking
	                //TODO fails on large files, XNIO bug test with new version
	                ByteBuffer buffer = newByteBuffer(available);
	                //while (available > 0) {
	                 	value read = openFile.read(buffer);
	                 	//available -= read;
	   	             	response.writeBytes(buffer.bytes());
	   	             	//buffer.flip();
	             	//}
	            }
	            finally {
	                openFile.close();
	            }
	        }
	        else {
	            response.responseStatus(404);
	            //TODO log
	            print("file does not exist");
	        }
	    } else {
			throw HttpdInternalException("Cannot determine files path.");
	    }
		completionHandler.handleComplete();
	}
}