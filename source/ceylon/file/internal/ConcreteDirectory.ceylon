import ceylon.file {
    ...
}

import ceylon.collection {
    ArrayList
}

import java.nio.file {
    JPath=Path,
    Files {
        movePath=move,
        newDirectoryStream,
        deletePath=delete,
        getOwner,
        setOwner,
        getAttribute,
        setAttribute
    }
}

class ConcreteDirectory(JPath jpath)
        satisfies Directory {
    
    shared actual Iterable<Path> childPaths(String filter) {
        //TODO: efficient impl
        value sb = ArrayList<Path>();
        value stream = newDirectoryStream(jpath, filter);
        value iter = stream.iterator();
        while (iter.hasNext()) {
            sb.add(ConcretePath(iter.next()));
        }
        stream.close();
        return sb.sequence();
    }
    
    path =>  ConcretePath(jpath); 
    
    linkedResource => this;
    
    children(String filter) =>
           {for (p in childPaths(filter)) 
                 if (is ExistingResource r=p.resource) r};
    
    files(String filter) =>
           {for (p in childPaths(filter))
                 if (is File r=p.resource) r};
    
    childDirectories(String filter) =>
            {for (p in childPaths(filter))
                 if (is Directory r=p.resource) r};
    
    childResource(Path|String subpath) => path.childPath(subpath).resource;
    
    move(Nil target) => ConcreteDirectory( movePath(jpath, asJPath(target.path)) );
    
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    readAttribute(Attribute attribute) 
            => getAttribute(jpath, attributeName(attribute));
    
    writeAttribute(Attribute attribute, Object attributeValue)
            => setAttribute(jpath, attributeName(attribute), attributeValue);
    
    string => jpath.string;
    
    shared actual String owner {
        return getOwner(jpath).name;
    }
    assign owner {
        setOwner(jpath, jprincipal(jpath, owner));
    }
    
}


    
