import ceylon.json { parseJson = parse, ... }
import ceylon.net.uri { parse }
import ceylon.net.http.client { ... }
import ceylon.test { ... }

void testJSON(Object json){
    assertEquals(70, json.size, "Object size");
    assertEquals("http://ceylon-lang.org", json["homepage"], "Homepage");
    
    if(is Object owner = json["owner"]){
        assertEquals("ceylon", owner["login"], "Owner name");
    }else{
        fail("owner is not Object");
    }
}

test void testGETAndParseJSON(){
    value request = parse("https://api.github.com/repos/ceylon/ceylon-compiler").get();
    value response = request.execute();
    print(response);
    assertFalse(response.contents empty, "Has contents");

    Object json = parseJson(response.contents);
    testJSON(json);    
}

String get(String uri){
    return parse(uri).get().execute().contents;
}

test void testGet(){
    value contents = get("http://en.wikipedia.org/wiki/Main_Page");
    assertTrue(contents.contains("<title>Wikipedia, the free encyclopedia</title>"), "Contains title");
    assertTrue(contents.contains("</html>"), "Contains end </html>");
}

test void testGetUtf8(){
    value contents = get("http://th.wikipedia.org/wiki/%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B9%80%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A3%E0%B8%AB%E0%B8%B1%E0%B8%AA%E0%B8%82%E0%B8%99%E0%B8%AA%E0%B9%88%E0%B8%87%E0%B9%80%E0%B8%9B%E0%B9%87%E0%B8%99%E0%B8%8A%E0%B8%B4%E0%B9%89%E0%B8%99%E0%B8%AA%E0%B9%88%E0%B8%A7%E0%B8%99");
    assertTrue(contents.contains("<title>การเข้ารหัสขนส่งเป็นชิ้นส่วน - วิกิพีเดีย</title>"), "Contains title");
    assertTrue(contents.contains("</html>"), "Contains end </html>");
}

test void testGetUtf8_2(){
    value contents = get("http://www.somatik.be/temp/me.php");
    assertTrue(contents.contains("Fränçis De Brabandere"), "Contains Fränçis De Brabandere");
}

test void testGetChunked(){
    value contents = get("http://www.google.fr");
    assertTrue(contents.contains("<title>Google</title>"), "Contains title");
    assertTrue(contents.contains("</html>"), "Contains end </html>");
}