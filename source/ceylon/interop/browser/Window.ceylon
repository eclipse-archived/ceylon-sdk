/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.interop.browser.dom {
    GlobalEventHandlers,
    WindowEventHandlers,
    EventHandler,
    EventTarget,
    Element,
    Document
}

"The window object represents a window containing a DOM document; the document
 property points to the DOM document loaded in that window.
 
 See http://www.w3.org/TR/html5/browsers.html#the-window-object"
shared dynamic Window satisfies EventTarget & WindowEventHandlers & GlobalEventHandlers {
    
    shared formal WindowProxy window;
    shared formal WindowProxy self;
    shared formal Document document;
    shared formal variable String name;
    shared formal Location location;
    shared formal History history;
    
    shared formal BarProp locationbar;
    shared formal BarProp menubar;
    shared formal BarProp personalbar;
    shared formal BarProp scrollbars;
    shared formal BarProp statusbar;
    shared formal BarProp toolbar;
    shared formal variable String status;
    shared formal void close();
    shared formal Boolean? closed;
    shared formal void stop();
    shared formal void focus();
    shared formal void blur();
    shared formal WindowProxy frames;
    shared formal Integer length;
    shared formal WindowProxy top;
    shared formal WindowProxy? opener;
    shared formal WindowProxy parent;
    shared formal Element? frameElement;
    shared formal WindowProxy open(String url = "about:blank",
        String target = "_blank", String features = "", Boolean replace = false);
    
    // TODO getter WindowProxy (unsigned long index);
    // TODO getter object (DOMString name);
    
    shared formal Navigator navigator;
    shared formal External? external;
    shared formal ApplicationCache applicationCache;
    shared formal void alert(String message = "");
    shared formal Boolean confirm(String message = "");
    shared formal String? prompt(String message = "", String default = "");
    shared formal void print();
    shared formal Integer setInterval(Anything() f, Integer millis, Anything* params);
    shared formal void clearInterval(Integer id);
    shared formal Integer setTimeout(Anything() f, Integer millis, Anything* params);
    shared formal void clearTimeout(Integer id);
}

shared alias WindowProxy => Window;

"The current window."
shared Window window {
    dynamic {
        return eval("window");
    }
}

"Provide a representation of the address of the active document of the
 [[Document]]'s browsing context, and allow the current entry of the browsing
 context's session history to be changed, by adding or replacing entries
 in the [[History]] object."
shared dynamic Location {
    "Navigates to the given page."
    shared formal void \iassign(String url);
    
    "Removes the current page from the session history and navigates to
     the given page."
    shared formal void replace(String url);
    
    "Reloads the current page."
    shared formal void reload();
}

shared dynamic History {
    "Returns the number of entries in the joint session history."
    shared formal Integer length;
    
    "Returns the current state object."
    shared formal dynamic state;
    
    "Goes back or forward the specified number of steps in the joint session history.
    
     A zero delta will reload the current page.
    
     If the delta is out of range, does nothing."
    shared formal void go(Integer delta);
    
    "Goes back one step in the joint session history.
    
     If there is no previous page, does nothing."
    shared formal void back();
    
    "Goes forward one step in the joint session history.
    
     If there is no next page, does nothing."
    shared formal void forward();
    
    "Pushes the given data onto the session history, with the given title,
     and, if provided and not null, the given URL."
    shared formal void pushState(dynamic data, String title, String? url = null);
    
    "Updates the current entry in the session history to have the given data,
     title, and, if provided and not null, URL."
    shared formal void replaceState(dynamic data, String title, String? url = null);
}

"Represents the visibility of a bar in the browser (toolbar, address bar,
 scrollbar etc)."
shared dynamic BarProp {
    shared formal variable Boolean visible;
}

"http://www.w3.org/TR/html5/webappapis.html#external"
shared dynamic External {
    "Adds the search engine described by the OpenSearch description document at url.
    
     The OpenSearch description document has to be on the same server as the
     script that calls this method."
    shared formal void \iAddSearchProvider(String engineURL);
    
    "Returns a value based on comparing url to the URLs of the results pages
     of the installed search engines:
     
     * `0`: None of the installed search engines match `engineURL`.
     * `1`: One or more installed search engines match `engineURL`, but none are
     the user's default search engine.
     * `2`: The user's default search engine matches `engineURL`.
     
     The `engineUrl` is compared to the URLs of the results pages of the installed
     search engines using a prefix match. Only results pages on the same domain
     as the script that calls this method are checked."
    shared formal Integer \iIsSearchProviderInstalled(String engineURL);
}

// TODO
shared dynamic Navigator {
}

// TODO doc
shared dynamic ApplicationCache satisfies EventTarget {
    // update status
    shared formal Integer \iUNCACHED;
    shared formal Integer \iIDLE;
    shared formal Integer \iCHECKING;
    shared formal Integer \iDOWNLOADING;
    shared formal Integer \iUPDATEREADY;
    shared formal Integer \iOBSOLETE;
    shared formal Integer status;
    
    // updates
    shared formal void update();
//    shared formal void abort();
    shared formal void swapCache();
    
    // events
    shared formal variable EventHandler? onchecking;
    shared formal variable EventHandler? onerror;
    shared formal variable EventHandler? onnoupdate;
    shared formal variable EventHandler? ondownloading;
    shared formal variable EventHandler? onprogress;
    shared formal variable EventHandler? onupdateready;
    shared formal variable EventHandler? oncached;
    shared formal variable EventHandler? onobsolete;
}
