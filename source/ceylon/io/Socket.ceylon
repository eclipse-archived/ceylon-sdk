/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a network socket."
by("Stéphane Épardaud")
shared sealed interface Socket 
        satisfies SelectableFileDescriptor {}

"Represents an SSL network socket."
shared sealed interface SslSocket 
        satisfies Socket {}