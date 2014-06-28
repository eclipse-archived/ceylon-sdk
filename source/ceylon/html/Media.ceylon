
"Base class for media elements, such as [[Audio]] and [[Video]]."
shared abstract class Media(src,
            autoPlay = null, controls = null, loop = null,
            muted = null, preload = null,
            String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            children = {})
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies BlockElement & ParentNode<Source> {

    "Specifies that the media will start playing
     as soon as it is ready."
    see(`value preload`)
    shared Boolean? autoPlay;

    "Specifies that media controls should be displayed
     (such as a play/pause button etc)."
    shared Boolean? controls;

    "Specifies that the media will start over again,
     every time it is finished."
    shared Boolean? loop;

    "Specifies that the audio output should be muted."
    shared Boolean? muted;

    "Specifies if and how the author thinks the media
     should be loaded when the page loads."
    shared MediaPreload? preload;

    "Specifies the URL of the media file.
     For multiple source/formats use [[Source]]
     as children elements."
    see(`value children`, `class Source`)
    shared String? src;

    shared actual {<Source|{Source*}|Snippet<Source>|Null>*} children;

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("src", src);
        attrs.addNamedBooleanAttribute("autoplay", autoPlay);
        attrs.addNamedBooleanAttribute("controls", controls);
        attrs.addNamedBooleanAttribute("loop", loop);
        attrs.addNamedBooleanAttribute("muted", muted);
        attrs.addAttribute("preload", preload);
        attrs.addAll(super.attributes);
        return attrs.sequence();
    }

}

"Used to specify if and how the author thinks the media
 should be loaded when the page loads.
 
 Technical details about this attribute can be found on the
 [Official W3C reference](http://www.w3.org/html/wg/drafts/html/master/embedded-content-0.html#attr-media-preload)"
shared abstract class MediaPreload(String name)
        of auto | metadata | none {
    string => name;
}

"Hints to the user agent that the user agent can put the user's
 needs first without risk to the server, up to and including
 optimistically downloading the entire resource."
shared object auto extends MediaPreload("auto") {}

"Hints to the user agent that the author does not expect the user
 to need the media resource, but that fetching the resource
 metadata (dimensions, track list, duration, etc), and maybe even
 the first few frames, is reasonable."
shared object metadata extends MediaPreload("metadata") {}

"Hints to the user agent that either the author does not expect
 the user to need the media resource, or that the server wants
 to minimize unnecessary traffic."
shared object none extends MediaPreload("none") {}


"Allows authors to specify multiple alternative media resources
 for media elements. It does not represent anything on its own."
shared class Source(src, media, type, String? id) extends Element(id) {

    "Specifies the URL of the media file."
    shared String? src;

    "Specifies the type of media resource."
    shared String? media;

    "Specifies the MIME type of the media resource."
    shared String? type;

    tag = Tag("source", emptyTag);

}

"Represents a sound or audio stream.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#audio)"
shared class Audio(String src,
            Boolean? autoPlay = null, Boolean? controls = null,
            Boolean? loop = null, Boolean? muted = null,
            MediaPreload? preload = null,
            String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            {<Source|{Source*}|Snippet<Source>|Null>*} children = empty)
        extends Media(src, autoPlay, controls, loop, muted, preload,
            id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes,
            data, children) {

    tag = Tag("audio");

}

"Represents a video or movie.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#video)"
shared class Video(String src,
            Boolean? autoPlay = null, Boolean? controls = null,
            Boolean? loop = null, Boolean? muted = null,
            MediaPreload? preload = null,
            poster = null, height = null, width = null,
            String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            {<Source|{Source*}|Snippet<Source>|Null>*} children = empty)
        extends Media(src, autoPlay, controls, loop, muted, preload,
            id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes,
            data, children) {

    "Specifies an image to be shown while the video is downloading,
     or until the user hits the play button."
    shared String? poster;

    "Sets the height of the video player."
    shared Integer? height;

    "Sets the width of the video player."
    shared Integer? width;

    tag = Tag("video");

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAll(super.attributes);
        attrs.addAttribute("poster", poster);
        attrs.addAttribute("height", height);
        attrs.addAttribute("width", width);
        return attrs.sequence();
    }

}
