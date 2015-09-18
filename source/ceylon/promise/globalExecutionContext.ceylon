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
