/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.language.meta.declaration {
    ClassDeclaration,
    Package,
    FunctionDeclaration
}
import ceylon.language.meta {
    modules
}
import ceylon.collection {
    ArrayList
}

shared Package? findPackage(String pkgName) {
    for(m in modules.list) {
        if( pkgName.startsWith(m.name) ) {
            if( exists p = m.findPackage(pkgName)) {
                return p;
            }
        }
    }
    return null;
}

shared A[] findAnnotations<out A>(FunctionDeclaration funcDecl, ClassDeclaration? classDecl)
        given A satisfies Annotation {
    
    // WORKAROUND #5782 Can't lookup annotations which satisfy interface
    // https://github.com/ceylon/ceylon/issues/5782 
    
    value annotationBuilder = ArrayList<Annotation>();
    
    annotationBuilder.addAll(funcDecl.annotations<Annotation>());
    if (exists classDecl) {
        annotationBuilder.addAll(findAnnotations2<Annotation>(classDecl));
        annotationBuilder.addAll(classDecl.containingPackage.annotations<Annotation>());
        annotationBuilder.addAll(classDecl.containingModule.annotations<Annotation>());
    } else {
        annotationBuilder.addAll(funcDecl.containingPackage.annotations<Annotation>());
        annotationBuilder.addAll(funcDecl.containingModule.annotations<Annotation>());
    }
    
    return annotationBuilder.narrow<A>().sequence();
}

shared A? findAnnotation<out A>(FunctionDeclaration funcDecl, ClassDeclaration? classDecl)
        given A satisfies Annotation {
    variable value a = funcDecl.annotations<A>()[0];
    if (!(a exists)) {
        if (exists classDecl) {
            a = findAnnotations2<A>(classDecl)[0];
            if (!(a exists)) {
                a = classDecl.containingPackage.annotations<A>()[0];
                if (!(a exists)) {
                    a = classDecl.containingModule.annotations<A>()[0];
                }
            }
        } else {
            a = funcDecl.containingPackage.annotations<A>()[0];
            if (!(a exists)) {
                a = funcDecl.containingModule.annotations<A>()[0];
            }
        }
    }
    return a;
}

A[] findAnnotations2<out A>(ClassDeclaration classDecl)
        given A satisfies Annotation {
    value annotationBuilder = ArrayList<A>();
    variable ClassDeclaration? declVar = classDecl;
    while (exists decl = declVar) {
        annotationBuilder.addAll(decl.annotations<A>());
        declVar = decl.extendedType?.declaration;
    }
    return annotationBuilder.sequence();
}
