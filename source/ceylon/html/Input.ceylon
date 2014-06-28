"Represents a typed data field, usually with a form control
 to allow the user to edit the data.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-input-element)"
shared class Input(String? name = null, type = text, accept = null, autoComplete = null,
            Boolean? autoFocus = null, checked = null, dirName = null,
            Boolean? disabled = null, String? form = null, formAction = null,
            formEnctype = null, formMethod = null, formTarget = null,
            Boolean? formNoValidate = null, inputMode = null, list = null,
            maxLength = null, minLength = null, max = null, min = null,
            multiple = null, pattern = null, placeholder = null,
            Boolean? readOnly = null, Boolean? required = null,
            size = null, step = null, String? valueOf = null,
            alt = null, src = null, height = null, width = null,
            String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty)
        extends FormElement(name, autoFocus, disabled, form, formNoValidate,
            readOnly, required, valueOf, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies InlineElement {

    "Controls the data type (and associated control)
     of the element."
    shared InputType|ButtonType type;

    "May be specified to provide user agents with
     a hint of what file types will be accepted."
    shared String? accept;

    "Can be used to hint to the user agent how to,
     or indeed whether to, provide the information
     prefilling feature (when available)."
    shared Boolean? autoComplete;

    "Specifies that the input should be pre-selected
     when the page loads .
     Only valid when [[Input.type]] is [[checkbox]] or [[radio]]"
    shared Boolean? checked;

    "Enables the submission of the directionality
     of the element, and gives the name of the field
     that contains this value during form submission."
    shared String? dirName;

    "Specifies the action URL when the form is submitted.
     Only valid when [[Input.type]] is [[submit]] or [[image]]"
    shared String? formAction;

    "Specifies how the form-data should be encoded
     when submitting it to the server.
     Only valid when [[Input.type]] is [[submit]] or [[image]]"
    shared String? formEnctype;

    "Defines the HTTP method for sending data to the action URL.
     Only valid when [[Input.type]] is [[submit]] or [[image]]"
    shared String? formMethod;

    "Specifies where to display the response that is
     received after submitting the form.
     Only valid when [[Input.type]] is [[submit]] or [[image]]"
    shared String? formTarget;

    "Specifies what kind of input mechanism is the
     most helpful for this input."
    shared InputMode? inputMode;

    "Refers to a [[DataList]] element that contains
     pre-defined options for this field."
    shared String? list;

    "Specifies the maximum number of characters allowed."
    shared Integer? maxLength;

    "Specifies the minimum number of characters allowed."
    shared Integer? minLength;

    "Specifies a maximum value for this field."
    shared Integer|String? max;

    "Specifies a minimum value for this field."
    shared Integer|String? min;

    "Specifies that a user can enter more
     than one value in this field."
    shared Boolean? multiple;

    "Specifies a regular expression that this
     field's value is checked against."
    shared String? pattern;

    "Specifies a short hint that describes
     the expected value of this field."
    shared String? placeholder;

    "Specifies the width, in characters."
    shared Integer? size;

    "Specifies the legal number intervals for
     this input field."
    shared Integer? step;

    "Provides the textual label for the button for users
     and user agents who cannot use the image.
     Use only when [[Input.type]] is [[image]]"
    shared String? alt;

    "Specifies the URL of the image to use as a button
     (only when [[type]] is [[image]])"
    shared String? src;

    "Specifies the height of he image
     (only when [[type]] is [[image]])"
    shared Integer? height;

    "Specifies the width of he image
     (only when [[type]] is [[image]])"
    shared Integer? width;

    shared default actual Tag tag = Tag("input", emptyTag);

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("type", type);
        attrs.addNamedBooleanAttribute("checked", checked);
        attrs.addAttribute("placeholder", placeholder);

        attrs.addAll(super.attributes);

        attrs.addAttribute("accept", accept);
        attrs.addOnOffBooleanAttribute("autocomplete", autoComplete);
        attrs.addAttribute("dirname", dirName);

        attrs.addAttribute("formaction", formAction);
        attrs.addAttribute("formenctype", formEnctype);
        attrs.addAttribute("formmethod", formMethod);
        attrs.addAttribute("formtarget", formTarget);

        attrs.addAttribute("inputmode", inputMode);
        attrs.addAttribute("list", list);
        attrs.addAttribute("maxlength", maxLength);
        attrs.addAttribute("minlength", minLength);
        attrs.addAttribute("max", max);
        attrs.addAttribute("min", min);
        attrs.addNamedBooleanAttribute("multiple", multiple);
        attrs.addAttribute("pattern", pattern);
        attrs.addAttribute("size", size);
        attrs.addAttribute("step", step);

        attrs.addAttribute("src", src);
        attrs.addAttribute("alt", alt);
        attrs.addAttribute("height", height);
        attrs.addAttribute("width", width);

        return attrs.sequence();
    }

}

