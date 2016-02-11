"Represents a marker interface for all test extensions."
shared interface TestExtension {
    
    "Returns the order of this test extension."
    shared default Integer order => 0;
    
}