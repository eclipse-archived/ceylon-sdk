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
 The __&lt;area&gt;__ element defines a hot-spot region on an image, and optionally 
 associates it with a hypertext link. This element is used only within a &lt;map&gt; element.
 
 Technical details about this element can be found on the
 [Official W3C reference](https://www.w3.org/TR/html5/grouping-content.html#the-area-element).
"
tagged("flow", "phrasing")
shared class Area(
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
    "Attribute contains a text to display on browsers that do not display images. The text should be phrased so that it presents the user with the same kind of choice as the image would offer when displayed without the alternative text."
    Attribute<String> alt = null,
    "Attribute contains a set of values specifying the coordinates of the hot-spot region. The number and meaning of the values depend upon the value specified for the shape attribute."
    Attribute<String> coords = null,
    "Attribute, if present, indicates that the author intends the hyperlink to be used for downloading a resource."
    Attribute<String> download = null,
    "Attribute contains the hyperlink target for the area. Its value is a valid URL."
    Attribute<String> href = null,
    "Attribute indicates the language of the linked resource. Allowed values are determined by BCP47. Use this attribute only if the href attribute is present."
    Attribute<String> hreflang = null,
    "Attribute contains a hint of the media for which the linked resource was designed, for example print and screen. If omitted, it defaults to all. Use this attribute only if the href attribute is present."
    Attribute<String> media = null,
    "Attribute for anchors containing the href attribute, this attribute specifies the relationship of the target object to the link object."
    Attribute<String> rel = null,
    "Attribute specifies the shape of the associated hot spot."
    Attribute<Shape> shape = null,
    "Attribute specifies where to display the linked resource. In HTML4, this is the name of, or a keyword for, a frame. In HTML5, it is a name of, or keyword for, a browsing context (for example, tab, window, or inline frame)."
    Attribute<String> target = null,
    "Attribute specifies the media type in the form of a MIME type for the link target. Generally, this is provided strictly as advisory information; however, in the future a browser might add a small icon for multimedia types."
    Attribute<String>|Attribute<MimeType> type = null,
    "The attributes associated with this element."
    Attributes attributes = [],
    "The children of this element."
    shared actual {Content<PhrasingCategory>*} children = [])
        extends Element("area", id, clazz, accessKey, contentEditable, contextMenu, dir, draggable, dropZone, hidden, lang, spellcheck, style, tabIndex, title, translate, 
                    [attributeEntry("alt", alt),
                     attributeEntry("coords", coords),
                     attributeEntry("download", download),
                     attributeEntry("href", href),
                     attributeEntry("hreflang", hreflang),
                     attributeEntry("media", media),
                     attributeEntry("rel", rel),
                     attributeEntry("shape", shape),
                     attributeEntry("target", target),
                     attributeEntry("type", type),
                    *attributes], children)
        satisfies FlowCategory & PhrasingCategory {
}