doc "Parses a raw percent-encoded path parameter"
shared Parameter parseParameter(String part){
    Integer? sep = part.firstCharacterOccurrence(`=`);
    if(exists sep){
        return Parameter(decodePercentEncoded(part.initial(sep)), 
            decodePercentEncoded(part.terminal(part.size - sep - 1)));
    }else{
        return Parameter(decodePercentEncoded(part));
    }
}

doc "Parses a URI"
throws(InvalidURIException, "If the URI is invalid")
shared URI parseURI(String uri){
    variable String? scheme = null;
    Authority authority = Authority(null, null, null, null);
    Path path = Path();
    Query query = Query();
    variable String? fragment = null;
    
    String parseScheme(String uri){
        Integer? sep = uri.firstOccurrence(":");
        if(exists sep){
            if(sep > 0){
                scheme = uri.segment(0, sep);
                return uri[sep+1...];
            }
        }
        // no scheme, it must be relative
        return uri;
    }

    void parseUserInfo(String userInfo) {
        Integer? sep = userInfo.firstCharacterOccurrence(`:`);
        if(exists sep){
            authority.user = decodePercentEncoded(userInfo.segment(0, sep));
            authority.password = decodePercentEncoded(userInfo[sep+1...]);
        }else{
            authority.user = decodePercentEncoded(userInfo);
            authority.password = null;
        }
    }

    void parseHostAndPort(String hostAndPort) {
        String? portString;
        if(hostAndPort.startsWith("[")){
            authority.ipLiteral = true;
            Integer? end = hostAndPort.firstCharacterOccurrence(`]`);
            if(exists end){
                // eat the delimiters
                authority.host = hostAndPort.segment(1, end-1);
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
            authority.ipLiteral = false;
            Integer? sep = hostAndPort.lastCharacterOccurrence(`:`);
            if(exists sep){
                authority.host = decodePercentEncoded(hostAndPort.segment(0, sep));
                portString = hostAndPort[sep+1...];
            }else{
                authority.host = decodePercentEncoded(hostAndPort);
                portString = null;
            }
        }
        if(exists portString){
            authority.port = parseInteger(portString);
            if(exists Integer port = authority.port){
                if(port < 0){
                    throw InvalidURIException("Invalid port number: "+portString);
                }
            }else{
                throw InvalidURIException("Invalid port number: "+portString);
            }
        }else{
            authority.port = null;
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
            authority = part.segment(0, sep);
            remains = part[sep...];
        }else{
            // no path part
            authority = part;
            remains = "";
        }
        Integer? userInfoSep = authority.firstCharacterOccurrence(`@`);
        String hostAndPort;
        if(exists userInfoSep){
            parseUserInfo(authority.segment(0, userInfoSep));
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
            pathPart = uri.segment(0, sep);
            remains = uri[sep...];
        }else{
            // no query/fragment part
            pathPart = uri;
            remains = "";
        }
        if(!pathPart.empty){
            variable Boolean first = true;
            for(String part in pathPart.split((Character ch) => ch == `/`, true, false)){
                if(first && part.empty){
                    path.absolute = true;
                    first = false;
                    continue;
                }
                first = false;
                path.addRawSegment(part);
            }
        }
        
        return remains;
    }

    void parseQueryPart(String queryPart) {
        for(String part in queryPart.split((Character ch) => ch == `&`, true, false)){
            query.addRaw(part);
        }
    }

    String parseQuery(String uri){
        Character? c = uri[0];
        if(exists c){
            if(c == `?`){
                // we have a query part
                Integer end = uri.firstCharacterOccurrence(`#`) else uri.size;
                parseQueryPart(uri.segment(1, end-1));
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
                fragment = decodePercentEncoded(uri[1...]);
                return "";
            }
        }
        // no query/fragment part
        return uri;
    }
    
    void parseURI(String uri) {
        variable String remains = parseScheme(uri);
        remains = parseAuthority(remains);
        remains = parsePath(remains);
        remains = parseQuery(remains);
        remains = parseFragment(remains);
    }

    parseURI(uri);
    return URI(scheme, authority, path, query, fragment);
}