/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"An Exception throw during parse errors"
shared class ParseException(String message,
    "The error line (1-based)" 
    shared Integer line, 
    "The error column (1-based)" 
    shared Integer column) 
        extends Exception("``message`` at ``line``:``column`` (line:column)"){
}