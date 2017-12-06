/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""Contains everything required to parse and serialise JSON 
   data.
   
   Sample usage for parsing and accessing JSON:
   
       import ceylon.json {
           parse, Object
       }
   
       String getAuthor(String json){
           value parsedJson = parse(json);
           "author must be a string"
           assert(is Object parsedJson, is String author = parsedJson["author"]);
           return author;
       }
   
   Alternatively, this variation will result in an 
   [[InvalidTypeException]] instead of an [[AssertionError]]
   if the input JSON data doesn't have the expected format:
   
       import ceylon.json {
           parse, Object
       }
   
       String getAuthor(String json){
           assert(is Object parsedJson = parse(json));
           return parsedJson.getString("author");
       }
   
   You can iterate JSON objects too:
   
       import ceylon.json {
           parse, Array, Object
       }
   
       {String*} getModules(String json){
           assert(is Object parsedJson = parse(json));
           if(is Array modules = parsedJson.get("modules")){
               return { for (mod in modules) 
                          if(is Object mod, 
                             is String name = mod.get("name")) 
                            name 
                      };
           }
           throw Exception("Invalid JSON data");
       }
   
   Sample usage for generating JSON data:
   
       import ceylon.json {
           Object, Array
       }
   
       String getJSON(){
           value json = Object {
               "name" -> "Introduction to Ceylon",
               "authors" -> Array {
                   "Stef Epardaud",
                   "Emmanuel Bernard"
               }
           };
           return json.string;
       }
 """
by("Stéphane Épardaud", "Tom Bentley")
license("Apache Software License")
label("Ceylon JSON Processing API")
module ceylon.json maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import ceylon.collection "1.3.4-SNAPSHOT";
}
