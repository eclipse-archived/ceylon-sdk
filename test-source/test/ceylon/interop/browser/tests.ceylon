import ceylon.test {
    test,
    assertEquals,
    assumeTrue
}
import ceylon.interop.browser {
    window
}
import ceylon.interop.browser.dom {
    document
}
Boolean isBrowser {
    return runtime.name == "Browser";
}

test
shared void testLocation() {
    assumeTrue(isBrowser);
    
    assertEquals("http://localhost:8080/",window.location.string);
}
test
shared void testDomManipulation() {
    assumeTrue(isBrowser);
    
    value div = document.createElement("div");
    if (exists body= document.body) {
        value text = document.createTextNode("Hello world");
        div.appendChild(text);
        assert(exists t = div.firstChild,
            text == t);
        value last = body.lastChild;
        body.appendChild(div);
        if (exists last) {
            assert(exists next=last.nextSibling,
                div == next);
        } else {
            assert(exists onlyChild = body.lastChild,
                div == onlyChild);
        }
    }
}