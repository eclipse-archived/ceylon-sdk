// TODO doc



shared dynamic NodeIterator {
    shared formal Node root;
    shared formal Node referenceNode;
    shared formal Boolean pointerBeforeReferenceNode;
    shared formal Integer whatToShow;
    shared formal NodeFilter? filter;
    
    shared formal Node? nextNode();
    shared formal Node? previousNode();
    
    shared formal void detach();
}

shared dynamic NodeFilter {
    // Constants for acceptNode()
    shared formal Integer \iFILTER_ACCEPT;
    shared formal Integer \iFILTER_REJECT;
    shared formal Integer \iFILTER_SKIP;
    
    // Constants for whatToShow
    shared formal Integer \iSHOW_ALL;
    shared formal Integer \iSHOW_ELEMENT;
    shared formal Integer \iSHOW_ATTRIBUTE; // historical
    shared formal Integer \iSHOW_TEXT;
    shared formal Integer \iSHOW_CDATA_SECTION; // historical
    shared formal Integer \iSHOW_ENTITY_REFERENCE; // historical
    shared formal Integer \iSHOW_ENTITY; // historical
    shared formal Integer \iSHOW_PROCESSING_INSTRUCTION;
    shared formal Integer \iSHOW_COMMENT;
    shared formal Integer \iSHOW_DOCUMENT;
    shared formal Integer \iSHOW_DOCUMENT_TYPE;
    shared formal Integer \iSHOW_DOCUMENT_FRAGMENT;
    shared formal Integer \iSHOW_NOTATION; // historical
    
    shared formal Integer acceptNode(Node node);
}

shared dynamic TreeWalker {
    shared formal Node root;
    shared formal Integer whatToShow;
    shared formal NodeFilter? filter;
    shared formal variable Node currentNode;
    
    shared formal Node? parentNode();
    shared formal Node? firstChild();
    shared formal Node? lastChild();
    shared formal Node? previousSibling();
    shared formal Node? nextSibling();
    shared formal Node? previousNode();
    shared formal Node? nextNode();
}