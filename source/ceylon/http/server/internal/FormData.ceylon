/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection { 
    HashMap,
    ArrayList
}
import ceylon.http.server { UploadedFile }

class FormDataBuilder() {
    
    value parameters = HashMap<String, ArrayList<String>>();
    value files = HashMap<String, ArrayList<UploadedFile>>();
    
    shared void addParameter(String name, String val) 
            => getPostedParameterValues(name).add(val);
    
    shared void addFile(String name, UploadedFile val) 
            => getPostedFileValues(name).add(val);
    
    ArrayList<String> getPostedParameterValues(String name) {
        value builder = parameters[name];
        if (exists b = builder) {
            return b;
        } else {
            value b = ArrayList<String>();
            parameters[name] = b;
            return b;
        }
    }
    
    ArrayList<UploadedFile> getPostedFileValues(String name) {
        value builder = files[name];
        if (exists b = builder) {
            return b;
        } else {
            value b = ArrayList<UploadedFile>();
            files[name] = b;
            return b;
        }
    }
    
    shared FormData build() {
        value parametersSequence = HashMap<String, String[]>();
        value filesSequence = HashMap<String, UploadedFile[]>();
        
        for (key->parameterValues in parameters) {
            parametersSequence[key] = parameterValues.sequence();
        }
        
        for (key->fileValues in files) {
            filesSequence[key] = fileValues.sequence();
        }
        
        
        return FormData { 
            parameters => parametersSequence; 
            files => filesSequence; 
        };
    }
}

class FormData(parameters, files) {
    shared Map<String, String[]> parameters;
    shared Map<String, UploadedFile[]> files;
}