/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
shared class BufferException(description = null, cause = null)
        extends Exception(description, cause) {
    String? description;
    Throwable? cause;
}

shared class BufferUnderflowException(description = null, cause = null)
        extends BufferException(description, cause) {
    String? description;
    Throwable? cause;
}

shared class BufferOverflowException(description = null, cause = null)
        extends BufferException(description, cause) {
    String? description;
    Throwable? cause;
}
