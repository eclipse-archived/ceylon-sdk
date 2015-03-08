import ceylon.collection {
    LinkedList
}

class HtmlSerializer(
            Anything(String) print,
            Boolean prettyPrint,
            Boolean escapeNonAscii=false) {

    variable
    [String, {<String->Object>*}]? cachedStartElement = null;

    variable
    value lastWasStartOrEndTag = true;

    variable
    value previousStartOrEndTagWasBlock = false;

    value elementStack = LinkedList<String>();

    value bufferedText = StringBuilder();

    function escape(String raw, EscapableType type)
        =>  htmlEscape(raw, type, escapeNonAscii, elementStack.top);

    void flushText() {
        // we're strict for now;
        // not allowing text outside of an enclosing element
        if (!bufferedText.empty) {
            assert(exists current = elementStack.top);
            value type = typeForElement(current);
            print(escape(bufferedText.string, type));
            bufferedText.clear();
            lastWasStartOrEndTag = false;
        }
    }

    void flushStartElement(Boolean end = false) {
        if (exists [elementName, attributes] = cachedStartElement) {
            printIndent(elementName, true);
            print("<");
            print(escape(elementName, package.name));
            for (name->val in attributes) {
                print(" "
                    + escape(name, package.name)
                    + "=\""
                    + escape(val.string, attributeValue)
                    + "\"");
            }
            if (end) {
                if (voidElements.contains(elementName.lowercased)) {
                    print(">");
                }
                else {
                    // only void and foreign elements can be self-closing,
                    // so we'll output the complete end tag
                    //http://www.w3.org/TR/html5/syntax.html#start-tags
                    print("></" + escape(elementName, package.name) + ">");
                }
                previousStartOrEndTagWasBlock = prettyPrint
                    && indentElements.contains(elementName.lowercased);
            } else {
                print(">");
                elementStack.push(elementName);
            }
            cachedStartElement = null;
            lastWasStartOrEndTag = true;
        }
    }

    shared
    void docType(String docType) {
        // TODO validate/escape docType
        // just ignore if we are in an element
        if (elementStack.top is Null && cachedStartElement is Null) {
            print(docType);
            print("\n");
            if (prettyPrint) {
                print("\n");
            }
        }
    }

    shared
    void startElement(
            String elementName,
            {<String->Object>*} attributes = {}) {
        // TODO disallow elements in raw and escapableRaw elements?
        // fail fast at the cost of efficiency
        assert(name.isValid(elementName));
        flushText();
        flushStartElement();
        cachedStartElement = [elementName, attributes];
    }

    shared
    void endElement() {
        if (cachedStartElement exists) {
            assert(bufferedText.empty);
            flushStartElement(true);
        }
        else {
            flushText();
            assert(exists elementName = elementStack.pop());
            printIndent(elementName, false);
            print("</" + escape(elementName, name) + ">");
            lastWasStartOrEndTag = true;
        }
        if (prettyPrint && elementStack.empty) {
            print("\n");
        }
    }

    shared
    void text(String text) {
        if (!text.empty) {
            flushStartElement();
            bufferedText.append(text);
        }
    }

    shared
    void flush() {
        flushText();
        flushStartElement(true);
    }

    void printIndent(String elementName, Boolean isOpen) {
        // don't print '\n' before the first element
        // don't indent after character data
        // indent only if a block tag, or a child or neighbor of a block tag
        if (prettyPrint
                && !(isOpen && elementStack.empty)
                && lastWasStartOrEndTag
                && (previousStartOrEndTagWasBlock
                    || indentElements.contains(elementName.lowercased))) {
            print("\n" + " ".repeat(elementStack.size * 2));
        }
        previousStartOrEndTagWasBlock = prettyPrint
            && indentElements.contains(elementName.lowercased);
    }
}
