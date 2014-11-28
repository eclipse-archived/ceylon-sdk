import ceylon.promise {
  ExecutionContext
}
import java.util.concurrent { Executors }
import java.lang { Runnable }

shared object runtimeContext satisfies ExecutionContext {
  
  value executor = Executors.newCachedThreadPool();
  
  shared actual void run(void task()) {
    object runnable satisfies Runnable {
      shared actual void run() {
        task();
      }
    }
    executor.submit(runnable);
  }
  
  shared actual ExecutionContext childContext() => this;
  
}