import ceylon.file { ... }

import java.nio.file { JPath=Path, 
                       Files { movePath=move, 
                               newDirectoryStream,
                               deletePath=delete,
                               getOwner, setOwner } }
import java.nio.file.attribute { UserPrincipalNotFoundException }

class ConcreteDirectory(JPath jpath)
        satisfies Directory {
    shared actual Iterable<Path> childPaths(String filter) {
        //TODO: efficient impl
        value sb = SequenceBuilder<Path>();
        value stream = newDirectoryStream(jpath, filter);
        value iter = stream.iterator();
        while (iter.hasNext()) {
            sb.append(ConcretePath(iter.next()));
        }
        stream.close();
        return sb.sequence;
    }
    shared actual Iterable<ExistingResource> children(String filter) {
        return {for (p in childPaths(filter)) 
                 if (is ExistingResource r=p.resource) r};
    }
    shared actual Iterable<File> files(String filter) {
        return {for (p in childPaths(filter))
                 if (is File r=p.resource) r};
    }
    shared actual Iterable<Directory> childDirectories(String filter) {
        return {for (p in childPaths(filter))
                 if (is Directory r=p.resource) r};
    }
    shared actual Resource childResource(Path|String subpath) {
        return path.childPath(subpath).resource;
    }
    shared actual Directory move(Nil target) {
        return ConcreteDirectory( movePath(jpath, asJPath(target.path)) );
    }
    shared actual Path path { 
        return ConcretePath(jpath); 
    }
    shared actual File|Directory|Nil linkedResource {
        return this;
    }
    shared actual String string {
        return jpath.string;
    }
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    function jprincipal(String name) {
        value upls = jpath.fileSystem.userPrincipalLookupService;
        try {
            return upls.lookupPrincipalByName(name);
        }
        catch (UserPrincipalNotFoundException e) {
            throw NoSuchPrincipalException(name, e);
        }
    }
    
    shared actual String owner {
        return getOwner(jpath).name;
    }
    assign owner {
        setOwner(jpath, jprincipal(owner));
    }
}
