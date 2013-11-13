import ceylon.html { hiddenType=hidden }

shared class TextInput(String name, String? valueOf = null, InputType type = text,
            String? accept = null, Boolean? autoComplete = null,
            Boolean? autoFocus = null, String? dirName = null,
            Boolean? disabled = null, String? form = null,
            Boolean? formNoValidate = null, InputMode? inputMode = null,
            String? list = null, Integer? maxLength = null, Integer? minLength = null,
            Boolean? multiple = null, String? pattern = null,
            String? placeholder = null, Boolean? readOnly = null,
            Boolean? required = null, Integer? size = null,
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
        extends Input(name, type, accept, autoComplete, autoFocus,
            null, dirName, disabled, form, null, null, null, null,
            formNoValidate, inputMode, list, maxLength, minLength,
            null, null, multiple, pattern, placeholder,
            readOnly, required, size, null, valueOf,
            null, null, null, null, // ImageInput attributes
            id, classNames, style, accessKey, contextMenu, dir,
            draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data) {

    "Only text types are accepted: text, password, email, url, search"
    assert (type in {text, password, email, url, searchInput});

}

shared class HiddenInput(String name, String? valueOf = null,
            String? id = null, String? form = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty)
        extends Input(name, hiddenType, null, null, null,
            null, null, null, form, null, null, null, null,
            null, null, null, null, null, null, null, null,
            null, null, null, null, null, null, valueOf,
            null, null, null, null, id, empty, null, null,
            null, null, null, null, null, null, null, null,
            null, null, null, aria, nonstandardAttributes, data) {
}

shared class PasswordInput(String name, String? valueOf = null,
            String? accept = null, Boolean? autoComplete = null,
            Boolean? autoFocus = null, String? dirName = null,
            Boolean? disabled = null, String? form = null,
            Boolean? formNoValidate = null, InputMode? inputMode = null,
            String? list = null, Integer? maxLength = null, Integer? minLength = null,
            Boolean? multiple = null, String? pattern = null,
            String? placeholder = null, Boolean? readOnly = null,
            Boolean? required = null, Integer? size = null,
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
        extends Input(name, password, accept, autoComplete, autoFocus,
            null, dirName, disabled, form, null, null, null, null,
            formNoValidate, inputMode, list, maxLength, minLength,
            null, null, multiple, pattern, placeholder,
            readOnly, required, size, null, valueOf,
            null, null, null, null,
            id, classNames, style, accessKey, contextMenu, dir,
            draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data) {
    
}
