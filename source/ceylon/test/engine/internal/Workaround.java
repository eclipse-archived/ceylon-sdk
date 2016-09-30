package ceylon.test.engine.internal;

import org.jboss.modules.Module;
import org.jboss.modules.ModuleLoadException;
import ceylon.modules.jboss.runtime.CeylonModuleLoader;

class Workaround {

    static void loadModule(String modName, String modVersion) {
        try {
            CeylonModuleLoader cml = (CeylonModuleLoader) Module.getCallerModuleLoader();
            if( cml != null ) {
                cml.loadModuleSynchronous(modName, modVersion);
            }
        } catch (ModuleLoadException e) {
            throw new RuntimeException(e);
        }
    }

}