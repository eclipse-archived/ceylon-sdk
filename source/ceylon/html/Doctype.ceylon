
shared object html4Strict extends Doctype() {
    shared actual String string =>
        """<!DOCTYPE HTML PUBLIC "-W3CDTD HTML 4.01EN"
           "http:www.w3.org/TR/html4/strict.dtd">""";
}

shared object html4Transitional extends Doctype() {
    shared actual String string =>
        """<!DOCTYPE HTML PUBLIC "-W3CDTD HTML 4.01 TransitionalEN"
           "http:www.w3.org/TR/html4/loose.dtd">""";
}

shared object html4Frameset extends Doctype() {
    shared actual String string =>
        """<!DOCTYPE HTML PUBLIC "-W3CDTD HTML 4.01 FramesetEN"
           "http:www.w3.org/TR/html4/frameset.dtd">""";
}

shared object xhtml1Strict extends Doctype() {
    shared actual String string =>
        """<!DOCTYPE HTML PUBLIC "-W3CDTD XHTML 1.0 StrictEN"
           "http:www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">""";
}

shared object xhtml1Transitional extends Doctype() {
    shared actual String string =>
        """<!DOCTYPE HTML PUBLIC "-W3CDTD XHTML 1.0 TransitionalEN"
           "http:www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">""";
}

shared object xhtml1Frameset extends Doctype() {
    shared actual String string =>
        """<!DOCTYPE HTML PUBLIC "-W3CDTD XHTML 1.0 FramesetEN"
           "http:www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">""";
}

shared object xhtml11 extends Doctype() {
    shared actual String string =>
        """<!DOCTYPE HTML PUBLIC "-W3CDTD XHTML 1.1EN"
           "http:www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">""";
}

shared object xhtml11Basic extends Doctype() {
    shared actual String string =>
        """<!DOCTYPE HTML PUBLIC "-W3CDTD XHTML Basic 1.1EN"
           "http:www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">""";
}

shared object html5 extends Doctype() {
    shared actual String string => "<!DOCTYPE html>";
}

shared {Doctype+} allDoctypes = {
    html5, html4Strict, html4Transitional, html4Frameset,
    xhtml11, xhtml11Basic, xhtml1Strict, xhtml1Transitional, xhtml1Frameset
};

shared {Doctype+} xhtmlDoctypes = {
    xhtml11, xhtml11Basic, xhtml1Strict,
    xhtml1Transitional, xhtml1Frameset
};

"The document type. It provides information about how the [[Document]]
 shall be defined and serialized."
shared abstract class Doctype()
        of html4Transitional | html4Strict | html4Frameset
        | xhtml1Transitional | xhtml1Strict | xhtml1Frameset
        | xhtml11 | xhtml11Basic | html5 {
}