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

"Endpoint for serving Ceylon modules. _Must_ be attached to an
 [[ceylon.net.http.server::AsynchronousEndpoint]].
 
 For example:
 
     shared void run() { 
        value extraRepo = Collections.singletonList(\"/custom/path/to/modules\");
        value manager = CeylonUtils
            .repoManager()
            .extraUserRepos(extraRepo)
            .buildManager();

        value server = newServer {
            AsynchronousEndpoint {
                path = startsWith(\"/modules\");
                acceptMethod = { get };
                service = serveModule {
                    manager = manager;
                    contextRoot = \"/modules\";
                };
            }
        };
     }"

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

    // req.path == "/modules/ceylon/language/1.2.0/ceylon.language-1.2.0.js"
    // first we strip the context root and the leading slash
    value path = let(p = req.path.spanFrom(contextRoot.size))
                 if (p.startsWith("/")) then p.rest else p;
    
    // path == "ceylon/language/1.2.0/ceylon.language-1.2.0.js"
    value parts = path.split('/'.equals).sequence();
    
    // parts == [ceylon, language, 1.2.0, ceylon.language-1.2.0.js]
    value name = if (parts.size >= 3)
                 then ".".join(parts[0..parts.size-3])
                 else null;
    
    // name == "ceylon.language"
    if (exists name,
        exists version = parts[parts.size - 2],
        exists fileName = parts.last,
        exists file = findArtifactPath(manager, name, version, fileName)) {
        
        serveStaticFile("", (req) => file, options, onSuccess, onError, headers)
            (req, resp, complete);        
    } else {
        resp.responseStatus = 404;
        resp.writeString("404 - Not found");
    }
}

String? findArtifactPath(RepositoryManager manager, String name,
    String version, String file) {
    
    for (suf in ArtifactContext.allSuffixes().array.coalesced) {
        if (file.endsWith(suf.string)) {
            value context = ArtifactContext(name, version, suf.string);
            if (exists artifact = manager.getArtifact(context),
                artifact.\iexists(),
                artifact.file) {
                
                return artifact.absolutePath;
            }
        }
    }
    
    return null;
}