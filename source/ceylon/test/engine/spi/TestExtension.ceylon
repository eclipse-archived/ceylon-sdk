"Represents a marker interface for all test extensions."
shared interface TestExtension satisfies Comparable<TestExtension> {
    
    "Returns the order of this test extension."
    shared default Integer order => 0;
    
    "Compares extensions based on their order."
    shared actual Comparison compare(TestExtension other) => order <=> other.order; 
    
}