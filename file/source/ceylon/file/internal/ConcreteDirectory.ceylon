import ceylon.file { Resource, File, Nil, Directory, Path }

import java.nio.file { JPath=Path, Files { deletePath=delete, movePath=move, 
                                           newDirectoryStream } }

class ConcreteDirectory(JPath jpath)
        extends ConcreteExistingResource(jpath) 
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
    shared actual Iterable<File|Directory> children(String filter) {
        return elements { for (p in childPaths(filter)) 
                 if (is File|Directory r=p.resource) r };
    }
    shared actual Iterable<File> files(String filter) {
        return elements { for (p in childPaths(filter))
                 if (is File r=p.resource) r };
    }
    shared actual Iterable<Directory> childDirectories(String filter) {
        return elements { for (p in childPaths(filter))
                 if (is Directory r=p.resource) r };
    }
    shared actual Resource childResource(Path|String subpath) {
        return path.childPath(subpath).resource;
    }
    shared actual Directory move(Nil target) {
        return ConcreteDirectory( movePath(jpath, asJPath(target.path)) );
    }
}