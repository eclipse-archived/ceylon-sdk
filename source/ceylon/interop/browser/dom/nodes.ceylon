import ceylon.interop.browser {
    Location,
    WindowProxy,
    window
}
import ceylon.interop.browser.internal {
    newTextInternal,
    newCommentInternal
}
// TODO doc



shared dynamic Node satisfies EventTarget {
    shared formal Integer \iELEMENT_NODE;
    shared formal Integer \iATTRIBUTE_NODE; // historical
    shared formal Integer \iTEXT_NODE;
    shared formal Integer \iCDATA_SECTION_NODE; // historical
    shared formal Integer \iENTITY_REFERENCE_NODE; // historical
    shared formal Integer \iENTITY_NODE; // historical
    shared formal Integer \iPROCESSING_INSTRUCTION_NODE;
    shared formal Integer \iCOMMENT_NODE;
    shared formal Integer \iDOCUMENT_NODE;
    shared formal Integer \iDOCUMENT_TYPE_NODE;
    shared formal Integer \iDOCUMENT_FRAGMENT_NODE;
    shared formal Integer \iNOTATION_NODE; // historical
    shared formal Integer nodeType;
    shared formal String nodeName;
    
    shared formal String? baseURI;
    
    shared formal Document? ownerDocument;
    shared formal Node? parentNode;
    shared formal Element? parentElement;
    shared formal Boolean hasChildNodes();
    shared formal NodeList childNodes;
    shared formal Node? firstChild;
    shared formal Node? lastChild;
    shared formal Node? previousSibling;
    shared formal Node? nextSibling;
    
    shared formal variable String? nodeValue;
    shared formal variable String? textContent;
    shared formal void normalize();
    
    shared formal Node cloneNode(Boolean deep = false);
    shared formal Boolean isEqualNode(Node? node);
    
    shared formal Integer \iDOCUMENT_POSITION_DISCONNECTED;
    shared formal Integer \iDOCUMENT_POSITION_PRECEDING;
    shared formal Integer \iDOCUMENT_POSITION_FOLLOWING;
    shared formal Integer \iDOCUMENT_POSITION_CONTAINS;
    shared formal Integer \iDOCUMENT_POSITION_CONTAINED_BY;
    shared formal Integer \iDOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC;
    shared formal Integer compareDocumentPosition(Node other);
    shared formal Boolean contains(Node? other);
    
    shared formal String? lookupPrefix(String? namespace);
    shared formal String? lookupNamespaceURI(String? prefix);
    shared formal Boolean isDefaultNamespace(String? namespace);
    
    shared formal Node insertBefore(Node node, Node? child);
    shared formal Node appendChild(Node node);
    shared formal Node replaceChild(Node node, Node child);
    shared formal Node removeChild(Node child);
}

