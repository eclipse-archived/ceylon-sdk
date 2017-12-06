/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.interop.browser {
    IXMLHttpRequest=XMLHttpRequest
}
import ceylon.interop.browser.dom {
    IEvent=Event,
    EventInit,
    Text,
    Range,
    Comment
}

shared IEvent newEventInternal(String type, EventInit? eventInitDict) {
    dynamic {
        obj = eval("Event");
        return \Iobj(type, eventInitDict);
    }
}

shared IXMLHttpRequest newXMLHttpRequestInternal() {
    dynamic {
        // otherwise it seems our interface is used instead :(
        obj = eval("XMLHttpRequest");
        return \Iobj();
    }
}

shared Text newTextInternal(String text) {
    dynamic {
        obj = eval("Text");
        return \Iobj(text);
    }
}

shared Range newRangeInternal() {
    dynamic {
        obj = eval("Range");
        return \Iobj();
    }
}

shared Comment newCommentInternal(String data) {
    dynamic {
        obj = eval("Comment");
        return \Iobj(data);
    }
}