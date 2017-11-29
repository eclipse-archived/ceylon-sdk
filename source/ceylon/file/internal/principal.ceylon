/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.file {
    NoSuchPrincipalException
}

import java.nio.file {
    JPath=Path
}
import java.nio.file.attribute {
    UserPrincipalNotFoundException,
    UserPrincipal
}

UserPrincipal jprincipal(JPath jpath, String name) {
    value upls = jpath.fileSystem.userPrincipalLookupService;
    try {
        return upls.lookupPrincipalByName(name);
    }
    catch (UserPrincipalNotFoundException e) {
        throw NoSuchPrincipalException(name, e);
    }
}


