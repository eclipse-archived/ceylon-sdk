/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.language { String }

"Represents the failure of a type conversion.  
 An instance is typically thrown as a result of trying to 
 get and convert an [[Object]] member or [[Array]] element 
 which cannot be converted to the requested or implied type."
shared class InvalidTypeException(String message) 
        extends Exception(message){
}