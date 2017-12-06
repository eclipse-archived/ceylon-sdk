/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.html.internal {
    HtmlRenderer
}


"""
   Render given template.
   
   Example: render template to string
   
       value html = Html { ... };
       value builder = StringBuilder();
       renderTemplate(html, builder.append);
     
   Example: render template as response of `ceylon.http.server` server
   
       value server = newServer {
           Endpoint {
               path = equals("/hello");
               service = (req, res) {
                   value html = Html {
                       Body {
                           H1 {"Hello ``req.formParameter("name") else "World"``!"}
                       }
                   };
                   renderTemplate(html, res.writeString);
               };
           }
       };
       server.start();
       
   Example: render template to file via `ceylon.file` module
   
       value html = Html { ... };
       if (is Nil res = home.childPath("hello.html").resource) {
           try (writer = res.createFile().Overwriter("utf-8")) {
               renderTemplate(html, writer.write);
           }
       }
     
"""
shared void renderTemplate(Node node, void write(String string), RenderingConfiguration configuration = RenderingConfiguration()) {
    HtmlRenderer(write, configuration).renderTemplate(node);
}


"Represents rendering configuration."
see(`function renderTemplate`)
shared class RenderingConfiguration(
    "Should the result be minified or formatted?" 
    shared Boolean prettyPrint = true,
    "Should non-ASCII characters be escaped? If `false`, the document's characterset should be UTF-8."
    shared Boolean escapeNonAscii = false,
    "When `prettyPrint==true`, the number of spaces that an indentation level is worth."
    shared Integer indentSize = 2,
    "Should void elements such as `<br>` and `<hr>` be closed, for exampe, `<br />`?"
    shared Boolean closeVoidElements = false) {
}
