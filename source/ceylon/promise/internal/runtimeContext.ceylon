import ceylon.promise {
  ExecutionContext
}
import java.util.concurrent { Executors }
import java.lang { Runnable }

native
shared object runtimeContext satisfies ExecutionContext {
    native shared actual void run(void task());
    native shared actual ExecutionContext childContext();
}

native("jvm")
shared object runtimeContext satisfies ExecutionContext {
  
  value executor = Executors.newCachedThreadPool();
  
  native("jvm") shared actual void run(void task()) {
    object runnable satisfies Runnable {
      shared actual void run() {
        task();
      }
    }
    executor.submit(runnable);
  }
  
  native("jvm") shared actual ExecutionContext childContext() => this;
  
}

native("js")
shared object runtimeContext satisfies ExecutionContext {
    native("js") shared actual void run(void task()) {
        dynamic {
            setTimeout(task, 1);
        }
    }
    native("js") shared actual ExecutionContext childContext() => this;
}
