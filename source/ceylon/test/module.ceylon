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
   or with the various `assert...`_ functions, for example:
   ```
   assert(is Hobit frodo);
   assert(exists ring);
	
   assertNotEquals(frodo, sauron);
   assertThatException(() => gandalf.castLightnings()).hasType(`NotEnoughMagicPowerException`);
   ```
   
   It's also perfectly acceptable to throw 
   [[AssertionException]] directly.
   
   A test function which completes without propogating an exception is 
   classified as a [[success]]. A test function which propogates 
   an [[AssertionException]] is classified as a [[failure]]. A test 
   function which propogates any other type of `Exception` is classified as 
   an [[error]].
   
   Test functions can be grouped together inside a class.
   ```
   class YodaTest() {
   
       test void shouldBeJedi() {
           assert(yoda is Jedi);
       }
   
       test void shouldHavePower() {
           assert(yoda.midichloriansCount > 1k);
       }
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
   
   Tests can be run programmatically for a whole module, a package or only 
   individual classes and functions. This is usually achieved using the
   [[createTestRunner]] factory method, most simply by giving it the 
   declaration of the module to be run:
   ```
   value result = createTestRunner([`module com.acme`]).run();
   print(result.isSuccess);
   ```
   Or by enumerating the things to be tested:
   ```
   value result = createTestRunner([
       `funtion shouldAlwaysSucceed`,
       `class YodaTest`,
       `class StarshipTest`,
       `function shouldBeFasterThanLight`]).run();
   print(result.isSuccess);
   ```
   
   Although you can implement the [[TestRunner]] interface directly,
   [[createTestRunner]] has numerous defaulted parameters which usually 
   mean you don't have to.
    
   Using listeners you can react to important events during test execution, 
   or you can exclude particular tests, or execute them in a specific order.
   ```
   object ringingListener satisfies TestListener {
       shared actual void testError(TestResult result) => alarm.ring();
   }
    
   Boolean integrationTestFilter(TestDescription d) {
       return d.name.endsWith("IntegrationTest");
   }
    
   Comparison failFastComparator(TestDescription d1, TestDescription d2) {
       return dateOfLastFailure(d1) <=> dateOfLastFailure(d2);
   }
    
   TestRunner runner = createTestRunner{
       sources = [`module com.acme`];
       listeners = [ringingListener];
       filter = integrationTestFilter;
       comparator = failFastComparator;
   };
   ```
   
"""
by("Tom Bentley", "Tomáš Hradec")
license("Apache Software License")
module ceylon.test '0.6.1' {
    import java.base "7"; // TODO temporary dependency, until metamodel will not support "unsafe invoke"
}
