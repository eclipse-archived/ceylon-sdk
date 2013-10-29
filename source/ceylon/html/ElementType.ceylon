
"""Enumerated type used to group elements with common behavior about
   how they are rendered and how they relate to each other. This
   interface is useful to empower proper and semantic HTML writing
   by API design, enforcing constraints at compile time:
   ```
   P {
       Span("Paragraph elements can have inline elements
             as children, like a span..."),
       Div("But not block elements, like a div!") // compilation error
   };
   ```
   """
shared interface ElementType
        of BlockElement | InlineElement | TableElement
        satisfies Node {
}

"Block level elements normally start (and end) with a
 new line when displayed in a browser."
see(`class Div`, `class P`)
shared interface BlockElement satisfies ElementType {}

"Inline elements are normally displayed without starting a new line.
 **Note**: if you want to properly customize inline elements' sizing
 properties you must style them with `display: inline-block;`"
see(`class Span`)
shared interface InlineElement satisfies ElementType {}

"An special type of element that's available only as [[Table]]
 child nodes."
see(`class Tr`, `class Td`)
shared interface TableElement satisfies ElementType {}

"An useful `alias` to indicate that an element can be either
 of `block` or `inline` type."
shared alias BlockOrInline => BlockElement|InlineElement;