shared dynamic Document satisfies Node & GlobalEventHandlers {
    shared formal DOMImplementation implementation;
    shared formal String \iURL;
    shared formal String documentURI;
    shared formal String origin;
    shared formal String compatMode;
    shared formal String characterSet;
    shared formal String contentType;
    
    shared formal DocumentType? doctype;
    shared formal Element? documentElement;
    shared formal HTMLCollection getElementsByTagName(String localName);
    shared formal HTMLCollection getElementsByTagNameNS(String? namespace, String localName);
    shared formal HTMLCollection getElementsByClassName(String classNames);
    
    shared formal Element createElement(String localName);
    shared formal Element createElementNS(String? namespace, String qualifiedName);
    shared formal DocumentFragment createDocumentFragment();
    shared formal Text createTextNode(String data);
    shared formal Comment createComment(String data);
    shared formal ProcessingInstruction createProcessingInstruction(String target, String data);
    
    shared formal Node importNode(Node node, Boolean deep = false);
    shared formal Node adoptNode(Node node);
    
    shared formal Event createEvent(String \iinterface);
    
    shared formal Range createRange();
    
    shared formal NodeIterator createNodeIterator(Node root, Integer whatToShow = #FFFFFFFF, NodeFilter? filter = null);
    shared formal TreeWalker createTreeWalker(Node root, Integer whatToShow = #FFFFFFFF, NodeFilter? filter = null);

    // Extensions provided by http://www.w3.org/TR/html5/dom.html#document

    // resource metadata management
    shared formal Location? location;
    shared formal variable String domain;
    shared formal String referrer;
    shared formal variable String cookie;
    shared formal String lastModified;
    see (`interface DocumentReadyState`)
    shared formal String readyState;
    
    // DOM tree accessors
    // TODO getter object (String name);
    shared formal variable String title;
    shared formal variable String dir;
    shared formal variable HTMLElement? body;
    shared formal HTMLHeadElement? head;
    shared formal HTMLCollection images;
    shared formal HTMLCollection embeds;
    shared formal HTMLCollection plugins;
    shared formal HTMLCollection links;
    shared formal HTMLCollection forms;
    shared formal HTMLCollection scripts;
    shared formal NodeList getElementsByName(String elementName);
    
    // dynamic markup insertion
    see (`function openDocument`)
    see (`function openWindow`)
    shared formal Document|WindowProxy open(String typeOrUrl = "text/html",
        String replaceOrName = "", String features = "", Boolean replace = false);
    
    shared formal void close();
    // TODO should be String* but it displays [Object object]
    shared formal void write(String text);
    // TODO should be String* but it displays [Object object]
    shared formal void writeln(String text);
    
    // user interaction
    shared formal WindowProxy? defaultView;
    shared formal Element? activeElement;
    shared formal Boolean hasFocus();
    shared formal variable String designMode;
    shared formal Boolean execCommand(String commandId, Boolean showUI = false, String val = "");
    shared formal Boolean queryCommandEnabled(String commandId);
    shared formal Boolean queryCommandIndeterm(String commandId);
    shared formal Boolean queryCommandState(String commandId);
    shared formal Boolean queryCommandSupported(String commandId);
    shared formal String queryCommandValue(String commandId);
    
    // special event handler IDL attributes that only apply to Document objects
    shared formal EventHandler onreadystatechange;
}

shared interface DocumentReadyState {
    shared String loading => "loading";
    shared String interactive => "interactive";
    shared String complete => "complete";
}

shared Document document => window.document;


// to disambiguate document.open
shared Document openDocument(String type = "text/html", String replace = "") {
    assert (is Document doc = document.open(type, replace));
    return doc;
}

// to disambiguate document.open
shared WindowProxy openWindow(String url, String name, String features,
    Boolean replace = false) {
    
    assert (is WindowProxy doc = document.open(url, name, features, replace));
    return doc;
}

shared dynamic DOMImplementation {
    shared formal DocumentType createDocumentType(String qualifiedName, String publicId, String systemId);
    shared formal XMLDocument createDocument(String? namespace, String? qualifiedName, DocumentType? doctype = null);
    shared formal Document createHTMLDocument(String title);
    
    shared formal Boolean hasFeature(); // useless; always returns true   
}

shared dynamic DocumentType satisfies Node {
    shared formal String name;
    shared formal String publicId;
    shared formal String systemId;
}

shared dynamic XMLDocument satisfies Document {
    
}

shared dynamic DocumentFragment satisfies Node {
    
}

shared dynamic CharacterData satisfies Node {
    shared formal variable String data;
    shared formal Integer length;
    shared formal String substringData(Integer offset, Integer count);
    shared formal void appendData(String data);
    shared formal void insertData(Integer offset, String data);
    shared formal void deleteData(Integer offset, Integer count);
    shared formal void replaceData(Integer offset, Integer count, String data);  
}

shared dynamic Text satisfies CharacterData {
    shared formal Text splitText(Integer offset);
    shared formal String wholeText;
}

shared Text newText(String text = "") => newTextInternal(text);

shared dynamic Comment satisfies CharacterData {
}

shared Comment newComment(String data = "") => newCommentInternal(data);

shared dynamic ProcessingInstruction satisfies CharacterData {
    shared formal String target;
}

shared dynamic Element satisfies Node {
    shared formal String? namespaceURI;
    shared formal String? prefix;
    shared formal String localName;
    shared formal String tagName;
    
    shared formal variable String id;
    shared formal variable String className;
    shared formal DOMTokenList classList;
    
    shared formal NamedNodeMap attributes;
    shared formal String? getAttribute(String name);
    shared formal String? getAttributeNS(String? namespace, String localName);
    shared formal void setAttribute(String name, String val);
    shared formal void setAttributeNS(String? namespace, String name, String val);
    shared formal void removeAttribute(String name);
    shared formal void removeAttributeNS(String? namespace, String localName);
    shared formal Boolean hasAttribute(String name);
    shared formal Boolean hasAttributeNS(String? namespace, String localName);
    
    
    shared formal HTMLCollection getElementsByTagName(String localName);
    shared formal HTMLCollection getElementsByTagNameNS(String? namespace, String localName);
    shared formal HTMLCollection getElementsByClassName(String classNames);
    
    // defined in https://w3c.github.io/DOM-Parsing/#extensions-to-the-element-interface
    shared formal variable String innerHTML;
    shared formal variable String outerHTML;
    shared formal void insertAdjacentHTML (String position, String text);
}

shared dynamic Attr {
  shared formal String? namespaceURI;
  shared formal String? prefix;
  shared formal String localName;
  shared formal String name;
  shared formal variable String \ivalue;

  shared formal Boolean specified; // useless; always returns true
}

shared dynamic NamedNodeMap {
    shared formal Node getNamedItem(String name);
    shared formal Node setNamedItem(Node arg);
    shared formal Node removeNamedItem(String name);
    shared formal Node item(Integer index);
    shared formal Integer length;
    
    // Introduced in DOM Level 2:
    shared formal Node getNamedItemNS(String namespaceURI, String localName);
    shared formal Node setNamedItemNS(Node arg);
    shared formal Node removeNamedItemNS(String namespaceURI, String localName);
}

shared dynamic NodeList {
    shared formal Node? item(Integer index);
    shared formal Integer length;
    // TODO iterable<Node>;
}

shared dynamic HTMLCollection {
    shared formal Integer length;
    shared formal Element? item(Integer index);
    shared formal Element? namedItem(String name);
}
