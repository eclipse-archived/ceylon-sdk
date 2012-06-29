import ceylon.net.uri { URI, parseURI }
import ceylon.net.http { ... }
import com.redhat.ceylon.sdk.test { ... }
import ceylon.json { ... }

void testJSON(Object json){
    assertEquals(28, json.size, "Object size");
    assertEquals("http://ceylon-lang.org", json.get("homepage"), "Homepage");
    
    if(is Object owner = json.get("owner")){
        assertEquals("ceylon", owner.get("login"), "Owner name");
    }else{
        fail("owner is not Object");
    }
}

void testGET(){
    value request = parseURI("https://api.github.com/repos/ceylon/ceylon-compiler").get();
    value response = request.execute();
    assertTrue(nonempty response.contents, "Has contents");

    Object json = parse(response.contents);
    testJSON(json);    
}

