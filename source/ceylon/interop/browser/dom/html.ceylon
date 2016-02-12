shared dynamic HTMLElement satisfies Element & GlobalEventHandlers {
    // metadata shared formals
    shared formal variable String title;
    shared formal variable String lang;
    shared formal variable Boolean translate;
    shared formal variable String dir;
    // TODO DOMStringMap
    shared formal dynamic dataset;
    
    // user interaction
    shared formal variable Boolean hidden;
    shared formal void click();
    shared formal variable Integer tabIndex;
    shared formal void focus();
    shared formal void blur();
    shared formal variable String accessKey;
    shared formal variable String? accessKeyLabel;
    shared formal variable String contentEditable;
    shared formal Boolean isContentEditable;
    shared formal variable Boolean spellcheck;
}

shared dynamic HTMLHeadElement satisfies HTMLElement {
}

shared dynamic HTMLUnknownElement satisfies HTMLElement {
}
