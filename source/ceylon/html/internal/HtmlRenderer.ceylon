/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.html {
    ...
}

shared class HtmlRenderer(void write(String string), RenderingConfiguration configuration) {
    
    value bufferedText = StringBuilder();
    value elementStack = Stack<String>();
    variable value presOnStack = 0;
    value prettyPrint => configuration.prettyPrint && presOnStack == 0;
    variable value lastOutputWasStartOrEndTag = true;
    variable value previousStartOrEndTagWasBlock = false;
    variable [String, {<String->Object>*}]? bufferedStartElement = null;
    value indentSize = configuration.indentSize;
    
    shared void renderTemplate(Node root) => visit(root);
    
    void visit(Node node) {
        switch (node)
        case (Comment) {
            visitComment(node);
        }
        case (ProcessingInstruction) {
            visitProcessingInstruction(node);
        }
        case (Element) {
            visitElement(node);
        }
        case (Raw) {
            visitRaw(node);
        }
    }
    
    void visitComment(Comment node) {
        flush();
        write("<!-- `` node.data `` -->"); // escape?
    }
    
    void visitRaw(Raw node) {
        flush();
        write(node.data);
        lastOutputWasStartOrEndTag = false;
    }
    
    void visitProcessingInstruction(ProcessingInstruction node) {
        flush();
        write("<?``node.target`` ``node.data`` ?>"); // escape?
    }
    
    void visitElement(Element node) {
        if (is Html node) {
            write(node.doctype.string);
            write("\n");
        }
        
        startElement(node.tagName, node.attributes.map(resolveAttribute).coalesced);
        for (child in node.children) {
            visitChild(child);
        }
        endElement();
    }
    
    void visitChild(Content<Node> child) {
        if (is Null child) {
            // noop
        }
        else if (is String child) {
            text(child);
        }
        else if (is Node child) {
            visit(child);
        }
        else if (is {<String|Node>*} child) {
            child.each(visitChild);
        }
        else {
            visitChild(child());
        }
    }
    
    <String->String>? resolveAttribute(AttributeEntry? attribute) {
        if(exists attribute) {
            String attributeName = attribute.key;
            String? attributeValue;
            
            if( is String val = attribute.item) {
                attributeValue = val;
            }
            else if( is String?() val = attribute.item ) {
                attributeValue = val();
            }
            else if( is Integer val = attribute.item ) {
                attributeValue = val.string; 
            }
            else if( is Integer?() val = attribute.item ) {
                attributeValue = val()?.string;
            }
            else if( is Float val = attribute.item ) {
                attributeValue = val.string; 
            }
            else if( is Float?() val = attribute.item ) {
                attributeValue = val()?.string;
            }
            else if( is Boolean val = attribute.item ) {
                attributeValue = val then attributeName else null;
            }
            else if( is Boolean?() val = attribute.item ) {
                attributeValue = (val() else false) then attributeName else null;
            }
            else if( is AttributeValueProvider val = attribute.item ) {
                attributeValue = val.attributeValue;
            }
            else if( is AttributeValueProvider?() val = attribute.item ) {
                attributeValue = val()?.attributeValue;
            }
            else {
                attributeValue = null;
            }
            
            if( exists attributeValue ) {
                return attributeName->attributeValue;
            }
        }
        return null;
    }
    
    void startElement(String elementName, {<String->String>*} attributes) {
        // TODO disallow child elements in raw and escapableRaw elements?
        assert(name.isValid(elementName));
        flushText();
        flushStartElement();
        bufferedStartElement = [elementName, attributes]; // buffer to simplify close tag if it immediately follows
    }
    
    void endElement() {
        // bufferedStartElement and bufferedText are mutually exclusive
        if (bufferedStartElement exists) {
            assert(bufferedText.empty);
            flushStartElement(true);
        }
        else {
            flushText();
            assert(exists elementName = elementStack.pop());
            printIndent(elementName, false);
            // only update presOnStack after we've emitted any indent
            presOnStack -= elementName == "pre" then 1 else 0;
            write("</" + escape(elementName, name) + ">");
            lastOutputWasStartOrEndTag = true;
        }
        if (prettyPrint && elementStack.empty) {
            write("\n");
        }
    }
    
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
            || elementName.lowercased in indentElements)) {
            write("\n" + " ".repeat(elementStack.size * indentSize));
        }
        previousStartOrEndTagWasBlock = prettyPrint
                && elementName.lowercased in indentElements;
    }
    
    void flush() {
        flushText();
        flushStartElement();
    }
    
    void flushText() {
        if (!bufferedText.empty) {
            // be strict; don't allow text outside of an enclosing element
            assert(exists current = elementStack.top);
            value type = typeForElement(current);
            write(escape(bufferedText.string, type));
            bufferedText.clear();
            lastOutputWasStartOrEndTag = false;
        }
    }
    
    void flushStartElement(Boolean end = false) {
        if (exists [elementName, attributes] = bufferedStartElement) {
            printIndent(elementName, true);
            write("<");
            write(escape(elementName, package.name));
            for (name->val in attributes) {
                write(" "
                    + escape(name, package.name)
                        + "=\""
                        + escape(val.string, attributeValue)
                        + "\"");
            }
            if (end) {
                if (elementName.lowercased in voidElements) {
                    if (configuration.closeVoidElements) {
                        write(" /");
                    }
                    write(">");
                }
                else {
                    // only void and foreign elements can be self-closing,
                    // so we'll output the end tag separately
                    // http://www.w3.org/TR/html5/syntax.html#start-tags
                    write("></" + escape(elementName, package.name) + ">");
                }
                previousStartOrEndTagWasBlock = prettyPrint
                        && elementName.lowercased in indentElements;
            } else {
                write(">");
                presOnStack += elementName == "pre" then 1 else 0;
                elementStack.push(elementName);
            }
            bufferedStartElement = null;
            lastOutputWasStartOrEndTag = true;
        }
    }
    
    String escape(String raw, EscapableType type) {
        return htmlEscape(raw, type, configuration.escapeNonAscii, elementStack.top);
    }
    
}

class Stack<Element>()
        given Element satisfies Object {
    variable {Element*} elements = {};
    variable value elementsSize = 0;

    shared Integer size => elementsSize;
    shared Boolean empty => size == 0;

    "The element currently at the top of the stack, or null
     if the stack is empty."
    shared Element? top => elements.first;

    "Remove and return the element at the top of the stack."
    shared Element? pop() {
        value result = elements.first;
        elements = elements.rest;
        if (result exists) {
            elementsSize--;
        }
        return result;
    }

    "Push a new element onto the top of the stack."
    shared void push(Element element) {
        elements = elements.follow(element);
        elementsSize++;
    }
}
