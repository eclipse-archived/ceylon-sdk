/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Canonical name of the timezone link expression"
shared alias RealName => String;

"Alternative name (i.e. _alias_) of the time zone"
shared alias AliasName => String;

"Tuple representing the Timezone aliasing rules."
shared alias Link => [RealName, AliasName];
