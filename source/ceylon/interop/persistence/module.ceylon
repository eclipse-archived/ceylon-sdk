/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Provides a Ceylonic [[EntityManager]] for use with the Java
 Persistence API. An `EntityManager` may be instantiated
 directly, given an instance of
 [[javax.persistence.EntityManager|javax.persistence::EntityManager]].

     value emf = Persistence.createEntityManagerFactory(\"example\");
     value em = EntityManger(emf.createEntityManager());

 The `EntityManager` provides all the same operations as
 `javax.persistence.EntityManager`, but:

 1. is slightly more typesafe, and
 2. accepts [[Integer]], [[Float]], [[String]],
    [[Character]], and [[Boolean]], arguments to
    [[EntityManager.find]],
    [[EntityManager.getReference]] and
    [[Query.setParameter]].

 Note: it's perfectly possible to directly use the
 `javax.persistence.EntityManager` from Ceylon, but in that
 case, it's necessary to explicitly convert arguments to
 [[`java.lang.Long`|java.lang::Long]],
 [[`java.lang.Double`|java.lang::Double]],
 [[`java.lang.String`|java.lang::String]],
 [[`java.lang.Character`|java.lang::Character]], or
 [[`java.lang.Boolean`|java.lang::Boolean]]."
native ("jvm")
module ceylon.interop.persistence maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import maven:org.hibernate.javax.persistence:"hibernate-jpa-2.1-api" "1.0.0.Final";
    shared import ceylon.interop.java "1.3.4-SNAPSHOT";
    shared import java.jdbc "7";
}
