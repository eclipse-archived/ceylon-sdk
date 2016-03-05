"Elements belonging to the _metadata category_ modify the presentation or 
 the behavior of the rest of the document, set up links to other documents, or 
 convey other out of band information."
shared interface MetadataCategory {}

"Elements belonging to the _flow category_ typically contain text or 
 embedded content."
shared interface FlowCategory {}

"Elements belonging to the _phrasing category_ defines the text and 
 the mark-up it contains. Runs of phrasing content make up paragraphs."
shared interface PhrasingCategory {}

"Elements belonging to the _heading category_ defines the title 
 of a section, whether marked by an explicit sectioning content 
 element or implicitly defined by the heading content itself."
shared interface HeadingCategory {}

"Elements belonging to the _embadded category_ imports another resource or 
 inserts content from another mark-up language or namespace into the document."
shared interface EmbeddedCategory {}

"Elements belonging to the _interactive category_ are specifically 
 designed for user interaction."
shared interface InteractiveCategory {}