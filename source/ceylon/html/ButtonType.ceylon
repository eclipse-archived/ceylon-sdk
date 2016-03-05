"Attribute that represents the type of the button."
tagged("enumerated attribute")
shared class ButtonType
        of submit | reset | button 
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "The button submits the form data to the server. This is the default if the attribute 
     is not specified, or if the attribute is dynamically changed to an empty or invalid value."
    shared new submit {
        attributeValue = "submit";
    }
    
    "The button resets all the controls to their initial values."
    shared new reset {
        attributeValue = "reset";
    }
    
    "The button has no default behavior. It can have client-side scripts associated 
     with the element's events, which are triggered when the events occur."
    shared new button {
        attributeValue = "button";
    }
    
}