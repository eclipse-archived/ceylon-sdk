import ceylon.interop.java { javaString }
import java.lang { System { getSystemProperty=getProperty } }

shared void run() {
    value val = javaString(getSystemProperty("user.home"));
    print(val);
}