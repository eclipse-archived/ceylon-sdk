import ceylon.promise {
  ExecutionContext
}

shared object runtimeContext satisfies ExecutionContext {
  shared actual void run(void task()) {
    dynamic {
      setTimeout(task, 1);
    }
  }
  shared actual ExecutionContext childContext() => this;
}
