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
  AtomicRef
}

AtomicRef<ExecutionListener[]> currentExecutionListeners = AtomicRef<ExecutionListener[]>([]);

"""Add a global execution listener that will be used when composing promises. The execution
   listener is invoked at composition time and returns a function that will wrap a later
   execution of the composed function.
   
   This function returns a function that when called removes the global execution listener.
   """
shared Anything() addGlobalExecutionListener(ExecutionListener onChild) {
  while (true) {
    ExecutionListener[] prev = currentExecutionListeners.get();
    ExecutionListener[] next = prev.withTrailing(onChild);
    if (currentExecutionListeners.compareAndSet(prev, next)) {
      break;
    }
  }
  void remove() {
    while (true) {
      ExecutionListener[] prev = currentExecutionListeners.get();
      ExecutionListener[] next = [ * prev.filter {
        function selecting(ExecutionListener element) => element != onChild;
      } ];
      if (prev.size != next.size) {
        break;
      } else {
        if (currentExecutionListeners.compareAndSet(prev, next)) {
          break;
        }
      }
    }
  }
  return remove;
}