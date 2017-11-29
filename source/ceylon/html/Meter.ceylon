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
 The __&lt;meter&gt;__ element represents either a scalar value within a known 
 range or a fractional value.
 
 Technical details about this element can be found on the
 [Official W3C reference](https://www.w3.org/TR/html5/document-metadata.html#the-meter-element).
 "
tagged("flow", "phrasing")
shared class Meter(
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
    "Attribute specifies the current numeric value. This must be between the minimum and maximum values (min attribute and max attribute) if they are specified. If unspecified or malformed, the value is 0. If specified, but not within the range given by the min attribute and max attribute, the value is equal to the nearest end of the range."
    Attribute<Float> val = null,
    "Attribute specifies the lower numeric bound of the measured range. This must be less than the maximum value (max attribute), if specified. If unspecified, the minimum value is 0."
    Attribute<Float> min = null,
    "Attribute specifies the upper numeric bound of the measured range. This must be greater than the minimum value (min attribute), if specified. If unspecified, the maximum value is 1."
    Attribute<Float> max = null,
    "Attribute the upper numeric bound of the low end of the measured range. This must be greater than the minimum value (min attribute), and it also must be less than the high value and maximum value (high attribute and max attribute, respectively), if any are specified. If unspecified, or if less than the minimum value, the low value is equal to the minimum value."
    Attribute<Float> low = null,
    "Attribute the lower numeric bound of the high end of the measured range. This must be less than the maximum value (max attribute), and it also must be greater than the low value and minimum value (low attribute and min attribute, respectively), if any are specified. If unspecified, or if greater than the maximum value, the high value is equal to the maximum value."
    Attribute<Float> high = null,
    "Attribute indicates the optimal numeric value. It must be within the range (as defined by the min attribute and max attribute). When used with the low attribute and high attribute, it gives an indication where along the range is considered preferable. For example, if it is between the min attribute and the low attribute, then the lower range is considered preferred."
    Attribute<Float> optimim = null,
    "Attribute associates the element with a form element that has ownership of the meter element. For example, a meter might be displaying a range corresponding to an input element of type number. This attribute is only used if the meter element is being used as a form-associated element; even then, it may be omitted if the element appears as a descendant of a form element."
    Attribute<String> form = null,
    "The attributes associated with this element."
    Attributes attributes = [],
    "The children of this element."
    shared actual {Content<PhrasingCategory>*} children = [])
        extends Element("meter", id, clazz, accessKey, contentEditable, contextMenu, dir, draggable, dropZone, hidden, lang, spellcheck, style, tabIndex, title, translate, 
                        [attributeEntry("value", val),
                         attributeEntry("min", min),
                         attributeEntry("max", max),
                         attributeEntry("low", low),
                         attributeEntry("high", high),
                         attributeEntry("optimim", optimim),
                         attributeEntry("form", form),
                        *attributes], children)
        satisfies FlowCategory & PhrasingCategory {
}