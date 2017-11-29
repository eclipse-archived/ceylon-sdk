/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A set of adaptors for types belonging to the Java language
 or Java SDK. Includes:
 
 - a set of functions for instantiating Java array types
   given a stream of values, for example,
   [[createJavaIntArray]], [[createJavaFloatArray]],
   [[createJavaByteArray]], [[createJavaBooleanArray]],
   [[createJavaObjectArray]], and
   [[createJavaStringArray]],
 - a set of functions for converting between Ceylon's
   [[Array]] class and Java array types, for example,
   [[javaIntArray]], [[javaFloatArray]], [[javaByteArray]],
   [[javaBooleanArray]], [[javaObjectArray]], and
   [[javaStringArray]],
 - classes adapting Java collection types to Ceylon 
   collection interfaces: [[CeylonList]], [[CeylonSet]], 
   [[CeylonMap]],
 - classes adapting Ceylon collection types to Java 
   collection interfaces: [[JavaList]], [[JavaSet]],
   [[JavaMap]], and
 - [[CeylonIterable]] and [[JavaIterable]] which adapt 
   between Java's [[java.lang::Iterable]] interface and 
   Ceylon's [[Iterable]] interface,
 - [[CeylonStringIterable]], [[CeylonIntegerIterable]],
   [[CeylonFloatIterable]], [[CeylonByteIterable]], and
   [[CeylonBooleanIterable]], which adapt Java 
   [[java.lang::Iterable]]s of primitive types,
 - [[CeylonStringList]], [[CeylonStringMap]],
   [[JavaStringList]], and [[JavaStringMap]], which adapt
   maps and lists containing strings, and
 - [[JavaRunnable]] and [[JavaThread]] which adapt Ceylon
   functions to Java's [[java.lang::Runnable]] and 
   [[java.lang::Thread]].
   
 In addition, the functions [[javaClass]] and 
 [[javaClassFromInstance]] allow Ceylon programs to obtain
 an instance of [[java.lang::Class]]."
by("The Ceylon Team")
native("jvm")
module ceylon.interop.java maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import java.base "7";
    shared import ceylon.collection "1.3.4-SNAPSHOT";
}
