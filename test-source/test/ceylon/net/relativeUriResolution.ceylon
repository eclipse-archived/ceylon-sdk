import ceylon.test { assertEquals }
import ceylon.net.uri { parseURI }

by "Matej Lazar"
void testResolveRelativeURI() {
    value base = parseURI("http://a/b/c/d;p?q");
    
    assertEquals(parseURI("g:h"), base.resolve(parseURI("g:h")));
    assertEquals(parseURI("http://a/b/c/g"), base.resolve(parseURI("g")));
    assertEquals(parseURI("http://a/b/c/d/e"), parseURI("http://a/b/c/d/").resolve(parseURI("e")));
    assertEquals(parseURI("http://a/b/c/g"), base.resolve(parseURI("./g")));
    assertEquals(parseURI("http://a/b/c/g/"), base.resolve(parseURI("g/")));
    assertEquals(parseURI("http://a/g"), base.resolve(parseURI("/g")));
    assertEquals(parseURI("http://g"), base.resolve(parseURI("//g")));
    assertEquals(parseURI("http://a/b/c/d;p?y"), base.resolve(parseURI("?y")));
    assertEquals(parseURI("http://a/b/c/g?y"), base.resolve(parseURI("g?y")));
    assertEquals(parseURI("http://a/b/c/d;p?q#s"), base.resolve(parseURI("#s")));
    assertEquals(parseURI("http://a/b/c/g#s"), base.resolve(parseURI("g#s")));
    assertEquals(parseURI("http://a/b/c/g?y#s"), base.resolve(parseURI("g?y#s")));
    assertEquals(parseURI("http://a/b/c/;x"), base.resolve(parseURI(";x")));
    assertEquals(parseURI("http://a/b/c/g;x"), base.resolve(parseURI("g;x")));
    assertEquals(parseURI("http://a/b/c/g;x?y#s"), base.resolve(parseURI("g;x?y#s")));
    assertEquals(parseURI("http://a/b/c/d;p?q"), base.resolve(parseURI("")));
    assertEquals(parseURI("http://a/b/c/"), base.resolve(parseURI(".")));
    assertEquals(parseURI("http://a/b/c/"), base.resolve(parseURI("./")));
    assertEquals(parseURI("http://a/b/"), base.resolve(parseURI("..")));
    assertEquals(parseURI("http://a/b/"), base.resolve(parseURI("../")));
    assertEquals(parseURI("http://a/b/g"), base.resolve(parseURI("../g")));
    assertEquals(parseURI("http://a/"), base.resolve(parseURI("../..")));
    assertEquals(parseURI("http://a/"), base.resolve(parseURI("../../")));
    assertEquals(parseURI("http://a/g"), base.resolve(parseURI("../../g")));
    
    assertEquals(parseURI("http://a/g"), base.resolve(parseURI("../../../g")));
    assertEquals(parseURI("http://a/g"), base.resolve(parseURI("../../../../g")));
    
    assertEquals(parseURI("http://a/g"), base.resolve(parseURI("/./g")));
    assertEquals(parseURI("http://a/g"), base.resolve(parseURI("/../g")));
    assertEquals(parseURI("http://a/b/c/g."), base.resolve(parseURI("g.")));
    assertEquals(parseURI("http://a/b/c/.g"), base.resolve(parseURI(".g")));
    assertEquals(parseURI("http://a/b/c/g.."), base.resolve(parseURI("g..")));
    assertEquals(parseURI("http://a/b/c/..g"), base.resolve(parseURI("..g")));

    assertEquals(parseURI("http://a/b/g"), base.resolve(parseURI("./../g")));
    assertEquals(parseURI("http://a/b/c/g/"), base.resolve(parseURI("./g/.")));
    assertEquals(parseURI("http://a/b/c/g/h"), base.resolve(parseURI("g/./h")));
    assertEquals(parseURI("http://a/b/c/h"), base.resolve(parseURI("g/../h")));
    assertEquals(parseURI("http://a/b/c/g;x=1/y"), base.resolve(parseURI("g;x=1/./y")));
    assertEquals(parseURI("http://a/b/c/y"), base.resolve(parseURI("g;x=1/../y")));

    assertEquals(parseURI("http://a/b/c/g?y/./x"), base.resolve(parseURI("g?y/./x")));
    assertEquals(parseURI("http://a/b/c/g?y/../x"), base.resolve(parseURI("g?y/../x")));
    assertEquals(parseURI("http://a/b/c/g#s/./x"), base.resolve(parseURI("g#s/./x")));
    assertEquals(parseURI("http://a/b/c/g#s/../x"), base.resolve(parseURI("g#s/../x")));
}

void testRelativePart() {
    value base = parseURI("http://a/b/c/");
    
    assertEquals(parseURI("d"), parseURI("http://a/b/c/d").relativePart(base));
    assertEquals(parseURI("d/e"), parseURI("http://a/b/c/d/e").relativePart(base));
    assertEquals(parseURI("d/e/"), parseURI("http://a/b/c/d/e/").relativePart(base));
    assertEquals(parseURI("d/e/"), parseURI("http://a/b/c/d/e/").relativePart(base));

    assertEquals(parseURI("g;x=1/y"), parseURI("http://a/b/c/g;x=1/y").relativePart(base));

    assertEquals(parseURI("g;x=1/y"), parseURI("http://a/b/c/g;x=1/y").relativePart(base));
    
    assertEquals(parseURI("g?y#s"), parseURI("http://a/b/c/g?y#s").relativePart(base));

    assertEquals(parseURI("../e/"), parseURI("http://a/b/e/").relativePart(base));

    assertEquals(parseURI("//a/b/e/?a=1"), parseURI("http://a/b/e/?a=1").relativePart(parseURI("http:")));
    
}
