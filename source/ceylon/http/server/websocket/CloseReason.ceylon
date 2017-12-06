/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
by("Matej Lazar")
shared class CloseReason(code, reason = null) {

    shared Integer code;

    shared String? reason;

    if (!isValid(code)) {
        throw Exception("Invalid close status code ``code``");
    }
}

/*
* For the exact meaning of the codes refer to the <a href="http://tools.ietf.org/html/rfc6455#section-7.4">WebSocket
* RFC Section 7.4</a>.
*/
shared class NoReason(String? reason = null) extends CloseReason(0) {}
shared class NormalClosure(String? reason = null) extends CloseReason(1000, reason) {}
shared class GoingAway(String? reason = null) extends CloseReason(1001, reason) {}
shared class ProtocolError(String? reason = null) extends CloseReason(1003, reason) {}
shared class MessageContainsInvalidData(String? reason = null) extends CloseReason(1007, reason) {}
shared class MessageViolatesPolicy(String? reason = null) extends CloseReason(1008, reason) {}
shared class MessageToBig(String? reason = null) extends CloseReason(1009, reason) {}
shared class MissingExtension(String? reason = null) extends CloseReason(1010, reason) {}
shared class UnexpectedError(String? reason = null) extends CloseReason(1011, reason) {}

Boolean isValid(Integer code) {
    if (0 < code <= 999 
            || 1004 <= code <= 1006
            || 1012 <= code <= 2999) {
        return false;
    }
    return true;
}
