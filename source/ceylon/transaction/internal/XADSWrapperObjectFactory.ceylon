import ceylon.interop.java {
    javaClass
}

import java.util {
    Hashtable
}

import javax.naming {
    ...
}
import javax.naming.spi {
    ObjectFactory
}


Reference getReference(String className, String binding,
    String driver, String databaseName,
    String? host, Integer? port,
    String userName, String password) {
    
    Reference ref = Reference(className, 
        javaClass<XADSWrapperObjectFactory>().name, null);
    
    ref.add(StringRefAddr("binding", binding));
    ref.add(StringRefAddr("driver", driver));
    ref.add(StringRefAddr("databaseName", databaseName));
    ref.add(StringRefAddr("host", host));
    ref.add(StringRefAddr("port", port?.string));
    
    ref.add(StringRefAddr("username", userName));
    ref.add(StringRefAddr("password", password));
    
    return ref;
}


String? getStringProperty(Reference ref, String propName) 
        => ref.get(propName)?.content?.string;

Integer? getIntegerProperty(Reference ref, String propName, Integer defValue) {
    if (exists addr = ref.get(propName), 
        exists content = addr.content) {
        return parseInteger(content.string);
    }
    else {
        return defValue;
    }
}

/**
 * @author <a href="mailto:mmusgrov@redhat.com">Mike Musgrove</a>
 */
shared sealed class XADSWrapperObjectFactory() satisfies ObjectFactory {
    shared actual Object getObjectInstance(Object ref, Name name, 
            Context nameCtx, 
            Hashtable<out Object,out Object> environment) {
        assert (is Reference ref);
        assert (exists binding = getStringProperty(ref, "binding"));
        assert (exists driver = getStringProperty(ref, "driver"));
        assert (exists database = getStringProperty(ref, "databaseName"));
        value host = getStringProperty(ref, "host");
        value port = getIntegerProperty(ref, "port", 0);
        assert (exists user = getStringProperty(ref, "username"));
        assert (exists pass = getStringProperty(ref, "password"));
        return createXADataSource {
            binding = binding;
            driver = driver;
            databaseNameOrUrl = database;
            host = host;
            port = port;
            userAndPassword = [user, pass];
        };
    }
}
