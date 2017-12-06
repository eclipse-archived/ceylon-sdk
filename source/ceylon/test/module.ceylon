/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""
   The `ceylon.test` module is a simple framework to write repeatable tests.
   
   Tests execute the code of the module under test and 
   can make assertions about what it does. For example,
   
   * do functions, when called with certain arguments, return the expected results?
   * do classes behave as required?
   * etc.
   
   ------------------------------------------------------------------
   
   #### CONTENT
   
   1. [Getting started](#start)
   1. [Running](#running)
   1. [Assertions](#assertions)
   1. [Lifecycle callbacks](#callbacks)
   1. [Disabling tests](#disabling)
   1. [Tagging tests](#tagging)
   1. [Extension points](#extension_points)
   1. [Parameter resolution](#parameter_resolution)
   
   ------------------------------------------------------------------
   
   #### <a name="start"></a> GETTING STARTED
   
   Tests can be written as top level functions ...
   
   ```
   test
   void shouldAlwaysSucceed() {}
   ```
   
   ... or organized inside classes.
   
   
   ```
   class YodaTest() {
   
       test
       void shouldBeJedi() {
           assert(yoda is Jedi);
       }
   
       test
       void shouldHavePower() {
           assert(yoda.midichloriansCount > 1k);
       }
       
   }
   ```
   
   Notice the [[test|test]] annotation, which helps the framework to 
   automatically discover tests.
   
   ------------------------------------------------------------------
   
   #### <a name="running"></a> RUNNING
   
   The most convenient way how to run tests is to use IDE integration
   or via command line tools `ceylon test` and `ceylon test-js`.
   
   ~~~~plain
   $ceylon test com.acme.mymodule
   ~~~~
   
   Tests can be also run programmatically, via interface [[TestRunner]] 
   and its factory method [[createTestRunner]], but this API is usually 
   not necessary to use directly.
   
   ------------------------------------------------------------------
   
   #### <a name="assertions"></a> ASSERTIONS
   
   Assertions can be evaluated by using the language's `assert` statement 
   or with the various `assert...` functions, for example:
   
   ```
   assert(is Hobbit frodo);
   assert(exists ring);
   
   assertNotEquals(frodo, sauron);
   assertThatException(() => gandalf.castLightnings()).hasType(`NotEnoughMagicPowerException`);
   ```
   
   A test function which completes without propagating an exception is 
   classified as a [[success|TestState.success]]. A test function which propagates 
   an [[AssertionError]] is classified as a [[failure|TestState.failure]]. A test 
   function which propagates any other type of `Exception` is classified as 
   an [[error|TestState.error]].
   
   ------------------------------------------------------------------
   
   #### <a name="callbacks"></a> LIFECYCLE CALLBACKS
   
   Common initialization logic can be placed into separate functions, 
   which run [[before|beforeTest]] or [[after|afterTest]] each test.
   
   ```
   class StarshipTest() {
   
       beforeTest void init() => starship.chargePhasers();
   
       afterTest void dispose() => starship.shutdownSystems();
   ```
   
   Or it is possible to execute custom code, which will be executed only once 
   [[before|beforeTestRun]] or [[after|afterTestRun]] whole test run.
   Such callbacks can be only top level functions.
   
    ```
    beforeTestRun
    void createUniverse() { ... }
    
    afterTestRun
    void destroyUniverse() { ... }    
    ``` 
   
   Other options how to hook into tests execution, is to implement [[TestListener]] 
   and react on concrete events. Or if you have to go deeper, there are several 
   [[ceylon.test.engine.spi::TestExtension]] points.
   
   ------------------------------------------------------------------
   
   #### <a name="disabling"></a> DISABLING TESTS
   
   Sometimes you want to temporarily disable a test or a group of tests, 
   this can be done via the [[ignore|ignore]] annotation.
   ```
   test
   ignore("still not implemented")
   void shouldBeFasterThanLight() { ... }
   ```
   
   Sometimes the conditions, if the test can be reliable executed, 
   are know only in runtime, in that case one of the `assume...` functions 
   can be used.
   
   ```
   test
   void shouldBeFasterThanLight() {
       assumeTrue(isWarpDriveAvailable);
       ...
   }
   ```
  
   ------------------------------------------------------------------
   
   #### <a name="tagging"></a> TAGGING TESTS
   
   Tests or its containers can be tagged with one or more [[tags|tag]].
   Those tags can later be used to filter which tests will be executed.
   
   For example test, which is failing often, but from unknow reasons, 
   can be marked as _unstable_ ...
   
   ~~~~
   test
   tag("unstable")
   shared void shouldSucceedWithLittleLuck() { ... }
   ~~~~
     
   ... and then excluded from test execution
   
   ~~~~plain
   $ceylon test --tag=!unstable com.acme.mymodule
   ~~~~
   
   ... or visa versa, we can execute only tests with this tag
   
   ~~~~plain
   $ceylon test --tag=unstable com.acme.mymodule
   ~~~~
   
   ------------------------------------------------------------------
   
   #### <a name="extension_points"></a> EXTENSION POINTS
   
   Test execution can be extended or completely changed by several extension points. 
   All extension points are child of marker interface [[ceylon.test.engine.spi::TestExtension]]
   and here is a list of currently available extension points:
   
   - [[TestListener]]
   - [[ceylon.test.engine.spi::TestInstanceProvider]]
   - [[ceylon.test.engine.spi::TestInstancePostProcessor]]
   - [[ceylon.test.engine.spi::TestVariantProvider]]
   - [[ceylon.test.engine.spi::ArgumentListResolver]]
   
   Extensions can be registered declaratively on several places: on concreate test, on class which contains tests, 
   on whole package or even module, with help of [[testExtension|testExtension]] annotation, for example:
   
   ```
   testExtension(`class DependencyInjectionInstancePostProcessor`,
                 `class TransactionTestListener`)
   package com.acme;
   ```
   
   ------------------------------------------------------------------
   
   #### <a name="parameter_resolution"></a> PARAMETER RESOLUTION
   
   It is possible to write parameterized tests. The responsibility for resolving argument lists 
   is on [[ceylon.test.engine.spi::ArgumentListResolver]]. It's default implementation find annotation 
   which satisfy [[ceylon.test.engine.spi::ArgumentListProvider]] or [[ceylon.test.engine.spi::ArgumentProvider]] interface, 
   collect values from them and prepare all possible combination. 
   Developers can easily implement their own argument providers, currently there exists basic implementation, [[parameters|parameters]] annotation.
   
   Example:
   
   ``` 
   shared {[Integer, Integer]*} fibonnaciNumbers => {[1, 1], [2, 1], [3, 2], [4, 3], [5, 5], [6, 8] ...};
   
   test
   parameters(`value fibonnaciNumbers`)
   shared void shouldCalculateFibonacciNumber(Integer input, Integer result) {
       assert(fibonacciNumber(input) == result);
   }
   ```   
   
   ------------------------------------------------------------------
   
   """
by ("Tom Bentley", "Tomáš Hradec")
license ("Apache Software License")
label("Ceylon Automated Testing Framework")
module ceylon.test maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    import ceylon.collection "1.3.4-SNAPSHOT";
    
    native("jvm") import java.base "7";
    native("jvm") import org.jboss.modules "1.4.4.Final";
    native("jvm") import ceylon.file "1.3.4-SNAPSHOT";
    native("jvm") import ceylon.runtime "1.3.4-SNAPSHOT";
    
}
