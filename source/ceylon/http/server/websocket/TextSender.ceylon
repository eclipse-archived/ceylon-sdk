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
shared interface FragmentedTextSender {

    shared formal void sendText(
        String payload, 
        Boolean finalFrame = false);

    shared formal void sendTextAsynchronous(
        String text,
        Anything(WebSocketChannel) onCompletion,
        Anything(WebSocketChannel,Exception)? onError = null,
        Boolean finalFrame = false);

}
