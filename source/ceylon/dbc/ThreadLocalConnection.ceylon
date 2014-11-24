import java.lang {
    ThreadLocal
}
import java.sql {
    Connection
}

class ThreadLocalConnection(Connection newConnection()) 
        extends ThreadLocal<ConnectionStatus>() {
    shared actual ConnectionStatus initialValue()
            => ConnectionStatus(newConnection);
}
