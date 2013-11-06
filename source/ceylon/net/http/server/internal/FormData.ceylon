import ceylon.collection { HashMap }
import ceylon.net.http.server { UploadedFile }

shared class FormDataBuilder() {
    
    value parameters = HashMap<String, SequenceBuilder<String>>();
    value files = HashMap<String, SequenceBuilder<UploadedFile>>();
    
    shared void addParameter(String name, String val) {
        getPostedParameterValues(name).append(val);
    }
    
    shared void addFile(String name, UploadedFile val) {
        getPostedFileValues(name).append(val);
    }
    
    SequenceBuilder<String> getPostedParameterValues(String name) {
        variable SequenceBuilder<String>? builder = parameters.get(name);
        if (exists b = builder) {
            return b;
        } else {
            value b = SequenceBuilder<String>();
            parameters.put(name, b);
            return b;
        }
    }
    
    SequenceBuilder<UploadedFile> getPostedFileValues(String name) {
        variable SequenceBuilder<UploadedFile>? builder = files.get(name);
        if (exists b = builder) {
            return b;
        } else {
            value b = SequenceBuilder<UploadedFile>();
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