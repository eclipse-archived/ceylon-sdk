import ceylon.collection {
    Stack,
    LinkedList
}

class HtmlSerializer(Anything(String) print, Boolean prettyPrint, Boolean escapeNonAscii=false) {

    variable
    [String, {<String->Object>*}]? cachedStartElement = null;

    Stack<String> elementStack = LinkedList<String>();

    StringBuilder bufferedText = StringBuilder();

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
        }
    }

    void flushStartElement(Boolean end = false) {
        if (exists [elementName, attributes] = cachedStartElement) {
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
            } else {
                print(">");
                elementStack.push(elementName);
            }
        }
        cachedStartElement = null;
    }

    shared
    void docType(String docType) {
        // FIXME validate/escape docType
        // just ignore if we are in an element
        if (elementStack.top is Null && cachedStartElement is Null) {
            print(docType);
            print("\n");
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
            print("</" + escape(elementName, name) + ">");
        }
    }

    shared
    void text(String text) {
        flushStartElement();
        bufferedText.append(text);
    }

    shared
    void flush() {
        flushText();
        flushStartElement(true);
    }
}
