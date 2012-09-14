import ceylon.json { ... }
import com.redhat.ceylon.sdk.test { ... }

class CollectionSuite() extends Suite("ceylon.collection") {
    shared actual Iterable<String->Void()> suite = {
        "Parse" -> testParse
    };
}

shared void run(){
    CollectionSuite().run();
}


void testParse() {
    value o1 = parse("{}");
    assertEquals(0, o1.size);
    
    value o2 = parse("{\"foo\": \"bar\"}");
    assertEquals(1, o2.size);
    assertEquals("bar", o2["foo"]);
    
    value o3 = parse("{\"s\": \"bar\", \"t\": true, \"f\": false, \"n\": null}");
    assertEquals(4, o3.size);
    assertEquals("bar", o3["s"]);
    assertEquals(true, o3["t"]);
    assertEquals(false, o3["f"]);
    assertEquals(nil, o3["n"]);
    
    value o4 = parse("{\"i\": 12, \"f\": 12.34, \"ie\": 12e10, \"fe\": 12.34e10}");
    assertEquals(4, o4.size);
    assertEquals(12, o4["i"]);
    assertEquals(12.34, o4["f"]);
    assertEquals(12.0e10.integer, o4["ie"]);
    assertEquals(12.34e10, o4["fe"]);
    
    value o5 = parse("{\"i\": -12, \"f\": -12.34, \"ie\": -12e10, \"fe\": -12.34e10}");
    assertEquals(4, o5.size);
    assertEquals(-12, o5["i"]);
    assertEquals(-12.34, o5["f"]);
    assertEquals(-12.0e10.integer, o5["ie"]);
    assertEquals(-12.34e10, o5["fe"]);
    
    value o6 = parse("{\"ie\": 12E10, \"fe\": 12.34E10}");
    assertEquals(2, o6.size);
    assertEquals(12.0e10.integer, o6["ie"]);
    assertEquals(12.34e10, o6["fe"]);
    
    value o7 = parse("{\"ie\": 12e+10, \"fe\": 12.34e+10}");
    assertEquals(2, o7.size);
    assertEquals(12.0e10.integer, o7["ie"]);
    assertEquals(12.34e10, o7["fe"]);
    
    value o8 = parse("{\"ie\": 12e-10, \"fe\": 12.34e-10}");
    assertEquals(2, o8.size);
    assertEquals(12.0e-10, o8["ie"]);
    assertEquals(12.34e-10, o8["fe"]);
    
    value o9 = parse("{\"s\": \"escapes \\\\ \\\" \\/ \\b \\f \\t \\n \\r \\u0053 \\u3042\"}");
    assertEquals(1, o9.size);
    assertEquals("escapes \\ \" / \b \f \t \n \r \{0053} \{3042}", o9["s"]);
    
    value o10 = parse("{\"obj\": {\"gee\": \"bar\"}}");
    assertEquals(1, o10.size);
    if(is Object obj = o10["obj"]){
        assertEquals("bar", obj["gee"]);
    }else{
        fail();
    }
    
    value o11 = parse("{\"arr\": [1, 2, 3]}");
    assertEquals(1, o11.size);
    if(is Array arr = o11["arr"]){
        assertEquals(3, arr.size);
        assertEquals(1, arr[0]);
        assertEquals(2, arr[1]);
        assertEquals(3, arr[2]);
    }else{
        fail();
    }
    
    value o12 = parse("{\"svn_url\":\"https://github.com/ceylon/ceylon-compiler\",\"has_downloads\":true,\"homepage\":\"http://ceylon-lang.org\",\"mirror_url\":null,\"has_issues\":true,\"updated_at\":\"2012-04-11T10:20:59Z\",\"forks\":22,\"clone_url\":\"https://github.com/ceylon/ceylon-compiler.git\",\"ssh_url\":\"git@github.com:ceylon/ceylon-compiler.git\",\"html_url\":\"https://github.com/ceylon/ceylon-compiler\",\"language\":\"Java\",\"organization\":{\"gravatar_id\":\"a38479e9dc888f68fb6911d4ce05d7cc\",\"url\":\"https://api.github.com/users/ceylon\",\"avatar_url\":\"https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png\",\"id\":579261,\"login\":\"ceylon\"},\"has_wiki\":true,\"fork\":false,\"git_url\":\"git://github.com/ceylon/ceylon-compiler.git\",\"created_at\":\"2011-01-24T14:25:50Z\",\"url\":\"https://api.github.com/repos/ceylon/ceylon-compiler\",\"size\":2413,\"private\":false,\"open_issues\":81,\"description\":\"Ceylon compiler (ceylonc: Java backend), Ceylon documentation generator (ceylond) and Ceylon ant tasks.\",\"owner\":{\"gravatar_id\":\"a38479e9dc888f68fb6911d4ce05d7cc\",\"url\":\"https://api.github.com/users/ceylon\",\"avatar_url\":\"https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png\",\"id\":579261,\"login\":\"ceylon\"},\"name\":\"ceylon-compiler\",\"watchers\":74,\"pushed_at\":\"2012-04-11T07:43:33Z\",\"id\":1287859}");
    assertEquals(26, o12.size);
    assertEquals("https://github.com/ceylon/ceylon-compiler.git", o12["clone_url"]);
    assertEquals("2011-01-24T14:25:50Z", o12["created_at"]);
	assertEquals("Ceylon compiler (ceylonc: Java backend), Ceylon documentation generator (ceylond) and Ceylon ant tasks.", o12["description"]);
    assertEquals(false, o12["fork"]);
    assertEquals(22, o12["forks"]);
	assertEquals("git://github.com/ceylon/ceylon-compiler.git", o12["git_url"]);
	assertEquals(true, o12["has_downloads"]);
    assertEquals(true, o12["has_issues"]);
    assertEquals(true, o12["has_wiki"]);
	assertEquals("http://ceylon-lang.org", o12["homepage"]);
	assertEquals("https://github.com/ceylon/ceylon-compiler", o12["html_url"]);
    assertEquals(1287859, o12["id"]);
	assertEquals("Java", o12["language"]);
    assertEquals(nil, o12["mirror_url"]);
	assertEquals("ceylon-compiler", o12["name"]);
    assertEquals(81, o12["open_issues"]);
    if(is Object org = o12["organization"]){
        assertEquals(5, org.size);
        assertEquals("https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png", org["avatar_url"]);
        assertEquals("a38479e9dc888f68fb6911d4ce05d7cc", org["gravatar_id"]);
        assertEquals(579261, org["id"]);
        assertEquals("ceylon", org["login"]);
        assertEquals("https://api.github.com/users/ceylon", org["url"]);
    }
    if(is Object owner = o12["owner"]){
        assertEquals(5, owner.size);
        assertEquals("https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png", owner["avatar_url"]);
        assertEquals("a38479e9dc888f68fb6911d4ce05d7cc", owner["gravatar_id"]);
        assertEquals(579261, owner["id"]);
        assertEquals("ceylon", owner["login"]);
        assertEquals("https://api.github.com/users/ceylon", owner["url"]);
    }
    assertEquals(false, o12["private"]);
	assertEquals("2012-04-11T07:43:33Z", o12["pushed_at"]);
	assertEquals(2413, o12["size"]);
	assertEquals("git@github.com:ceylon/ceylon-compiler.git", o12["ssh_url"]);
    assertEquals("https://github.com/ceylon/ceylon-compiler", o12["svn_url"]);
    assertEquals("2012-04-11T10:20:59Z", o12["updated_at"]);
    assertEquals("https://api.github.com/repos/ceylon/ceylon-compiler", o12["url"]);
    assertEquals(74, o12["watchers"]);
    
}