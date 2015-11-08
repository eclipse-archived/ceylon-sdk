import ceylon.promise {
    ExecutionContext,
    globalExecutionContext,
    Deferred
}

"Schedules the [[job]] for concurrent execution in [[context]], and immediately
 returns a [[Future]] for tracking its fate."
Future<Value> submit<Value>(job, context = globalExecutionContext) {
    "Callable returning [[Value]] to create a [[Future]] for."
    Value() job;
    "The context to execute the jobs in."
    ExecutionContext context;
    
    value deferred = Deferred<Value>(context);
    
    context.run(
        void() {
            variable Value val;
            try {
                val = job();
            } catch (Throwable e) {
                deferred.reject(e);
                return;
            }
            deferred.fulfill(val);
        }
    );
    
    return Future(deferred.promise);
}

"Eagerly [[submit]]s all of the [[jobs]], and returns an [[Iterator]] to
 lazily obtain the results."
{Value*} map<Value>(jobs, timeout = 0, context = globalExecutionContext) {
    "Jobs to get the [[Future.result]]s of."
    {Value()*} jobs;
    "The maximum milliseconds to allow for the retrieval of each job before
     throwing a [[FutureTimeoutException]]. Must be at least 1 to have effect."
    Integer timeout;
    "The context to execute the jobs in."
    ExecutionContext context;
    
    // Eager submit
    Future<Value>[] futures = jobs.map((job) => submit(job, context)).sequence();
    
    // Lazy result
    return futures.map((future) => future.result(timeout));
}
