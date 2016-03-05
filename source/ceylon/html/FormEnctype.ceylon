"Attribute that represents type of content that is used to submit the form to the server."
tagged("enumerated attribute")
shared class FormEnctype
        of applicationFormUrlEncoded | multipartFormData | textPlain
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Default. All characters are encoded before sent (spaces are converted to \"+\" symbols, and special characters are converted to ASCII HEX values)."
    shared new applicationFormUrlEncoded {
        attributeValue = "application/x-www-form-urlencoded";
    }
    
    "No characters are encoded. This value is required when you are using forms that have a file upload control."
    shared new multipartFormData {
        attributeValue = "multipart/form-data";
    }
    
    "Spaces are converted to \"+\" symbols, but no special characters are encoded."
    shared new textPlain {
        attributeValue = "text/plain";
    }
    
}
