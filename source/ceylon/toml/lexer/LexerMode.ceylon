/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Use `key` to match bareKeys or `val` for tokens for integers, floats, dates, and
 booleans. Either will work for all other tokens."
shared final class LexerMode of key | val {
    shared new key {}
    shared new val {}
}
