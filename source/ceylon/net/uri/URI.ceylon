import ceylon.net.iop { eq }
import ceylon.net.http { Request }

doc "The URI class. See http://tools.ietf.org/html/rfc3986 for specifications."
by ("Stéphane Épardaud", "Matej Lazar")
shared class URI(scheme = null, authority = Authority(), path = Path(), query = Query(), fragment = null){
    
    doc "The optional URI scheme: `http`, `https`, `mailto`…"
    shared String? scheme;
    
    doc "The optional Authority part (contains user, password, host and port)"
    shared Authority authority;
    
    doc "The optional Path part"
    shared Path path;
    
    doc "The optional query part"
    shared Query query;
    
    doc "The optional fragment (hash) part"
    shared String? fragment;

    doc "Returns true if this is a relative URI"
    shared Boolean relative {
        return !scheme exists;
    }

    doc "Returns the path as an externalisable (percent-encoded) string representation. Can be an empty string." 
    shared String pathPart {
        return path.string;
    }
    
    doc "Returns the query as an externalisable (percent-encoded) string representation. Can be null." 
    shared String? queryPart {
        return query.specified then query.string;
    }
    
    doc "Returns absolute URI by applying relativeURI to this URI.
         If relativeURI is absolute, relativeURI is returned."
    shared URI resolve(URI relativeURI) {
        if (!relativeURI.relative) {
            return relativeURI;
        }
        
        if (relativeURI.authority.specified) {
            return URI(scheme, relativeURI.authority, relativeURI.path.noDotSegments, relativeURI.query, relativeURI.fragment);
        }

        if (relativeURI.path.specified) {
            if (relativeURI.path.absolute) {
                return URI(scheme, authority, relativeURI.path.noDotSegments, relativeURI.query, relativeURI.fragment);
            } else {
                return URI(scheme, authority, path.resolve(relativeURI.path), relativeURI.query, relativeURI.fragment);
            }
        }

        if (relativeURI.query.specified) {
            return URI(scheme, authority, path.noDotSegments, relativeURI.query, relativeURI.fragment);
        } else {
            return URI(scheme, authority, path.noDotSegments, query, relativeURI.fragment);
        }
    }
    
    doc "Truncate given base from absolute URI.
         If this URI is relative, this is returned."
    shared URI relativePart(URI base) {
        if (relative) {
            return this;
        }
        
        if (base.relative) {
            throw InvalidURIException("Base URI must be absolute.");
        }
        
        if (base.path.specified) {
            return URI(null, Authority(), path.relativePart(base.path), query, fragment);
        }
        if (base.authority.specified) {
            return URI(null, base.authority, path.noDotSegments, query, fragment);
        }
        return URI(null, authority, path.noDotSegments, query, fragment);
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
