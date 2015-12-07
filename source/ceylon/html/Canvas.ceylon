import ceylon.html {
	DataContainer,
	CssClass,
	TextDirection,
	ParentNode,
	BaseElement,
	Aria,
	BlockOrInline,
	DropZone,
	TextNode,
	Tag,
	BlockElement,
	Snippet,
	AttributeSequenceBuilder
}

"""The canvas element provides scripts with a resolution-dependent 
   bitmap canvas, which can be used for rendering graphs, game graphics, 
   art, or other visual images on the fly.
   
   ```
   Canvas {
   	   width = 800;
   	   height = 600;
       id = "myCanvas";
   }
   
   ```
 
   Technical details about this element can be found on the
   [Official W3C reference](http://www.w3.org/html/wg/drafts/html/master/semantics.html#the-canvas-element)
   """
shared class Canvas(
	shared Integer witdh, shared Integer height, 
	String? id = null, CssClass classNames = [],
	String? style = null, String? accessKey = null,
	String? contextMenu = null, TextDirection? dir = null,
	Boolean? draggable = null, DropZone? dropZone = null,
	Boolean? inert = null, Boolean? hidden = null,
	String? lang = null, Boolean? spellcheck = null,
	Integer? tabIndex = null,
	Boolean? translate = null, Aria? aria = null,
	DataContainer data = empty
)		
		extends BaseElement(
	id, classNames, style, accessKey, contextMenu,
	dir, draggable, dropZone, inert, hidden, lang, spellcheck,
	tabIndex, null, translate, aria, ["width" -> witdh, "height" -> height], data
)
		satisfies TextNode & BlockElement & ParentNode<BlockOrInline> 
		{
	
	shared actual String text => "";
	
	shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children => empty;
	
	tag = Tag("canvas");
	
	shared actual [<String->Object>*] attributes {
		value attrs = AttributeSequenceBuilder();
		attrs.addAttribute("width", witdh);
		attrs.addAttribute("heigth", height);
		attrs.addAll(super.attributes);
		return attrs.sequence();
	}
}