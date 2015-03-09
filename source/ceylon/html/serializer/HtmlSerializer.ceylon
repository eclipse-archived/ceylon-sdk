import ceylon.collection {
    LinkedList
}

class HtmlSerializer(
            Anything(String) print,
            Boolean prettyPrint,
            Boolean escapeNonAscii=false) {

    variable
    value lastOutputWasStartOrEndTag = true;

    variable
    value previousStartOrEndTagWasBlock = false;

    variable
    [String, {<String->Object>*}]? bufferedStartElement = null;

    value bufferedText = StringBuilder();

    value elementStack = LinkedList<String>();

    function escape(String raw, EscapableType type)
        =>  htmlEscape(raw, type, escapeNonAscii, elementStack.top);

    void flushText() {
        if (!bufferedText.empty) {
            // be strict; don't allow text outside of an enclosing element
            assert(exists current = elementStack.top);
            value type = typeForElement(current);
            print(escape(bufferedText.string, type));
            bufferedText.clear();
            lastOutputWasStartOrEndTag = false;
        }
    }

    void flushStartElement(Boolean end = false) {
        if (exists [elementName, attributes] = bufferedStartElement) {
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
                    // so we'll output the end tag separately
                    // http://www.w3.org/TR/html5/syntax.html#start-tags
                    print("></" + escape(elementName, package.name) + ">");
                }
                previousStartOrEndTagWasBlock = prettyPrint
                    && indentElements.contains(elementName.lowercased);
            } else {
                print(">");
                elementStack.push(elementName);
            }
            bufferedStartElement = null;
            lastOutputWasStartOrEndTag = true;
        }
    }

    "[[flush]] is unnecessary if all elements are
     closed with [[endElement]]."
    shared
    void flush() {
        flushText();
        flushStartElement(true);
    }

    shared
    void doctype(String docType) {
        // TODO validate/escape docType
        // just ignore if we are in an element
        if (elementStack.top is Null && bufferedStartElement is Null) {
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
        // TODO disallow child elements in raw and escapableRaw elements?
        // fail fast at the cost of efficiency
        assert(name.isValid(elementName));
        flushText();
        flushStartElement();
        // buffer to simplify close tag if it immediately follows
        bufferedStartElement = [elementName, attributes];
    }

    shared
    void endElement() {
        // bufferedStartElement and bufferedText are
        // mutually exclusive
        if (bufferedStartElement exists) {
            assert(bufferedText.empty);
            flushStartElement(true);
        }
        else {
            flushText();
            assert(exists elementName = elementStack.pop());
            printIndent(elementName, false);
            print("</" + escape(elementName, name) + ">");
            lastOutputWasStartOrEndTag = true;
        }
        if (prettyPrint && elementStack.empty) {
            // end document with a newline
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

    void printIndent(String elementName, Boolean isOpenTag) {
        // * don't print '\n' before the first element
        // * don't indent after character data
        // * indent only block element tags and non-block element tags
        //   immediately following a start or end tag of a block element
        if (prettyPrint
                && !(isOpenTag && elementStack.empty)
                && lastOutputWasStartOrEndTag
                && (previousStartOrEndTagWasBlock
                    || indentElements.contains(elementName.lowercased))) {
            print("\n" + " ".repeat(elementStack.size * 2));
        }
        previousStartOrEndTagWasBlock = prettyPrint
            && indentElements.contains(elementName.lowercased);
    }
}
