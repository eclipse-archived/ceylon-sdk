package ceylon.net.httpd.internal;

import org.jboss.modules.Module;
import org.jboss.modules.ModuleClassLoader;
import org.jboss.modules.ModuleIdentifier;
import org.jboss.modules.ModuleLoadException;
import org.jboss.modules.ModuleLoader;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.InetSocketAddress;
import java.net.URL;

import org.xnio.ChannelListener;
import org.xnio.OptionMap;
import org.xnio.XnioWorker;
import org.xnio.channels.AcceptingChannel;
import org.xnio.channels.ConnectedChannel;
import org.xnio.channels.ConnectedStreamChannel;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;

//@Ceylon
public class JavaHelper {

    /**
     * Helper method to create instances of given class in a module.
     * Method trys to use modular class loader, if it is not available (running from IDE) a flat one is used.
     */
    public static Object createInstance(Object obj, String className, String moduleId) throws ModuleLoadException, ClassNotFoundException, InstantiationException, IllegalAccessException {
        ClassLoader cl = obj.getClass().getClassLoader();
        if (cl instanceof ModuleClassLoader) {
            ModuleClassLoader mcl = (ModuleClassLoader)cl;
            ModuleLoader ml =  mcl.getModule().getModuleLoader();
            ModuleIdentifier identifier = ModuleIdentifier.fromString(moduleId);
            Module module = ml.loadModule(identifier);
            cl = module.getClassLoader();
        }
        Class<?> clazz = cl.loadClass(className);
        return clazz.newInstance();
    }
    
    /**
     * Remove wildcard type from retun type.
     * Workaround for: type argument to invariant type parameter in assignability condition not yet supported (until we implement reified generics)
     */
    @SuppressWarnings("unchecked")
    public static AcceptingChannel<ConnectedChannel> createStreamServer(
            XnioWorker worker,
            InetSocketAddress bindAddress,
            ChannelListener<AcceptingChannel<ConnectedStreamChannel>> acceptListener,
            OptionMap optionMap) throws IOException {

        @SuppressWarnings("rawtypes")
        AcceptingChannel acceptingChannel = worker.createStreamServer(bindAddress, acceptListener, optionMap);
        return acceptingChannel;
    }

    
    public static ClassLoader getClassLoader(Object object) {
    	return object.getClass().getClassLoader();
    }
    
    public static InputStream openResourceStream(Object obj, String resourceName) throws IOException {
    	ClassLoader cl = getClassLoader(obj);
    	//TODO use get resources and define overriding
    	URL url = cl.getResource(resourceName);
    	return url.openStream();
    }
    
    /**
     * workaround for: ambiguous reference to overloaded method or class: InputStreamReader 
     */
    public static InputStreamReader newInputStreamReader(InputStream in) {
    	return new InputStreamReader(in);
    }
}
