import ceylon.promise.internal {
  runtimeContext,
  AtomicRef
}

AtomicRef<Context> currentContext = AtomicRef<Context>(runtimeContext);

"""The global context for running promise compositions when no context is explicitly specified"""
shared Context globalContext => currentContext.get();

"""Define the global context for running deferred compositions"""
shared void defineGlobalContext(Context context) {
  currentContext.set(context);
}