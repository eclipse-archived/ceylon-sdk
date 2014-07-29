import ceylon.collection {
    StringBuilder
}
import ceylon.net.http.client {
    Request
}
import ceylon.net.iop {
    eq
}

"The URI class. See [RCF 3986][rfc3986] for specifications.
 
 [rfc3986]: http://tools.ietf.org/html/rfc3986"
by("Stéphane Épardaud")
shared class Uri(scheme = null, 
    authority = Authority(), 
    path = Path(), 
    query = Query(), 
    fragment = null){
    
    "The optional URI scheme: `http`, `https`, `mailto`…"
    shared variable String? scheme;
    
    "The optional Authority part (contains user, password, 
     host and port)"
    shared variable Authority authority;
    
    "The optional Path part"
    shared variable Path path;
    
    "The optional query part"
    shared variable Query query;
    
    "The optional fragment (hash) part"
    shared variable String? fragment;

    "Returns true if this is a relative URI"
    shared Boolean relative {
        return !scheme exists;
    }

    "Returns the path as an externalisable (percent-encoded) 
     string representation. Can be an empty string." 
    shared String pathPart {
        return path.string;
    }
    
    "Returns the query as an externalisable (percent-encoded) 
     string representation. Can be null." 
    shared String? queryPart {
        return query.specified then query.string;
    }
    
    String toRepresentation(Boolean human) {
        StringBuilder b = StringBuilder();
        if(exists String scheme = scheme){
            b.append(scheme);
            b.append(":");
        }
        if(authority.specified){
            b.append("//");
            b.append(authority.toRepresentation(human));
        }
        b.append(path.toRepresentation(human));
        if(query.specified){
            b.append("?");
            b.append(query.toRepresentation(human));
        }
        if(exists String fragment = fragment){
            b.append("#");
            b.append(human then fragment else percentEncoder.encodeFragment(fragment));
        }
        return b.string;
    }

    "Returns an externalisable (percent-encoded) 
     representation of this URI."
    shared actual String string {
        return toRepresentation(false);
    }
    
    "Returns a human (not parseable) representation of this 
     URI."
    shared String humanRepresentation {
        return toRepresentation(true);
    }
    
    "Returns true if the given object is the same as this 
     object"
    shared actual Boolean equals(Object that) {
        if(is Uri that){
            if(this === that){
                return true;
            }
            return eq(scheme, that.scheme)
                && authority == that.authority
                && path == that.path
                && query == that.query
                && eq(fragment, that.fragment); 
        }
        return false;
    }
    
    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + (scheme?.hash else 0);
        hash = 31*hash + authority.hash;
        hash = 31*hash + path.hash;
        hash = 31*hash + query.hash;
        hash = 31*hash + (fragment?.hash else 0);
        return hash;
    }
    
    "Returns a GET HTTP request"
    shared Request get(){
        return Request(this);
    }
}
