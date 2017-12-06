import ceylon.test { createTestRunner }
import ceylon.collection { ... }
import ceylon.promise { ... }

shared void run() {
	value testRunner = createTestRunner([`module test.ceylon.promise`]);	
	value result = testRunner.run();
	print(result);
}
