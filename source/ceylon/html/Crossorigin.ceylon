/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute indicates whether CORS must be used when fetching the related image."
tagged("enumerated attribute")
shared class Crossorigin
        of anonymous | useCredentials 
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "A cross-origin request (i.e. with Origin: HTTP header) is performed. But no 
     credential is sent (i.e. no cookie, no X.509 certificate and no HTTP Basic 
     authentication is sent). If the server does not give credentials to the origin 
     site (by not setting the Access-Control-Allow-Origin: HTTP header) the image 
     will be tainted and its usage restricted."
    shared new anonymous {
        attributeValue = "anonymous";
    }
    
    "A cross-origin request (i.e. with Origin: HTTP header) is performed with credential 
     is sent (i.e. a cookie, a certificate and HTTP Basic authentication is performed). 
     If the server does not give credentials to the origin site (through Access-Control-Allow-Credentials: 
     HTTP header), the image will be tainted and its usage restricted."
    shared new useCredentials {
        attributeValue = "use-credentials";
    }
    
}