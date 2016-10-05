
"An [RFC 2045] Media Type, appropriate to describe
 the content type of an HTTP request or response body.
 
 [RFC 2045]: http://tools.ietf.org/html/rfc2045
 "
shared interface MediaType {

    shared String type;
    shared String? tree;
    shared String subtype;
    shared String? suffix;

    shared Parameter[] parameters;
}

"Parameter of a MIME media type."
shared class Parameter(name, val) {
    "Invalid media type parameter attribute name"
    assert( validToken(name) );

    "Invalid media type parameter attribute value"
    assert( validQuotedValue(val) );

    "Media type parameter attribute name."
    shared String name;

    "Media type parameter value"
    shared String val;

    string => "`` name ``=`` val.any(tspecials) then "\"``val``\"" else val ``";
    hash = 13 * name.hash + val.hash;
    equals(Object other) =>
        if (is Parameter other)
        then this.name == other.name && this.val == other.val
        else false;
}
