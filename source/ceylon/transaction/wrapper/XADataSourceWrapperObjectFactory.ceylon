import java.util {
    Hashtable
}

import javax.naming {
    ...
}
import javax.naming.spi {
    ObjectFactory
}


by ("Mike Musgrove")
//Note: must be shared because JNDI requires it!
shared sealed class XADataSourceWrapperObjectFactory() satisfies ObjectFactory {
    shared actual XADataSourceWrapper getObjectInstance(Object ref, Name name, 
            Context nameCtx, 
            Hashtable<out Object,out Object> environment) {

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

