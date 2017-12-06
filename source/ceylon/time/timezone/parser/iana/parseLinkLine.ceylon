/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.timezone.model {
    RealName,
    AliasName,
    Link
}

shared Link parseLinkLine(String line) {
    value token = line.split(tokenDelimiter).iterator();
    
    assert(is String link = token.next(), link == "Link");
    
    assert (is RealName realId = token.next());
    assert (is AliasName aliasId = token.next());
    return [realId, aliasId];
}
