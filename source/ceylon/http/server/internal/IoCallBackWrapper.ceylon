/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.http.server {
    HttpException=ServerException
}

import io.undertow.io {
    IoCallback,
    Sender
}
import io.undertow.server {
    HttpServerExchange
}

import java.io {
    IOException
}

by("Matej Lazar")
class IoCallbackWrapper(
            Anything() onCompletion,
            Anything(HttpException)? onError)
        satisfies IoCallback {

    shared actual void onComplete(HttpServerExchange? httpServerExchange, 
        Sender? sender) 
            => onCompletion();

    shared actual void onException(HttpServerExchange? httpServerExchange, 
        Sender? sender, IOException? iOException) {
        if (exists onError) {
            if (exists iOException) {
                onError(HttpException("Http error.", iOException));
            } else {
                onError(HttpException("Http error, no details available."));
            }
        }
    }
}
