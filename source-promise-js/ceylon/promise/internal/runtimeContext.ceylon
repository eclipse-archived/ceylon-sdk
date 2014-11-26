import ceylon.promise {
  Context
}

shared object runtimeContext satisfies Context {
  shared actual void run(void task()) {
    dynamic {
      setTimeout(task, 1);
    }
  }
}
