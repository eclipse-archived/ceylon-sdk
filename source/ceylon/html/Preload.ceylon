"Attribute is intended to provide a hint to the browser about what the author thinks 
 will lead to the best user experience."
tagged("enumerated attribute")
shared class Preload
        of none | metadata | auto 
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Indicates that the audio should not be preloaded."
    shared new none {
        attributeValue = "none";
    }
    
    "Indicates that only audio metadata (e.g. length) is fetched."
    shared new metadata {
        attributeValue = "metadata";
    }
    
    "Indicates that the whole audio file could be downloaded, even 
     if the user is not expected to use it."
    shared new auto {
        attributeValue = "auto";
    }
    
}