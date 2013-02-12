import ceylon.net.httpd { WebEndpoint, WebEndpointAsync, HttpdException, WebEndpointConfig}

import java.lang { ClassNotFoundException }

by "Matej Lazar"
shared class WebModuleLoader() {
    
    value jh = JavaHelper(); 
    
    shared WebEndpoint|WebEndpointAsync instance(WebEndpointConfig webEndpointConfig) {
        
        String moduleId = webEndpointConfig.moduleId;
        String className = webEndpointConfig.className;
        
        value sb = StringBuilder();
        sb.append(className);
        sb.append(moduleId);
        
        try {
            //TODO log
            print("Creating new web endpoint instance ``className`` ...");
            Object instanceObj = jh.createInstance(this, className, moduleId);
            if (is WebEndpoint|WebEndpointAsync instanceObj) {
                instanceObj.init(webEndpointConfig);
                return instanceObj;
            } else {
                throw HttpdException("Web endpoint does not satisfy WebEndpoint|WebEndpointAsync.");
            }
        } catch(ClassNotFoundException e) {
            throw HttpdException("Web endpoint class ``className`` not found.");
        }
    }
}