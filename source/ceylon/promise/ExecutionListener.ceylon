/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
shared interface ExecutionListener {

  "This method is invoked when a child is created so it can capture the context of the creation of the promise's child.
   The returned function can then apply this context on its children."
  shared formal Anything(Anything()) onChild();
}