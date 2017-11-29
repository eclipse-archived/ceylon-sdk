/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute that represents the type of the control to display.."
tagged("enumerated attribute")
shared class InputType
        of button | checkbox | color | date | datetime | datetimeLocal | email |
           file | hidden | image | month | number | password | radio | range | 
           reset | search | submit | tel | text | time | url | week 
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "A push button with no default behavior."
    shared new button {
        attributeValue = "button";
    }
    
    "A check box. You must use the value attribute to define the value submitted 
     by this item. Use the checked attribute to indicate whether this item is 
     selected. You can also use the indeterminate attribute to indicate that 
     the checkbox is in an indeterminate state (on most platforms, this 
     draws a horizontal line across the checkbox)."
    shared new checkbox {
        attributeValue = "checkbox";
    }
    
    "A control for specifying a color. A color picker's UI has no required features 
     other than accepting simple colors as text."
    shared new color {
        attributeValue = "color";
    }
    
    "A control for entering a date (year, month, and day, with no time)."
    shared new date {
        attributeValue = "date";
    }
    
    "A control for entering a date and time (hour, minute, second, and fraction of a second) 
     based on UTC time zone. This feature has been removed from WHATWG HTML."
    shared new datetime {
        attributeValue = "datetime";
    }
    
    "A control for entering a date and time, with no time zone."
    shared new datetimeLocal {
        attributeValue = "datetime-local";
    }
    
    "A field for editing an e-mail address. The input value is validated to contain either 
     the empty string or a single valid e-mail address before submitting. The :valid 
     and :invalid CSS pseudo-classes are applied as appropriate."
    shared new email {
        attributeValue = "email";
    }
    
    "A control that lets the user select a file. Use the accept attribute to define 
     the types of files that the control can select."
    shared new file {
        attributeValue = "file";
    }
    
    "A control that is not displayed, but whose value is submitted to the server."
    shared new hidden {
        attributeValue = "hidden";
    }
    
    "A graphical submit button. You must use the src attribute to define the source of 
     the image and the alt attribute to define alternative text. You can use the height 
     and width attributes to define the size of the image in pixels."
    shared new image {
        attributeValue = "image";
    }
    
    "A control for entering a month and year, with no time zone."
    shared new month {
        attributeValue = "month";
    }
    
    "A control for entering a floating point number."
    shared new number {
        attributeValue = "number";
    }
    
    "A single-line text field whose value is obscured. Use the maxlength attribute 
     to specify the maximum length of the value that can be entered."
    shared new password {
        attributeValue = "password";
    }
    
    "A radio button. You must use the value attribute to define the value submitted by 
     this item. Use the checked attribute to indicate whether this item is selected 
     by default. Radio buttons that have the same value for the name attribute are in 
     the same radio button group; only one radio button in a group can be selected at a time."
    shared new radio {
        attributeValue = "radio";
    }
    
    "A control for entering a number whose exact value is not important."
    shared new range {
        attributeValue = "range";
    }
    
    "A button that resets the contents of the form to default values."
    shared new reset {
        attributeValue = "reset";
    }
    
    "A single-line text field for entering search strings; line-breaks are automatically 
     removed from the input value."
    shared new search {
        attributeValue = "search";
    }
    
    "A button that submits the form."
    shared new submit {
        attributeValue = "submit";
    }
    
    "A control for entering a telephone number; line-breaks are automatically removed 
     from the input value, but no other syntax is enforced. You can use attributes 
     such as pattern and maxlength to restrict values entered in the control. The :valid 
     and :invalid CSS pseudo-classes are applied as appropriate."
    shared new tel {
        attributeValue = "tel";
    }
    
    "A single-line text field; line-breaks are automatically removed from the input value."
    shared new text {
        attributeValue = "text";
    }
    
    "A control for entering a time value with no time zone."
    shared new time {
        attributeValue = "time";
    }
    
    "A field for editing a URL. The input value is validated to contain either the empty 
     string or a valid absolute URL before submitting. Line-breaks and leading or trailing 
     whitespace are automatically removed from the input value. You can use attributes 
     such as pattern and maxlength to restrict values entered in the control. The :valid 
     and :invalid CSS pseudo-classes are applied as appropriate."
    shared new url {
        attributeValue = "url";
    }
    
    "A control for entering a date consisting of a week-year number and a week number with no time zone."
    shared new week {
        attributeValue = "week";
    }
    
}