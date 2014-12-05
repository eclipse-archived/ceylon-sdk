import ceylon.net.uri { ... }
import ceylon.test { ... }

void testURL(String url,
            String? scheme = null,
            String? user = null,
            String? pass = null,
            String? host = null,
            Boolean ipLiteral = false,
            Integer? port = null,
            String? path = null,
            Path? decomposedPath = null,
            String? query = null,
            Query? decomposedQuery = null,
            String? fragment = null){
    Uri u = parse(url);
    assertEquals(scheme, u.scheme, "Scheme "+url);
    assertEquals(user, u.authority.user, "User "+url);
    assertEquals(pass, u.authority.password, "Password "+url);
    assertEquals(host, u.authority.host, "Host "+url);
    assertEquals(ipLiteral, u.authority.ipLiteral, "IP-Literal "+url);
    assertEquals(port, u.authority.port, "Port "+url);
    assertEquals(path else "", u.pathPart, "Path "+url);
    if(exists decomposedPath){
        assertEquals(decomposedPath, u.path, "Decomposed Path "+url);
    }
    assertEquals(query, u.queryPart, "Query "+url);
    assertEquals(fragment, u.fragment, "Fragment "+url);
    if(exists decomposedQuery){
        assertEquals(decomposedQuery, u.query, "Decomposed Query "+url);
    }

    assertEquals(url, u.string, "String "+url);
}

test void testDecomposition(){
    testURL{
        url = "http://user:pass@www.foo.com:80/path/to;param1;param2=foo/file.html?foo=bar&foo=gee&bar#anchor";
        scheme = "http";
        user = "user";
        pass = "pass";
        host = "www.foo.com";
        port = 80;
        path = "/path/to;param1;param2=foo/file.html";
        query = "foo=bar&foo=gee&bar";
        fragment = "anchor";
    };
    testURL{
        url = "http://host";
        scheme = "http";
        host = "host";
    };
    testURL{
        url = "http://host/";
        scheme = "http";
        host = "host";
        path = "/";
    };
    testURL{
        url = "http://host?foo";
        scheme = "http";
        host = "host";
        query = "foo";
    };
    testURL{
        url = "http://host#foo";
        scheme = "http";
        host = "host";
        fragment = "foo";
    };
    testURL{
        url = "http://user@host";
        scheme = "http";
        user = "user";
        host = "host";
    };
    testURL{
        url = "http://host:80";
        scheme = "http";
        host = "host";
        port = 80;
    };
    testURL{
        url = "file:///no/host";
        scheme = "file";
        host = "";
        path = "/no/host";
    };
    testURL{
        url = "file:///";
        scheme = "file";
        host = "";
        path = "/";
    };
    testURL{
        url = "mailto:stef@epardaud.fr";
        scheme = "mailto";
        path = "stef@epardaud.fr";
    };
    testURL{
        url = "//host/file";
        host = "host";
        path = "/file";
    };
    testURL{
        url = "/path/somewhere";
        path = "/path/somewhere";
    };
    testURL{
        url = "someFile";
        path = "someFile";
    };
    testURL{
        url = "?query";
        query = "query";
    };
    testURL{
        url = "#anchor";
        fragment = "anchor";
    };
    testURL{
        url = "http://192.168.1.1:80";
        scheme = "http";
        host = "192.168.1.1";
        port = 80;
    };
    testURL{
        url = "http://[::1]:80";
        scheme = "http";
        host = "::1";
        port = 80;
        ipLiteral = true;
    };
    testURL{
        url = "http://[2001:5c0:1105:6d01:22cf:30ff:fe32:f8e2]:80";
        scheme = "http";
        host = "2001:5c0:1105:6d01:22cf:30ff:fe32:f8e2";
        port = 80;
        ipLiteral = true;
    };
}

test void testComposition(){
    Uri u = Uri("http",
                Authority("stef", null, "192.168.1.1", 9000),
                Path(true, PathSegment("a"), PathSegment("b", Parameter("c"), Parameter("d", "e"))),
                Query(Parameter("q"), Parameter("r","s")),
                null);
    testURL{
        url = u.string;
        scheme = "http";
        host = "192.168.1.1";
        port = 9000;
        user = "stef";
        path = "/a/b;c;d=e";
        query = "q&r=s";
    };
}

test void testInvalidPort(){
    try {
        parse("http://foo:bar");
     } catch (Exception e) {
        assertEquals("Invalid port number: bar", e.message);
     }
}

test void testInvalidPort2(){
    try {
        parse("http://foo:-23");
     } catch (Exception e) {
        assertEquals("Invalid port number: -23", e.message);
     }
}

test void testDecoding(){
    /*
%3D%23ue/segment2?par%26%3D%23am3&par%26%3D%23am4=val%26%3D%23ue2#frag%26%3D%23ment
  =%23ue/segment2?par%26%3D%23am3&par%26%3D%23am4=val%26%3D%23ue2#frag&=%23ment
*/
    testURL{
        url = "http://us%3Aer:pa%3A%40ss@ho%3Ast:123/segm%2F%3F%3Bent1;par%2F%3F%3B%3Dam1;par%2F%3F%3B%3Dam2=val%2F%3F%3B=%23ue/segment2?par%26%3D%23am3&par%26%3D%23am4=val%26%3D%23ue2#frag&=%23ment";
        scheme = "http";
        user = "us:er";
        pass = "pa:@ss";
        host = "ho:st";
        port = 123;
//        path = "/segm/?;ent1;par/?;=am1;par/?;=am2=val/?;=#ue/segment2";
        path = "/segm%2F%3F%3Bent1;par%2F%3F%3B%3Dam1;par%2F%3F%3B%3Dam2=val%2F%3F%3B=%23ue/segment2";
        decomposedPath = Path {
            absolute = true;
            initialSegments = [
                PathSegment {
                    name = "segm/?;ent1";
                    initialParameters = [
                        Parameter {
                            name = "par/?;=am1";
                        },
                        Parameter {
                            name = "par/?;=am2";
                            val = "val/?;=#ue";
                        }
                    ];
                },
                PathSegment {
                    name = "segment2";
                }
            ];
        };
//        query = "par&=#am3&par&=#am4=val&=#ue2";
        query = "par%26%3D%23am3&par%26%3D%23am4=val%26%3D%23ue2";
        decomposedQuery = Query {
            initialParameters = [
            Parameter {
                name = "par&=#am3";
            },
            Parameter {
                name = "par&=#am4";
                val = "val&=#ue2";
            }];
        };
        fragment = "frag&=#ment";
    };

}

test void testUriBuilding(){
    Uri uri = parse("http://ceylon-lang.org/blog");
    assertEquals("http://ceylon-lang.org/blog", uri.string);
}
