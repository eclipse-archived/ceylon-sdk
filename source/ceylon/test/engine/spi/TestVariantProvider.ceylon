import ceylon.test {
    TestDescription
}

"Represents a strategy that can resolve test variant description by provided arguments, 
 see [[ceylon.test::TestDescription.variant]]."
shared interface TestVariantProvider satisfies TestExtension {
    
    "Returns test variant description."
    shared formal String variant(TestDescription description, Integer index, Anything[] arguments);
    
}