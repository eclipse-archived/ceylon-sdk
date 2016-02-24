"""
   The `ceylon.test` module is a simple framework to write repeatable tests.
   
   Tests execute the code of the module under test and 
   can make assertions about what it does. For example,
   
   * do functions, when called with certain arguments, return the expected results?
   * do classes behave as required?
   * etc.
   
   ------------------------------------------------------------------
   
   #### GETTING STARTED
   
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
   ```
   
   (notice the [[test]] annotation, which helps the framework to discover tests)
   
   ------------------------------------------------------------------
   
   #### ASSERTIONS
   
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
   
   #### HOOKS
   
   Common initialization logic can be placed into separate functions, 
   which run [[before|beforeTest]] or [[after|afterTest]] each test.
   
   ```
   class StarshipTest() {
   
       beforeTest void init() => starship.chargePhasers();
   
       afterTest void dispose() => starship.shutdownSystems();
   ```
   
   Other options how to hook into tests execution, is to implement [[TestListener]] 
   and react on concrete events. Or if you have to go deeper, there are several 
   [[ceylon.test.engine.spi::TestExtension]] points.
   
   ------------------------------------------------------------------
   
   #### DISABLING TESTS
   
   Sometimes you want to temporarily disable a test or a group of tests, 
   this can be done via the [[ignore]] annotation.
   ```
   test
   ignore("still not implemented")
   void shouldBeFasterThanLight() {
   ```
   
   Sometimes the conditions, if the test can be reliable executed, 
   are know only in runtime, in that case one of the `assume...` functions 
   can be used.
  
   ------------------------------------------------------------------
   
   #### RUNNING
   
   The most convenient way how to run tests is to use IDE integration
   or via command line tools `ceylon test` and `ceylon test-js`.
   
   ~~~~plain
   $ceylon test com.acme.mymodule
   ~~~~
   
   Tests can be also run programmatically, via interface [[TestRunner]] 
   and its factory method [[createTestRunner]], but this API is usually 
   not necessary to use directly.
   
   ------------------------------------------------------------------
   
   """
by ("Tom Bentley", "Tomáš Hradec")
license ("Apache Software License")
module ceylon.test "1.2.2" {
    import ceylon.collection "1.2.2";
    
    native("jvm") import java.base "7";
    native("jvm") import org.jboss.modules "1.4.4.Final";
    native("jvm") import ceylon.file "1.2.2";
    native("jvm") import ceylon.runtime "1.2.2";
    
}
