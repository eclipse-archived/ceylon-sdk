import java.lang {
    ThreadLocal
}
import java.sql {
    Connection
}

class ThreadLocalConnection(Connection newConnection()) 
        extends ThreadLocal<ConnectionStatus>() {
    shared ConnectionStatus initialValue()
            => ConnectionStatus(newConnection);
}