import ceylon.interop.browser.internal {
    newEventInternal
}

"An object to which an event is dispatched when something has occurred.
 Each EventTarget has an associated list of event listeners."
shared dynamic EventTarget {
    
    "Appends an event listener for events whose type attribute value is [[type]].
     The [[callback]] argument sets the callback that will be invoked when the
     event is dispatched. When set to `true`, the [[capture]] argument prevents
     callback from being invoked when the event’s `eventPhase` attribute value
     is `BUBBLING_PHASE`. When false, callback will not be invoked when
     event’s `eventPhase` attribute value is `CAPTURING_PHASE`. Either way,
     callback will be invoked if event’s `eventPhase` attribute value
     is `AT_TARGET`."
    shared formal void addEventListener(String type, EventListener? callback,
        Boolean capture = false);
    
    "Remove the event listener in target’s list of event listeners with the
     same [[type]], [[callback]], and [[capture]]."
    shared formal void removeEventListener(String type, EventListener? callback,
        Boolean capture = false);
    
    "Dispatches a synthetic event [[event]] to target and returns `true` if
     either event’s cancelable attribute value is `false` or its
     `preventDefault()` method was not invoked, and `false` otherwise."
    shared formal Boolean dispatchEvent(Event event);
}

"An event listener can be used to observe a specific event."
shared dynamic EventListener {
    shared formal void handleEvent(Event event);
}

shared alias EventHandler => Anything(Event);

"An event allows for signaling that something has occurred, e.g. that an image
 has completed downloading.
 
 See [https://dom.spec.whatwg.org/#event](https://dom.spec.whatwg.org/#event)"
shared dynamic Event {
    "Returns the type of event, e.g. `\"click\"`, `\"hashchange\"`, or `\"submit\"`."
    shared formal String type;
    
    "Returns the object to which `event` is dispatched."
    shared formal EventTarget? target;
    shared formal EventTarget? currentTarget;
    
    shared formal Integer \iNONE;
    shared formal Integer \iCAPTURING_PHASE;
    shared formal Integer \iAT_TARGET;
    shared formal Integer \iBUBBLING_PHASE;
    shared formal Integer eventPhase;
    
    shared formal void stopPropagation();
    shared formal void stopImmediatePropagation();
    
    shared formal Boolean bubbles;
    shared formal Boolean cancelable;
    shared formal void preventDefault();
    shared formal Boolean defaultPrevented;
    
    shared formal Boolean isTrusted;
    shared formal DOMTimeStamp timeStamp;
    
    shared formal void initEvent(String type, Boolean bubbles, Boolean cancelable);
}

"Creates a new instance of [[Event]]."
shared Event newEvent(String type, EventInit? eventInitDict = null)
        => newEventInternal(type, eventInitDict);

"A dictionary containing attributes related to all events."
shared class EventInit(bubbles = false, cancelable = false) {
    shared Boolean bubbles;
    shared Boolean cancelable;
}

shared alias DOMTimeStamp => Integer;

shared dynamic GlobalEventHandlers {
    shared formal EventHandler? onabort;
    shared formal EventHandler? onblur;
    shared formal EventHandler? oncancel;
    shared formal EventHandler? oncanplay;
    shared formal EventHandler? oncanplaythrough;
    shared formal EventHandler? onchange;
    shared formal EventHandler? onclick;
    shared formal EventHandler? oncuechange;
    shared formal EventHandler? ondblclick;
    shared formal EventHandler? ondurationchange;
    shared formal EventHandler? onemptied;
    shared formal EventHandler? onended;
    shared formal OnErrorEventHandler? onerror;
    shared formal EventHandler? onfocus;
    shared formal EventHandler? oninput;
    shared formal EventHandler? oninvalid;
    shared formal EventHandler? onkeydown;
    shared formal EventHandler? onkeypress;
    shared formal EventHandler? onkeyup;
    shared formal EventHandler? onload;
    shared formal EventHandler? onloadeddata;
    shared formal EventHandler? onloadedmetadata;
    shared formal EventHandler? onloadstart;
    shared formal EventHandler? onmousedown;
    shared formal EventHandler? onmouseenter;
    shared formal EventHandler? onmouseleave;
    shared formal EventHandler? onmousemove;
    shared formal EventHandler? onmouseout;
    shared formal EventHandler? onmouseover;
    shared formal EventHandler? onmouseup;
    shared formal EventHandler? onmousewheel;
    shared formal EventHandler? onpause;
    shared formal EventHandler? onplay;
    shared formal EventHandler? onplaying;
    shared formal EventHandler? onprogress;
    shared formal EventHandler? onratechange;
    shared formal EventHandler? onreset;
    shared formal EventHandler? onresize;
    shared formal EventHandler? onscroll;
    shared formal EventHandler? onseeked;
    shared formal EventHandler? onseeking;
    shared formal EventHandler? onselect;
    shared formal EventHandler? onshow;
    shared formal EventHandler? onstalled;
    shared formal EventHandler? onsubmit;
    shared formal EventHandler? onsuspend;
    shared formal EventHandler? ontimeupdate;
    shared formal EventHandler? ontoggle;
    shared formal EventHandler? onvolumechange;
    shared formal EventHandler? onwaiting;
}

shared alias OnErrorEventHandler => Anything(String|Event, String?, Integer?,
        Integer?, Anything?);

shared alias OnBeforeUnloadEventHandler => String?(Event);

shared dynamic WindowEventHandlers {
    shared formal EventHandler? onafterprint;
    shared formal EventHandler? onbeforeprint;
    shared formal OnBeforeUnloadEventHandler? onbeforeunload;
    shared formal EventHandler? onhashchange;
    shared formal EventHandler? onmessage;
    shared formal EventHandler? onoffline;
    shared formal EventHandler? ononline;
    shared formal EventHandler? onpagehide;
    shared formal EventHandler? onpageshow;
    shared formal EventHandler? onpopstate;
    shared formal EventHandler? onstorage;
    shared formal EventHandler? onunload;
}
