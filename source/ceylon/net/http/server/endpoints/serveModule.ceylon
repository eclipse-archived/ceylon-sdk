import ceylon.net.http.server {
    Request,
    Response,
    ServerException
}

import com.redhat.ceylon.cmr.api {
    RepositoryManager,
    ArtifactContext
}
import ceylon.net.http {
    Header
}
import ceylon.file {
    File
}
import ceylon.interop.java {
    javaString
}

"""Service function for sending Ceylon modules to the client. _Must_ be attached
   to an [[ceylon.net.http.server::AsynchronousEndpoint]].
   
   For example:
   
       shared void run() { 
          value extraRepo = Collections.singletonList("/custom/path/to/modules");
          value manager = CeylonUtils
              .repoManager()
              .extraUserRepos(extraRepo)
              .buildManager();
   
          value server = newServer {
              AsynchronousEndpoint {
                  path = startsWith("/modules");
                  acceptMethod = { get };
                  service = serveModule {
                      manager = manager;
                      contextRoot = "/modules";
                  };
              }
          };
       }"""
by("Bastien Jansen", "Tako Schotanus")
shared void serveModule(
            "The repository manager used to look for artifacts"
            RepositoryManager manager,
            "The context root associated to the endpoint, e.g `/modules`."
            String contextRoot,
            Options options = Options(),
            void onSuccess(Request r) => noop(r),
            void onError(ServerException e, Request r) => noop(e,r),
            {Header*} headers(File file) => {})
        (Request req, Response resp, void complete()) {

    // Make sure the root path ends with a slash
    value root = if (contextRoot.endsWith("/")) then contextRoot else contextRoot + "/";
    
    // req.path == "/modules/ceylon/language/1.2.0/ceylon.language-1.2.0.js"
    // first we strip the context root and the leading slash
    value path = req.path.spanFrom(root.size);
    
    // path == "ceylon/language/1.2.0/ceylon.language-1.2.0.js"
    value parts = path.split('/'.equals).sequence();
    
    // parts == [ceylon, language, 1.2.0, ceylon.language-1.2.0.js]
    value name = if (parts.size >= 3)
                 then ".".join(parts[0..parts.size-3])
                 else null;
 
    void notFound() {
        resp.responseStatus = 404;
        resp.writeString("404 - Not found");
    }
    
    // name == "ceylon.language"
    if (req.path.startsWith(contextRoot),
            exists name,
            exists version = parts[parts.size - 2],
            exists fileName = parts.last) {
        value suffix = fileName.spanFrom(name.size + version.size + 1);
        if (fileName == name + "-" + version + suffix,
                exists file = findArtifactPath(manager, name, version, suffix)) {
            serveStaticFile("", (req) => file, options, onSuccess, onError, headers)
                (req, resp, complete);
        } else {
            notFound();
        }
    } else {
        notFound();
    }
}

String? findArtifactPath(RepositoryManager manager,
        String name,
        String version,
        String suffix) {
    
    if (ArtifactContext.allSuffixes().array.contains(javaString(suffix))) {
        value context = ArtifactContext(name, version, suffix);
        if (exists artifact = manager.getArtifact(context),
                artifact.\iexists(),
                artifact.file) {
            return artifact.absolutePath;
        }
    }
    
    return null;
}