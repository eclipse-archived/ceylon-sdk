/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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
    shared formal variable EventHandler? onabort;
    shared formal variable EventHandler? onblur;
    shared formal variable EventHandler? oncancel;
    shared formal variable EventHandler? oncanplay;
    shared formal variable EventHandler? oncanplaythrough;
    shared formal variable EventHandler? onchange;
    shared formal variable EventHandler? onclick;
    shared formal variable EventHandler? oncuechange;
    shared formal variable EventHandler? ondblclick;
    shared formal variable EventHandler? ondurationchange;
    shared formal variable EventHandler? onemptied;
    shared formal variable EventHandler? onended;
    shared formal variable OnErrorEventHandler? onerror;
    shared formal variable EventHandler? onfocus;
    shared formal variable EventHandler? oninput;
    shared formal variable EventHandler? oninvalid;
    shared formal variable EventHandler? onkeydown;
    shared formal variable EventHandler? onkeypress;
    shared formal variable EventHandler? onkeyup;
    shared formal variable EventHandler? onload;
    shared formal variable EventHandler? onloadeddata;
    shared formal variable EventHandler? onloadedmetadata;
    shared formal variable EventHandler? onloadstart;
    shared formal variable EventHandler? onmousedown;
    shared formal variable EventHandler? onmouseenter;
    shared formal variable EventHandler? onmouseleave;
    shared formal variable EventHandler? onmousemove;
    shared formal variable EventHandler? onmouseout;
    shared formal variable EventHandler? onmouseover;
    shared formal variable EventHandler? onmouseup;
    shared formal variable EventHandler? onmousewheel;
    shared formal variable EventHandler? onpause;
    shared formal variable EventHandler? onplay;
    shared formal variable EventHandler? onplaying;
    shared formal variable EventHandler? onprogress;
    shared formal variable EventHandler? onratechange;
    shared formal variable EventHandler? onreset;
    shared formal variable EventHandler? onresize;
    shared formal variable EventHandler? onscroll;
    shared formal variable EventHandler? onseeked;
    shared formal variable EventHandler? onseeking;
    shared formal variable EventHandler? onselect;
    shared formal variable EventHandler? onshow;
    shared formal variable EventHandler? onstalled;
    shared formal variable EventHandler? onsubmit;
    shared formal variable EventHandler? onsuspend;
    shared formal variable EventHandler? ontimeupdate;
    shared formal variable EventHandler? ontoggle;
    shared formal variable EventHandler? onvolumechange;
    shared formal variable EventHandler? onwaiting;
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
