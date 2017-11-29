/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.interop.java.internal {
    synchronizeInternal=synchronize
}
import ceylon.language {
    Annotation
}
import ceylon.language.meta.declaration {
    ClassOrInterfaceDeclaration
}
import ceylon.language.meta.model {
    ClassOrInterface
}

import java.lang {
    JavaString=String,
    Class,
    StackTraceElement,
    Types {
        ...
    }
}

"The [[java.lang::String]] underlying the given Ceylon 
 [[String]]."
deprecated("use [[Types.nativeString]]")
shared JavaString javaString(String string) 
        => nativeString(string);

"A Java [[java.lang::Class]] object representing the given 
 [[Type]]."
deprecated("use [[Types.classForType]]")
shared Class<Type> javaClass<Type>() 
        given Type satisfies Object
        => classForType<Type>();

"A Java [[java.lang::Class]] object representing the 
 concrete type of the given [[instance]]."
deprecated("use [[Types.classForInstance]]")
shared Class<out Type> javaClassFromInstance<Type>
        (Type instance) 
        given Type satisfies Object
        => classForInstance(instance);

"A Java [[java.lang::Class]] object representing the given 
 [[ClassOrInterfaceDeclaration]]."
deprecated("use [[Types.classForDeclaration]]")
shared Class<out Object> javaClassFromDeclaration
        (ClassOrInterfaceDeclaration declaration) 
        => classForDeclaration(declaration);

"A Java [[java.lang::Class]] object representing the given 
 [[ClassOrInterface]]."
deprecated("use [[Types.classForModel]]")
shared Class<out Type> javaClassFromModel<Type>
        (ClassOrInterface<Type> model)
        given Type satisfies Object
        => classForModel(model);

"A Java [[java.lang::Class]] object representing the Java
 annotation type corresponding to the given Ceylon
 [[annotation class|Type]]."
deprecated("use [[Types.classForAnnotationType]]")
shared Class<out Type> javaAnnotationClass<Type>()
        given Type satisfies Annotation 
        => classForAnnotationType<Type>();

"The stack trace information for the given [[Throwable]] as 
 a sequence of Java [[StackTraceElement]]s, or the empty
 sequence if no stack trace information is available. The 
 first element of the sequence is the top of the stack, that 
 is, the most deeply nested stack frame. This is usually the
 stack frame in which the given `Throwable` was created
 and thrown."
deprecated("use [[Types.stackTrace]]")
shared StackTraceElement[] javaStackTrace(Throwable throwable) 
        => stackTrace(throwable).sequence();

"Runs the [[do]] callback in a block synchronized on [[on]].
 
     value newCount = synchronize(this, () {
        return count++;
     });

 This is an alternative to direct use of the annotation
 [[java.lang::synchronized]], allowing synchronization on
 a given [[object|on]]."
shared Return synchronize<Return>(Object on, Return do())
        => synchronizeInternal(on, do);
