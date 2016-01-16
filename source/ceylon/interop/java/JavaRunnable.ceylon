import java.lang {
    Runnable
}

"A Java [[java.lang::Runnable]] that executes the given
 [[function|run]]."
shared class JavaRunnable(run) satisfies Runnable {
    "The function to execute."
    shared actual void run();
}