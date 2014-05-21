import ceylon.collection { 
    HashMap,
    ArrayList
}
import ceylon.net.http.server { UploadedFile }

shared class FormDataBuilder() {
    
    value parameters = HashMap<String, ArrayList<String>>();
    value files = HashMap<String, ArrayList<UploadedFile>>();
    
    shared void addParameter(String name, String val) {
        getPostedParameterValues(name).add(val);
    }
    
    shared void addFile(String name, UploadedFile val) {
        getPostedFileValues(name).add(val);
    }
    
    ArrayList<String> getPostedParameterValues(String name) {
        variable ArrayList<String>? builder = parameters.get(name);
        if (exists b = builder) {
            return b;
        } else {
            value b = ArrayList<String>();
            parameters.put(name, b);
            return b;
        }
    }
    
    ArrayList<UploadedFile> getPostedFileValues(String name) {
        variable ArrayList<UploadedFile>? builder = files.get(name);
        if (exists b = builder) {
            return b;
        } else {
            value b = ArrayList<UploadedFile>();
            files.put(name, b);
            return b;
        }
    }
    
    shared FormData build() {
        value parametersSequence = HashMap<String, String[]>();
        value filesSequence = HashMap<String, UploadedFile[]>();
        
        for (key->parameterValues in parameters) {
            parametersSequence.put(key, parameterValues.sequence);
        }
        
        for (key->fileValues in files) {
            filesSequence.put(key, fileValues.sequence);
        }
        
        
        return FormData { 
            parameters => parametersSequence; 
            files => filesSequence; 
        };
    }
}

shared class FormData(parameters, files) {
    shared Map<String, String[]> parameters;
    shared Map<String, UploadedFile[]> files;
}