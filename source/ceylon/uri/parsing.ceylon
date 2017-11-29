/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Parses a raw percent-encoded path parameter"
shared Parameter parseParameter(String part) {
    Integer? sep = part.firstOccurrence('=');
    if(exists sep) {
        return Parameter(decodePercentEncoded(part.initial(sep)),
            decodePercentEncoded(part.terminal(part.size - sep - 1)));
    }else{
        return Parameter(decodePercentEncoded(part));
    }
}

Authority defaultAuthority = Authority();
Query defaultQuery = Query();
Path defaultPath = Path();

"Parses a URI"
throws(`class InvalidUriException`,
    "If the URI is invalid")
shared Uri parse(String uri) {
    variable String? scheme = null;

    variable String? authorityUser = null;
    variable String? authorityPassword = null;
    variable String? authorityHost = null;
    variable Integer? authorityPort = null;
    variable Boolean authorityIPLiteral = false;

    variable Path path = defaultPath;
    variable Query query = defaultQuery;
    variable String? fragment = null;

    String parseScheme(String uri) {
        Integer? sep = uri.firstInclusion(":");
        if(exists sep) {
            if(sep > 0) {
                scheme = uri.measure(0, sep);
                return uri[sep+1...];
            }
        }
        // no scheme, it must be relative
        return uri;
    }

    void parseUserInfo(String userInfo) {
        Integer? sep = userInfo.firstOccurrence(':');
        if(exists sep) {
            authorityUser = decodePercentEncoded(userInfo.measure(0, sep));
            authorityPassword = decodePercentEncoded(userInfo[sep+1...]);
        }else{
            authorityUser = decodePercentEncoded(userInfo);
            authorityPassword = null;
        }
    }

    void parseHostAndPort(String hostAndPort) {
        String? portString;
        if(hostAndPort.startsWith("[")) {
            authorityIPLiteral = true;
            Integer? end = hostAndPort.firstOccurrence(']');
            if(exists end) {
                // eat the delimiters
                authorityHost = hostAndPort.measure(1, end-1);
                String rest = hostAndPort[end+1...];
                if(rest.startsWith(":")) {
                    portString = rest[1...];
                }else{
                    portString = null;
                }
            }else{
                throw InvalidUriException("Invalid IP literal: " + hostAndPort);
            }
        }else{
            authorityIPLiteral = false;
            Integer? sep = hostAndPort.lastOccurrence(':');
            if(exists sep) {
                authorityHost = decodePercentEncoded(hostAndPort.measure(0, sep));
                portString = hostAndPort[sep+1...];
            }else{
                authorityHost = decodePercentEncoded(hostAndPort);
                portString = null;
            }
        }
        if(exists portString) {
            authorityPort
                    = if (is Integer port = Integer.parse(portString))
                    then port else null;
            if(exists Integer port = authorityPort) {
                if(port < 0) {
                    throw InvalidUriException("Invalid port number: "+portString);
                }
            }else{
                throw InvalidUriException("Invalid port number: "+portString);
            }
        }else{
            authorityPort = null;
        }
    }

    String parseAuthority(String uri) {
        if(!uri.startsWith("//")) {
            return uri;
        }
        // eat the two slashes
        String part = uri[2...];
        Integer? sep = part.firstOccurrence('/')
            else part.firstOccurrence('?')
            else part.firstOccurrence('#');
        String authority;
        String remains;
        if(exists sep) {
            authority = part.measure(0, sep);
            remains = part[sep...];
        }else{
            // no path part
            authority = part;
            remains = "";
        }
        Integer? userInfoSep = authority.firstOccurrence('@');
        String hostAndPort;
        if(exists userInfoSep) {
            parseUserInfo(authority.measure(0, userInfoSep));
            hostAndPort = authority[userInfoSep+1...];
        }else{
            hostAndPort = authority;
        }
        parseHostAndPort(hostAndPort);
        return remains;
    }

    {Parameter*} parsePathSegmentParameters(String part)
        =>  [ for(param in part.split { ';'.equals; groupSeparators = false; })
                parseParameter(param) ];

    "Parse a raw (percent-encoded) segment, with optional
     parameters to be parsed"
    PathSegment parseRawPathSegment(String part) {
        Integer? sep = part.firstOccurrence(';');
        String name;
        if(exists sep) {
            name = part[0..sep-1];
        }else{
            name = part;
        }
        PathSegment path;
        if(exists sep) {
            path = PathSegment(decodePercentEncoded(name),
                               *parsePathSegmentParameters(part[sep+1...]));
        }else{
            path = PathSegment(decodePercentEncoded(name));
        }
        return path;
    }

    String parsePath(String uri) {
        Integer? sep = uri.firstOccurrence('?') else uri.firstOccurrence('#');
        String pathPart;
        String remains;
        if(exists sep) {
            pathPart = uri.measure(0, sep);
            remains = uri[sep...];
        }else{
            // no query/fragment part
            pathPart = uri;
            remains = "";
        }
        if(!pathPart.empty) { // else, use default `path` already initialized
            value parts = pathPart.split { '/'.equals; groupSeparators = false; }.sequence();
            value absolute = parts.first.empty;
            path = Path {
                absolute = absolute;
                segments = if (absolute)
                           then parts.rest.collect(parseRawPathSegment)
                           else parts.collect(parseRawPathSegment);
            };
        }

        return remains;
    }

    Query parseQueryPart(String queryPart)
        =>  Query {
                parameters = queryPart.split { '&'.equals; groupSeparators = false; }
                                      .collect(parseParameter);
            };

    String parseQuery(String uri) {
        Character? c = uri[0];
        if(exists c) {
            if(c == '?') { // else, use default `query` already initialized
                // we have a query part
                Integer end = uri.firstOccurrence('#') else uri.size;
                query = parseQueryPart(uri.measure(1, end-1));
                return uri[end...];
            }
        }
        // no query/fragment part
        return uri;
    }

    String parseFragment(String uri) {
        Character? c = uri[0];
        if(exists c) {
            if(c == '#') {
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

    Authority authority =
        if (authorityUser exists
                || authorityPassword exists
                || authorityHost exists
                || authorityPort exists)
        then Authority {
            user = authorityUser;
            password = authorityPassword;
            host = authorityHost;
            port = authorityPort;
            ipLiteral = authorityIPLiteral; }
        else defaultAuthority;

   return Uri(scheme, authority, path, query, fragment);
}