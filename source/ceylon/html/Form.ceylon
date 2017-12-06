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
 The __&lt;form&gt;__ element represents a document section that contains 
 interactive controls to submit information to a web server.
 
 Example:
 
 <table style='width:100%'>
     <tr style='vertical-align: top'>
         <td style='width:50%; border-style:none'>
         
 <pre data-language='ceylon'>
 Form { method = FormMethod.post;
     Label{ \"User name\", Input { id = \"username\"; type = InputType.text; }},
     Label{ \"Password\", Input { id = \"password\"; type = InputType.password; }},
     Input{ val = \"Login\"; type = InputType.submit; }
 };
 </pre>
 
         </td>
         <td style='border-style:none'>
         
 <pre data-language='html'>
  &lt;form method=\"post\"&gt;
     &lt;label&gt;User name &lt;input id=\"username\" type=\"text\"&gt;&lt;/label&gt;
     &lt;label&gt;Password &lt;input id=\"password\" type=\"password\"&gt;&lt;/label&gt;
     &lt;input value=\"Login\" type=\"submit\"&gt;
 &lt;/form&gt;
 </pre>
 
         </td>         
     </tr>
 </table>
 
 Technical details about this element can be found on the
 [Official W3C reference](https://www.w3.org/TR/html5/document-metadata.html#the-form-element).
 "
tagged("flow")
shared class Form(
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
    "Attribute specifies a space- or comma-delimited list of character encodings that the server accepts."
    Attribute<String> acceptCharset = null,
    "Attribute specifies the URI of a program that processes the information submitted by the button. If specified, it overrides the action attribute of the button's form owner."
    Attribute<String> action = null,
    "Attribute indicates whether input elements can by default have their values automatically completed by the browser. This setting can be overridden by an autocomplete attribute on an element belonging to the form."
    Attribute<Boolean> autocomplete = null,
    "Attribute specifies the type of content that is used to submit the form to the server."
    Attribute<String>|Attribute<FormEnctype> enctype = null,
    "Attribute specifies the HTTP method that the browser uses to submit the form."
    Attribute<String>|Attribute<FormMethod> method = null,
    "Attribute represents the name of the form."
    Attribute<String> name = null,
    "Attribute indicates that the form is not to be validated when submitted. If this attribute is not specified (and therefore the form is validated), this default setting can be overridden by a formnovalidate attribute."
    Attribute<Boolean> novalidate = null,
    "Attribute is a name or keyword indicating where to display the response that is received after submitting the form."
    Attribute<String>|Attribute<FormTarget> target = null,
    "The attributes associated with this element."
    Attributes attributes = [],
    "The children of this element."
    shared actual {Content<FlowCategory>*} children = [])
        extends Element("form", id, clazz, accessKey, contentEditable, contextMenu, dir, draggable, dropZone, hidden, lang, spellcheck, style, tabIndex, title, translate, 
                        [attributeEntry("accept-charset", acceptCharset),
                         attributeEntry("action", action),
                         attributeEntry("autocomplete", attributeValueOnOff(autocomplete)),
                         attributeEntry("enctype", enctype),
                         attributeEntry("method", method),
                         attributeEntry("name", name),
                         attributeEntry("novalidate", novalidate),
                         attributeEntry("target", target),
                          *attributes], children)
        satisfies FlowCategory {
}