"Controls the data type (and associated control) of the element.
 
 Technical details about this attribute can be found on the
 [Official W3C reference](http://www.w3.org/html/wg/drafts/html/master/forms.html#attr-input-type)"
shared abstract class InputType(String type)
        of checkbox | color | date | datetime
        | datetimeLocal | email | file | hidden | image | month
        | number | password | radio | range | searchInput
        | tel | text | time | url | week {

    string => type;

}

"Defines a checkbox control. The data type is a set
 of zero or more values from a predefined list."
shared object checkbox extends InputType("checkbox") {}

"Defines a color picker control. The data type is
 an sRGB color with 8-bit red, green, and blue components."
shared object color extends InputType("color") {}

"Defines a date control. The data type is a date
 (year, month, day) with no time zone."
shared object date extends InputType("date") {}

"A date and time control. The data type is a date and time
 (year, month, day, hour, minute, second, fraction of a second)
 with the time zone set to UTC."
shared object datetime extends InputType("datetime") {}

"A date and time control. The data type is a date and time
 (year, month, day, hour, minute, second, fraction of a second)
 with no time zone."
shared object datetimeLocal extends InputType("datetime-local") {}

"A text field with an e-mail address or list of e-mail addresses."
shared object email extends InputType("email") {}

"Defines a file-select field and a 'Browse...'
 button (for file uploads)."
shared object file extends InputType("file") {}

"Defines a hidden input field that can hold any
 [[String]] as value."
shared object hidden extends InputType("hidden") {}

"Defines an image as a submit button."
shared object image extends InputType("image") {}

"A month control. The data type is a date consisting
 of a year and a month with no time zone."
shared object month extends InputType("month") {}

""
shared object number extends InputType("number") {}

""
shared object password extends InputType("password") {}

""
shared object radio extends InputType("radio") {}

""
shared object range extends InputType("range") {}

""
shared object searchInput extends InputType("search") {}

""
shared object tel extends InputType("tel") {}

""
shared object text extends InputType("text") {}

"A time control. The data type is a time
 (hour, minute, seconds, fractional seconds)
 with no time zone."
shared object time extends InputType("time") {}

""
shared object url extends InputType("url") {}

"A week control. The data type is a date consisting
 of a year and a month with no time zone."
shared object week extends InputType("week") {}


"Specifies what kind of input mechanism would be most
 helpful for users entering content into the form input.
 
 Technical details about this attribute can be found on the
 [Official W3C reference](http://www.w3.org/html/wg/drafts/html/master/forms.html#attr-fe-inputmode)"
shared abstract class InputMode(String mode)
        of verbatim | latin | latinName | latinProse
        | fullWidthLatin | kana | katakana {
    string => mode;
}

"Alphanumeric Latin-script input of non-prose content,
 e.g. usernames, passwords, product codes."
shared object verbatim extends InputMode("verbatim") {}

"Latin-script input in the user's preferred language(s),
 with some typing aids enabled (e.g. text prediction)."
shared object latin extends InputMode("latin") {}

"Latin-script input in the user's preferred language(s),
 with typing aids intended for entering human names enabled
 (e.g. text prediction from the user's contact list and
 automatic capitalisation at every word)."
shared object latinName extends InputMode("latin-name") {}

"Latin-script input in the user's preferred language(s),
 with aggressive typing aids intended for human-to-human
 communications enabled (e.g. text prediction and automatic
 capitalisation at the start of sentences)."
shared object latinProse extends InputMode("latin-prose") {}

"Latin-script input in the user's secondary language(s),
 using full-width characters, with aggressive typing aids
 intended for human-to-human communications enabled (e.g.text
 prediction and automatic capitalisation at the start of sentences)."
shared object fullWidthLatin extends InputMode("full-width-latin") {}

"Kana or romaji input, typically hiragana input, using full-width
 characters, with support for converting to kanji.
 Intended for Japanese text input."
see(`value katakana`)
shared object kana extends InputMode("kana") {}

"Katakana input, using full-width characters, with support
 for converting to kanji. Intended for Japanese text input."
see(`value kana`)
shared object katakana extends InputMode("katakana") {}
