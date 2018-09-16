/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
shared final class Stability of unlinked|linked {
    shared actual String string;
    shared new unlinked { string=>"unlinked"; }
    shared new linked { string=>"linked"; }
}

deprecated("use [[Stability.unlinked]]")
shared Stability unlinked => Stability.unlinked;

deprecated("use [[Stability.linked]]")
shared Stability linked => Stability.linked;
