"The `test.ceylon.test.stubs` module contains only stubs of tests,
 which are used for testing `ceylon.test` module, these tests shouldn't be 
 executed directly, because contains failing and invalid code. "
module test.ceylon.test.stubs "1.2.1" {
    shared import ceylon.test "1.2.1";
    shared import ceylon.collection "1.2.1";
}