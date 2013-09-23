"""
   Module _ceylon.test_ is a simple framework to write repeatable tests.
   
   Here is simplest [[test]] function, which always succeed.
   ```
   test
   void shouldAlwaysSucceed() {}
   
   ```
   
   Assertions can be evaluate with usage of _assert_ statement or with various _assert..._ functions, eg.
   ```
   assert(is Hobit frodo);
   assert(exists ring);
	
   assertNotEquals(frodo, sauron);
   assertThatException(() => gandalf.castLightnings()).hasType(`NotEnoughMagicPowerException`);
   ```
   
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
   
   Common initialization logic can be placed into separate functions, which run [[before|beforeTest]] or [[after|afterTest]] each test.
   ```
   class StarshipTest() {
    
       beforeTest void init() => starship.chargePhasers();
        
       afterTest void dispose() => starship.shutdownSystems();
   ```
   
   Sometimes you want to temporarily disable a test or a group of tests, this can be done via [[ignore]] annotation.
   ```
   test
   ignore("still not implemented")
   void shouldBeFasterThanLight() {
   ```
   
   Tests can be run programmatically for whole module, package or only individual classes and functions 
   through interface [[TestRunner]] and its factory method [[createTestRunner]].
   ```
   value result = createTestRunner([`module com.acme`]).run();
   print(result.isSuccess);
   ```
   
   But function [[createTestRunner]] accept a lot more parameters. 
   With usage of listeners you can react on important events during tests execution, 
   or you can exclude particular tests, or execute them in specific order.
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
