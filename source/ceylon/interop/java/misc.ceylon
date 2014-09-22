import java.lang {
    JavaString=String,
    Class
}

import ceylon.interop.java.internal {
    str=javaString,
    classFromType=javaClass,
    classFromInstance=javaClassFromInstance
}

"The [[java.lang::String]] underling the given Ceylon 
 [[String]]."
shared JavaString javaString(String string) => str(string);

"A Java [[java.lang::Class]] object representing the given 
 [[Type]]."
shared Class<out Object> javaClass<Type>() 
        given Type satisfies Object
        => classFromType<Type>();

"A Java [[java.lang::Class]] object representing the 
 concrete type of the given [[instance]]."
shared Class<out Object> javaClassFromInstance(Object instance) 
        => classFromInstance(instance);