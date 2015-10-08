import ceylon.interop.java.internal {
    Util
}

import java.lang {
    JavaString=String,
    Class,
    StackTraceElement
}
import ceylon.language.meta.declaration {
    ClassOrInterfaceDeclaration
}

"The [[java.lang::String]] underlying the given Ceylon 
 [[String]]."
shared JavaString javaString(String string) 
        => util.javaString(string);

"A Java [[java.lang::Class]] object representing the given 
 [[Type]]."
shared Class<Type> javaClass<Type>() 
        given Type satisfies Object
        => util.javaClass<Type>();

"A Java [[java.lang::Class]] object representing the 
 concrete type of the given [[instance]]."
shared Class<out Type> javaClassFromInstance<Type>(Type instance) 
        given Type satisfies Object
        => util.javaClassFromInstance(instance);

"A Java [[java.lang::Class]] object representing the given [[ClassOrInterfaceDeclaration]]."
shared Class<out Object> javaClassFromDeclaration(ClassOrInterfaceDeclaration declaration) 
        => util.javaClassForDeclaration(declaration);

"The stack trace information for the given [[Throwable]] as 
 a sequence of Java [[StackTraceElement]]s, or the empty
 sequence if no stack trace information is available. The 
 first element of the sequence is the top of the stack, that 
 is, the most deeply nested stack frame. This is usually the
 stack frame in which the given `Throwable` was created
 and thrown."
shared StackTraceElement[] javaStackTrace(Throwable throwable) 
        => [ for (stackElement in 
                    util.javaStackTrace(throwable).iterable) 
             if (exists stackElement) 
                stackElement ];

Util util = Util();
