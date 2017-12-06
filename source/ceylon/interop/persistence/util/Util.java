package ceylon.interop.persistence.util;

import ceylon.language.meta.model.Class;
import org.eclipse.ceylon.compiler.java.metadata.TypeInfo;
import org.eclipse.ceylon.compiler.java.runtime.metamodel.decl.ClassOrInterfaceDeclarationImpl;

public class Util {

    public static <Type> java.lang.Class<Type> javaClass(
            @TypeInfo("ceylon.language.meta.model::Class<Type>")
                    Class type) {
        ClassOrInterfaceDeclarationImpl declaration
                = (ClassOrInterfaceDeclarationImpl)
                        type.getDeclaration();
        java.lang.Class javaClass = declaration.getJavaClass();
        //convert Ceylon "primitive" classes to Java wrapper classes
        if (javaClass.equals(ceylon.language.Integer.class)) {
            javaClass = Long.class;
        }
        if (javaClass.equals(ceylon.language.Float.class)) {
            javaClass = Double.class;
        }
        else if (javaClass.equals(ceylon.language.String.class)) {
            javaClass = String.class;
        }
        else if (javaClass.equals(ceylon.language.Boolean.class)) {
            javaClass = Boolean.class;
        }
        else if (javaClass.equals(ceylon.language.Byte.class)) {
            javaClass = Byte.class;
        }
        else if (javaClass.equals(ceylon.language.Character.class)) {
            javaClass = Integer.class;
        }
        return (java.lang.Class<Type>) javaClass;
    }

}
