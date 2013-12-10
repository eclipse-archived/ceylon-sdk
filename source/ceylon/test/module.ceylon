"""
   The `ceylon.test` module is a simple framework to write repeatable tests.
   
   Tests execute the code of the module under test and 
   can make assertions about what it does. For example,
   
   * do functions, when called with certain arguments, return the expected results?
   * do classes behave as required?
   * etc.
   
   The usual way to use this module is to write your tests (which make
   calls to the declarations under test) as top level functions or
   as methods of top level classes, annotating them with [[test]]. 
   
   For example, here is a trivial [[test]] function, which will always succeed.
   ```
   test
   void shouldAlwaysSucceed() {}
   ```
   
   Assertions can be evaluated by using the language's `assert` statement 
   or with the various `assert...` functions, for example:
   ```
   assert(is Hobbit frodo);
   assert(exists ring);
   
   assertNotEquals(frodo, sauron);
   assertThatException(() => gandalf.castLightnings()).hasType(`NotEnoughMagicPowerException`);
   ```
   
   It's also perfectly acceptable to throw 
   [[AssertionException]] directly.
   
   A test function which completes without propagating an exception is 
   classified as a [[success]]. A test function which propagates 
   an [[AssertionException]] is classified as a [[failure]]. A test 
   function which propagates any other type of `Exception` is classified as 
   an [[error]].
   
   Test functions can be grouped together inside a class.
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
   ```
   
   Or several tests can be combined into [[testSuite]] and then run together.
   ```
   testSuite({`class YodaTest`,
              `class DarthVaderTest`,
              `function starOfDeathTestSuite`})
   void starwarsTestSuite() {}   
   ```
   
   Common initialization logic can be placed into separate functions, 
   which run [[before|beforeTest]] or [[after|afterTest]] each test.
   ```
   class StarshipTest() {
   
       beforeTest void init() => starship.chargePhasers();
   
       afterTest void dispose() => starship.shutdownSystems();
   ```
   
   Sometimes you want to temporarily disable a test or a group of tests, 
   this can be done via the [[ignore]] annotation.
   ```
   test
   ignore("still not implemented")
   void shouldBeFasterThanLight() {
   ```
   
   The most convenient way how to run tests is to use IDE integration
   or via command line tool `ceylon test`.
   
   Tests can be also run programmatically, via interface [[TestRunner]] and its factory method [[createTestRunner]], 
   but this API is usually not necessary to use directly. 
   
   """
by("Tom Bentley", "Tomáš Hradec")
license("Apache Software License")
module ceylon.test "1.0.0" {}