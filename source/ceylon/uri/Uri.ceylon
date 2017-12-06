/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"The URI class. See [RFC 3986][rfc3986] for specifications.

 [rfc3986]: http://tools.ietf.org/html/rfc3986"
by("Stéphane Épardaud")
shared class Uri(scheme = null,
    authority = defaultAuthority,
    path = defaultPath,
    query = defaultQuery,
    fragment = null) {

    "The optional URI scheme: `http`, `https`, `mailto`…"
    shared String? scheme;

    "The optional Authority part (contains user, password,
     host and port)"
    shared Authority authority;

    "The optional Path part"
    shared Path path;

    "The optional query part"
    shared Query query;

    "The optional fragment (hash) part"
    shared String? fragment;

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
        if(exists scheme) {
            b.append(scheme);
            b.append(":");
        }
        if(authority.specified) {
            b.append("//");
            b.append(authority.toRepresentation(human));
        }
        b.append(path.toRepresentation(human));
        if(query.specified) {
            b.append("?");
            b.append(query.toRepresentation(human));
        }
        if(exists fragment) {
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

    "Create a new [[Uri]] based on this [[Uri]], replacing the `scheme` with the given value"
    shared Uri withScheme(String? scheme)
        => Uri(scheme, authority, path, query, fragment);

    "Create a new [[Uri]] based on this [[Uri]], replacing the `authority` with the given value"
    shared Uri withAuthority(Authority authority)
        => Uri(scheme, authority, path, query, fragment);

    Path makePathAbsoluteIfRequired(Authority authority, Path path){
        if(!path.absolute && authority.specified){
            return Path(true, *path.segments);
        }else{
            return path;
        }
    }

    "Create a new [[Uri]] based on this [[Uri]], replacing the `path` with the given value"
    shared Uri withPath(Path path){
        return Uri(scheme, authority, makePathAbsoluteIfRequired(authority, path), query, fragment);
    }

    "Create a new [[Uri]] based on this [[Uri]], replacing the `query` with the given value"
    shared Uri withQuery(Query query)
        => Uri(scheme, authority, path, query, fragment);

    "Create a new [[Uri]] based on this [[Uri]], replacing the `fragment` with the given value"
    shared Uri withFragment(String? fragment)
        => Uri(scheme, authority, path, query, fragment);

    "Create a new [[Uri]] based on this [[Uri]], replacing the specified values"
    shared Uri with(String? scheme = this.scheme,
                    Authority authority = this.authority,
                    Path path = this.path,
                    Query query = this.query,
                    String? fragment = this.fragment)
        => Uri(scheme, authority, makePathAbsoluteIfRequired(authority, path), query, fragment);

    "Returns true if the given object is the same as this
     object"
    shared actual Boolean equals(Object that) {
        if(is Uri that) {
            if(this === that) {
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
}
