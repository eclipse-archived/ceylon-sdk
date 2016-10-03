import ceylon.promise {
    ExecutionContext
}

import java.lang {
    Runnable,
    Thread,
    Runtime,
    JInteger=Integer
}
import java.util.concurrent {
    TimeUnit,
    SynchronousQueue,
    ThreadPoolExecutor,
    ThreadFactory
}

native
shared object runtimeContext satisfies ExecutionContext {
    native shared actual void run(void task());
    native shared actual ExecutionContext childContext();
}

native("jvm")
shared object runtimeContext satisfies ExecutionContext {
  
  // Equivalent to Executors.newCachedThreadPool
  value executor
          = ThreadPoolExecutor(0, JInteger.maxValue,
                60, TimeUnit.seconds,
                SynchronousQueue<Runnable>());
  value wrappedThreadFactory = executor.threadFactory;
  executor.threadFactory = object satisfies ThreadFactory {
    shared actual Thread newThread(Runnable runnable) {
      value thread = wrappedThreadFactory.newThread(runnable);
      thread.daemon = true;
      return thread;
    }
  };
  
  Thread shutdownHook = Thread(object satisfies Runnable {
    shared actual void run() {
      executor.shutdown();
      executor.awaitTermination(90, TimeUnit.seconds);
    }
  });
  shutdownHook.name = "ceylon-execution-context-shutdown-hook";
  
  Runtime.runtime.addShutdownHook(shutdownHook);
  
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
