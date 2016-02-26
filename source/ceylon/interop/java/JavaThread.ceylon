import java.lang {
    Thread
}

"A Java [[java.lang::Thread]] that executes the given
 [[function|run]]."
shared class JavaThread(run) extends Thread() {
    "The function to execute."
    shared actual void run();
}