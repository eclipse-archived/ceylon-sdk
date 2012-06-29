import ceylon.net.iop { eq }
import ceylon.net.http { Request }

doc "The URI class. See http://tools.ietf.org/html/rfc3986 for specifications."
by "Stéphane Épardaud"
shared class URI(String? _scheme, Authority _authority, Path _path, Query _query, String? _fragment){
    
    doc "The optional URI scheme: `http`, `https`, `mailto`…"
    shared variable String? scheme := _scheme;
    
    doc "The optional Authority part (contains user, password, host and port)"
    shared variable Authority authority := _authority;
    
    doc "The optional Path part"
    shared variable Path path := _path;
    
    doc "The optional query part"
    shared variable Query query := _query;
    
    doc "The optional fragment (hash) part"
    shared variable String? fragment := _fragment;

    doc "Returns true if this is a relative URI"
    shared Boolean relative {
        return !exists scheme;
    }

    doc "Returns the path as an externalisable (percent-encoded) string representation. Can be an empty string." 
    shared String pathPart {
        return path.string;
    }
    
    doc "Returns the query as an externalisable (percent-encoded) string representation. Can be null." 
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

    doc "Returns an externalisable (percent-encoded) representation of this URI."
    shared actual String string {
        return toRepresentation(false);
    }
    
    doc "Returns a human (not parseable) representation of this URI."
    shared String humanRepresentation {
        return toRepresentation(true);
    }
    
    doc "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is URI that){
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
    
    doc "Returns a GET HTTP request"
    shared Request get(){
        return Request(this);
    }
}
