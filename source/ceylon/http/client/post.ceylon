/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer.charset {
	utf8
}
import ceylon.http.client {
	Request
}
import ceylon.http.common {
	p=post
}
import ceylon.uri {
	Uri,
	Parameter
}

"Returns an HTTP POST request for the given Uri"
shared Request post(Uri uri, {Parameter*} parameters = empty) => Request(uri, p, null, "application/octet-stream", utf8, parameters);
