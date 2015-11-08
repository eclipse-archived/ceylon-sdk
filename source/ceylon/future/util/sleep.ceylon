import java.lang {
    Thread,
    JavaInterruptedException=InterruptedException
}

"Suspend the current thread for some amount of [[time]]."
throws (`class InterruptedException`,
    "If the thread is interrupted before the sleep completes")
void sleep(time) {
    "The number of milliseconds to sleep for."
    Integer time;
    assert (time >= 0);
    try {
        Thread.sleep(time);
    } catch (JavaInterruptedException e) {
        throw InterruptedException("Interrupted during ``time`` ms sleep", e);
    }
}
