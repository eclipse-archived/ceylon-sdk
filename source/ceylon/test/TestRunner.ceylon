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
    ...
}
import ceylon.language.meta.model {
    ...
}

import ceylon.test.engine {
    DefaultTestRunner
}
import ceylon.test.engine.spi {
    TestExtension
}


"Alias for program elements which can be used as a source for discovering tests."
shared alias TestSource
        => Module|Package|ClassDeclaration|FunctionDeclaration|Class<>|FunctionModel<>|String;


"Alias for functions which filter tests. 
 Should return true if the given test should be run, or false if it should be excluded."
shared alias TestFilter
        => Boolean(TestDescription);


"Alias for functions which compare two tests, used for sorting tests in test plan."
shared alias TestComparator
        => Comparison(TestDescription, TestDescription);


"Represents a facade for running tests.
 
 Instances are usually created via the [[createTestRunner]] factory method. 
 For running tests is more convenient to use command line tool `ceylon test` 
 or use integration with IDE, so it is not necessary to use this API directly."
shared interface TestRunner {
    
    "The description of all tests to be run."
    shared formal TestDescription description;
    
    "Runs all the tests and returns a summary result."
    shared formal TestRunResult run();
    
}


"Create a new [[TestRunner]] for the given test sources and configures it 
 according to the given parameters."
shared TestRunner createTestRunner(
    "The program elements from which tests will be executed."
    TestSource[] sources,
    "The extensions which will be used during the test run."
    TestExtension[] extensions = [],
    "A filter function for determining which tests should be run.
     Returns true if the test should be run. 
     The default filter always returns true."
    TestFilter filter = defaultTestFilter,
    "A comparator used to sort the tests, used tests in certain order.
     The default comparator runs the tests in alphabetical order."
    TestComparator comparator = defaultTestComparator)
        => DefaultTestRunner(sources, extensions, filter, comparator);


"Default test filter, always return true."
shared Boolean defaultTestFilter(TestDescription description)
        => true;


"Default test comparator sort tests alphabetically."
shared Comparison defaultTestComparator(TestDescription description1, TestDescription description2)
        => description1.name <=> description2.name;
