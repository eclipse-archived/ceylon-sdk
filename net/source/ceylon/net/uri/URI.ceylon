import java.lang{ JInteger = Integer }
import ceylon.net.iop { eq }
import ceylon.net.http { Request }

doc "The URI class. See http://tools.ietf.org/html/rfc3986 for specifications."
by "Stéphane Épardaud"
shared class URI(String? uri = null){
    
    doc "The optional URI scheme: `http`, `https`, `mailto`…"
    shared variable String? scheme := null;
    
    doc "The optional Authority part (contains user, password, host and port)"
    shared variable Authority authority := Authority();
    
    doc "The optional Path part"
    shared variable Path path := Path();
    
    doc "The optional query part"
    shared variable Query query := Query();
    
    doc "The optional fragment (hash) part"
    shared variable String? fragment := null;

    String parseScheme(String uri){
        Integer? sep = uri.firstOccurrence(":");
        if(exists sep){
            if(sep > 0){
                scheme := uri[0..sep-1];
                return uri[sep+1...];
            }
        }
        // no scheme, it must be relative
        return uri;
    }

    void parseUserInfo(String userInfo) {
        Integer? sep = userInfo.firstCharacterOccurrence(`:`);
        if(exists sep){
            authority.user := decodePercentEncoded(userInfo[0..sep-1]);
            authority.password := decodePercentEncoded(userInfo[sep+1...]);
        }else{
            authority.user := decodePercentEncoded(userInfo);
            authority.password := null;
        }
    }

    void parseHostAndPort(String hostAndPort) {
        String? portString;
        if(hostAndPort.startsWith("[")){
            authority.ipLiteral := true;
            Integer? end = hostAndPort.firstCharacterOccurrence(`]`);
            if(exists end){
                // eat the delimiters
                authority.host := hostAndPort[1..end-1];
                String rest = hostAndPort[end+1...];
                if(rest.startsWith(":")){
                    portString = rest[1...];
                }else{
                    portString = null;
                }
            }else{
                throw InvalidURIException("Invalid IP literal: " + hostAndPort);
            }
        }else{
            authority.ipLiteral := false;
            Integer? sep = hostAndPort.lastCharacterOccurrence(`:`);
            if(exists sep){
                authority.host := decodePercentEncoded(hostAndPort[0..sep-1]);
                portString = hostAndPort[sep+1...];
            }else{
                authority.host := decodePercentEncoded(hostAndPort);
                portString = null;
            }
        }
        if(exists portString){
            authority.port := parseInteger(portString);
            if(exists Integer port = authority.port){
                if(port < 0){
                    throw InvalidURIException("Invalid port number: "+portString);
                }
            }else{
                throw InvalidURIException("Invalid port number: "+portString);
            }
        }else{
            authority.port := null;
        }
    }
    
    String parseAuthority(String uri){
        if(!uri.startsWith("//")){
            return uri;
        }
        // eat the two slashes
        String part = uri[2...];
        Integer? sep = part.firstCharacterOccurrence(`/`) 
            else part.firstCharacterOccurrence(`?`)
            else part.firstCharacterOccurrence(`#`);
        String authority;
        String remains;
        if(exists sep){
            authority = part[0..sep-1];
            remains = part[sep...];
        }else{
            // no path part
            authority = part;
            remains = "";
        }
        Integer? userInfoSep = authority.firstCharacterOccurrence(`@`);
        String hostAndPort;
        if(exists userInfoSep){
            parseUserInfo(authority[0..userInfoSep-1]);
            hostAndPort = authority[userInfoSep+1...]; 
        }else{
            hostAndPort = authority;
        }
        parseHostAndPort(hostAndPort);
        return remains;
    }

    String parsePath(String uri){
        Integer? sep = uri.firstCharacterOccurrence(`?`) else uri.firstCharacterOccurrence(`#`);
        String pathPart;
        String remains;
        if(exists sep){
            pathPart = uri[0..sep-1];
            remains = uri[sep...];
        }else{
            // no query/fragment part
            pathPart = uri;
            remains = "";
        }
        if(nonempty pathPart){
            Path p = Path();
            variable Boolean first := true;
            for(String part in pathPart.split("/", true, false)){
                if(first && part.empty){
                    p.absolute := true;
                    first := false;
                    continue;
                }
                first := false;
                p.addRawSegment(part);
            }
            path := p;
        }
        
        return remains;
    }

    void parseQueryPart(String queryPart) {
        Query q = Query();
        query := q;
        for(String part in queryPart.split("&", true, false)){
            q.addRaw(part);
        }
    }

    String parseQuery(String uri){
        Character? c = uri[0];
        if(exists c){
            if(c == `?`){
                // we have a query part
                Integer end = uri.firstCharacterOccurrence(`#`) else uri.size;
                parseQueryPart(uri[1..end-1]);
                return uri[end...];
            }
        }
        // no query/fragment part
        return uri;
    }

    String parseFragment(String uri){
        Character? c = uri[0];
        if(exists c){
            if(c == `#`){
                // we have a fragment part
                fragment := decodePercentEncoded(uri[1...]);
                return "";
            }
        }
        // no query/fragment part
        return uri;
    }
    
    void parseURI(String uri) {
        variable String remains := parseScheme(uri);
        remains := parseAuthority(remains);
        remains := parsePath(remains);
        remains := parseQuery(remains);
        remains := parseFragment(remains);
    }

    if(exists uri){
        parseURI(uri);
    }

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
