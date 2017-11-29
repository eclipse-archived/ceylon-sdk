/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.promise.internal {
  runtimeContext,
  AtomicRef
}

AtomicRef<ExecutionContext> currentExecutionContext 
        = AtomicRef<ExecutionContext>(runtimeContext);

"""The global execution context for running promise 
   compositions when no execution context is explicitly used"""
shared ExecutionContext globalExecutionContext 
        => currentExecutionContext.get();

"""Define the global execution context for running deferred 
   compositions"""
shared void defineGlobalExecutionContext(ExecutionContext context) 
        => currentExecutionContext.set(context);
