
"Useful alias to indicate that a sequence of [[Entry]] can be
 used to add any nonstandard attribute to the element."
shared alias NonstandardAttributes => [<String->Object>*];

"Useful alias to indicate that a sequence of [[Entry]] can be
 used to add `data-` prefixed attributes to the element."
shared alias DataContainer => [<String->Object>*];

"Alias to represent a collection of CSS classes."
shared alias CssClass => String|[String*]; // TODO ceylon-style integration


"The text directionality.
 For details, check [Official W3C Specification]
 (http://www.w3.org/html/wg/drafts/html/master/dom.html#the-dir-attribute)"
shared abstract class TextDirection()
        of leftToRight | rightToLeft | autoDirection {}

"Indicates that the contents of the element are
 explicitly directionally embedded left-to-right text."
shared object leftToRight extends TextDirection() {
    string => "ltr";
}

"Indicates that the contents of the element are
 explicitly directionally embedded right-to-left text."
shared object rightToLeft extends TextDirection() {
    string => "rtl";
}

"Indicates that the contents of the element are
 explicitly embedded text, but that the direction
 is to be determined programmatically using the
 contents of the element."
shared object autoDirection extends TextDirection() {
    string => "auto";
}

 
"Defines the behavior of a drop zone element."
shared abstract class DropZone() of copy | link | move {}

"Indicates that dropping an accepted item on the element
 will result in a copy of the dragged data."
shared object copy extends DropZone() {}

"Indicates that dropping an accepted item on the element
 will result in a link to the original data."
shared object link extends DropZone() {}

"Indicates that dropping an accepted item on the element
 will result in the dragged data being moved to the new location."
shared object move extends DropZone() {}
