/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
shared dynamic DOMTokenList {
    shared formal Integer length;
    shared formal String? item(Integer index);
    shared formal Boolean contains(String token);
    // TODO should be String*
    shared formal void add(String tokens);
    // TODO should be String*
    shared formal void remove(String tokens);
    shared formal Boolean toggle(String token, Boolean force);

    // TODO stringifier;
    // TODO iterable<DOMString>;
}