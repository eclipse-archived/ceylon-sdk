import ceylon.file {
    current,
    Nil,
    File,
    ExistingResource
}

native shared class FileWriter(String path) satisfies Destroyable {
    native shared void write(String text);
    native shared void writeLine(String line);
    native shared actual void destroy(Throwable? error);
}

native ("jvm") shared class FileWriter(String path) satisfies Destroyable {
    File.Overwriter fw;
    value res = current.childPath(path).resource;
    switch(res)
    case(is Nil) {
        fw = res.createFile(true).Overwriter();
    }
    case(is ExistingResource) {
        fw = res.delete().createFile(true).Overwriter();
    }
    
    native ("jvm") shared void write(String text) => fw.write(text);
    native ("jvm") shared void writeLine(String line) => fw.writeLine(line);
    native ("jvm") shared actual void destroy(Throwable? error) => fw.close();
}

native ("js") shared class FileWriter(String path) satisfies Destroyable {
    dynamic fsApi;
    dynamic fd;
    dynamic {
        dynamic pathApi = require("path");
        fsApi = require("fs");
        
        value pathBuilder = StringBuilder();
        value pathSegments = path.split((Character c) => c.string == pathApi.sep).sequence();
        for(pathSegment in pathSegments[0..pathSegments.size-2] ) {
            pathBuilder.append(pathSegment);
            if( !fsApi.existsSync(pathBuilder.string) ) {
                fsApi.mkdirSync(pathBuilder.string);
            }
            pathBuilder.append(pathApi.sep);
        }
        assert(exists pathLastSegment = pathSegments.last);
        pathBuilder.append(pathLastSegment);
        
        fd = fsApi.openSync(pathBuilder.string, "w");
    }
    
    native ("js") shared void write(String text) {
        dynamic {
            fs.writeSync(fd, text);
        }
    }
    native ("js") shared void writeLine(String line) {
        dynamic {
            fs.writeSync(fd, line + operatingSystem.newline);
        }
    }
    native ("js") shared actual void destroy(Throwable? error) {
        dynamic {
            fs.close(fd);
        }
    }
}    
