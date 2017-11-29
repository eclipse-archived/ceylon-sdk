/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"
 The __&lt;meta&gt;__ element represents any metadata information that cannot be represented by one of the other 
 meta-related elements (&lt;base&gt;, &lt;link&gt;, &lt;script&gt;, &lt;style&gt; or &lt;title&gt;).
 
 Example:
 
 <table style='width:100%'>
     <tr style='vertical-align: top'>
         <td style='border-style:none'>
         
 <pre data-language='ceylon'>
 Head {
     Meta { charset=\"utf-8\"; },
     Meta { name=\"keywords\"; content=\"ceylon, html\"; },
     ...
 };
 </pre>
 
         </td>
         <td style='border-style:none'>
         
 <pre data-language='html'>
 &lt;head&gt;
     &lt;meta charset=\"utf-8\"&gt;
     &lt;meta name=\"keywords\" content=\"ceylon, html\"&gt;
     ...
 &lt;/head&gt;
 </pre>
         </td>         
     </tr>
 </table>
 
 Technical details about this element can be found on the
 [Official W3C reference](https://www.w3.org/TR/html5/document-metadata.html#the-meta-element).
 "
tagged("metadata")
shared class Meta(
    /* GLOBAL ATTRIBUTES - BEGIN */
    "Attribute defines a unique identifier (ID) which must be unique in the whole document. Its purpose is to identify the element when linking (using a fragment identifier), scripting, or styling (with CSS)."
    Attribute<String> id = null,
    "Attribute defines a space-separated list of the classes of the element. Classes allows CSS and JavaScript to select and access specific elements via the class selectors."
    Attribute<String> clazz = null,
    "Attribute provides a hint for generating a keyboard shortcut for the current element. This attribute consists of a space-separated list of characters. The browser should use the first one that exists on the computer keyboard layout."
    Attribute<String> accessKey = null,
    "Attribute indicates if the element should be editable by the user. If so, the browser modifies its widget to allow editing."
    Attribute<Boolean> contentEditable = null,
    "Attribute defines id of an menu element to use as the contextual menu for this element"
    Attribute<String> contextMenu = null,
    "Attribute indicates the directionality of the element's text."
    Attribute<Direction> dir = null,
    "Attribute indicates whether the element can be dragged."
    Attribute<Boolean> draggable = null,
    "Attribute indicates what types of content can be dropped on an element."
    Attribute<DropZone> dropZone = null,
    "Attribute indicates that the element is not yet, or is no longer, relevant. For example, it can be used to hide elements of the page that can't be used until the login process has been completed. The browser won't render such elements. This attribute must not be used to hide content that could legitimately be shown."
    Attribute<Boolean> hidden = null,
    "Attribute specifies the primary language for the element's contents and for any of the element's attributes that contain text. Its value must be a valid BCP 47 language tag, or the empty string. Setting the attribute to the empty string indicates that the primary language is unknown."
    Attribute<String> lang = null,
    "Attribute defines whether the element may be checked for spelling errors."
    Attribute<Boolean> spellcheck = null,
    "Attribute contains CSS styling declarations to be applied to the element. Note that it is recommended for styles to be defined in a separate file or files."
    Attribute<String> style = null,
    "Attribute indicates if the element can take input focus (is focusable), if it should participate to sequential keyboard navigation, and if so, at what position."
    Attribute<Integer> tabIndex = null,
    "Attribute contains a text representing advisory information related to the element it belongs to. Such information can typically, but not necessarily, be presented to the user as a tooltip."
    Attribute<String> title = null,
    "Attribute that is used to specify whether an element's attribute values and the values of its text node children are to be translated when the page is localized, or whether to leave them unchanged."
    Attribute<Boolean> translate = null,
    /* GLOBAL ATTRIBUTES - END */
    "Attribute defines the name of document-level metadata. It should not be set if one of the attributes itemprop, http-equiv or charset is also set."
    Attribute<String> name = null,
    "Attribute defines the pragma that can alter servers and user-agents behavior."
    Attribute<String> httpEquiv = null,
    "Attribute gives the value associated with the http-equiv or name attribute, depending of the context."
    Attribute<String> content = null,
    "Attribute declares the character encoding used of the page. It can be locally overridden using the lang attribute on any element. This attribute is a literal string and must be one of the preferred MIME names for a character encoding."
    Attribute<String> charset = null,
    "The attributes associated with this element."
    Attributes attributes = [])
        extends Element("meta", id, clazz, accessKey, contentEditable, contextMenu, dir, draggable, dropZone, hidden, lang, spellcheck, style, tabIndex, title, translate, 
                   [attributeEntry("name", name), 
                    attributeEntry("http-equiv", httpEquiv), 
                    attributeEntry("content", content), 
                    attributeEntry("charset", charset), 
                   *attributes], [])
        satisfies MetadataCategory {
    
    "This element has no children."
    shared actual [] children = [];
    
}