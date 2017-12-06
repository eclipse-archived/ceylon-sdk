/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a _node_ in the HTML document."
shared abstract class Node(
    "The name of this node."
    shared String nodeName,
    "The attributes associated with this node."
    shared Attributes attributes = [],
    "The children of this node."
    shared default {Content<Node>*} children = [])
        of Comment | Raw | ProcessingInstruction | Element {
    
    "A string representing this node and all children."
    shared actual String string {
        value builder = StringBuilder();
        renderTemplate(this, builder.append);
        return builder.string;
    }
    
}


"Alias for node child type. Usually parameterized with _category_ interface 
 to define permitted node content."
shared alias Content<Item> => 
        <CharacterData|<Item&Node>> |
        <CharacterData|<Item&Node>>() |
        {<CharacterData|<Item&Node>>*} |
        {<CharacterData|<Item&Node>>*}() |
        Null;


"Alias for nodes that contains character data."
shared alias CharacterData => String | Raw | Comment | ProcessingInstruction;


"Represents a _comment_ in the HTML document, although it is generally not visually shown, 
 such comments are available to be read in the source view. Comments are represented as 
 content between &lt;!-- and --&gt;."
shared class Comment(
    "The textual data contained in this comment."
    shared String data)
        extends Node("#comment") {
    
    shared actual {String+} children = { data };
    
}

"Represents _raw HTML_. Raw content is not escaped."
shared class Raw(
	"The raw HTML content"
	shared String data) 
    extends Node("raw") {
    
    shared actual {String+} children = { data };
}

"Represents a _processing instruction_."
shared class ProcessingInstruction(
    "The target of this processing instruction."
    shared String target,
    "The content of this processing instruction."
    shared String data)
        extends Node(target) {
    
    shared actual [] children = [];
    
}