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
    newRangeInternal
}
// TODO doc


shared dynamic Range {
    shared formal Node startContainer;
    shared formal Integer startOffset;
    shared formal Node endContainer;
    shared formal Integer endOffset;
    shared formal Boolean collapsed;
    shared formal Node commonAncestorContainer;
    
    shared formal void setStart(Node node, Integer offset);
    shared formal void setEnd(Node node, Integer offset);
    shared formal void setStartBefore(Node node);
    shared formal void setStartAfter(Node node);
    shared formal void setEndBefore(Node node);
    shared formal void setEndAfter(Node node);
    shared formal void collapse(Boolean toStart = false);
    shared formal void selectNode(Node node);
    shared formal void selectNodeContents(Node node);
    
    shared formal Integer \iSTART_TO_START;
    shared formal Integer \iSTART_TO_END;
    shared formal Integer \iEND_TO_END;
    shared formal Integer \iEND_TO_START;
    shared formal Integer compareBoundaryPoints(Integer how, Range sourceRange);
    
    shared formal void deleteContents();
    shared formal DocumentFragment extractContents();
    shared formal DocumentFragment cloneContents();
    shared formal void insertNode(Node node);
    shared formal void surroundContents(Node newParent);
    
    shared formal Range cloneRange();
    shared formal void detach();
    
    shared formal Boolean isPointInRange(Node node, Integer offset);
    shared formal Integer comparePoint(Node node, Integer offset);
    
    shared formal Boolean intersectsNode(Node node);
    
    // extensions from https://w3c.github.io/DOM-Parsing/#extensions-to-the-range-interface
    shared formal DocumentFragment createContextualFragment (String fragment);
}

shared Range newRange() => newRangeInternal();