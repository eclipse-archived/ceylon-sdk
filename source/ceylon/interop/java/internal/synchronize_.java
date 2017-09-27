package ceylon.interop.java.internal;

import ceylon.language.Callable;

import org.eclipse.ceylon.compiler.java.metadata.Ceylon;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.Method;
import org.eclipse.ceylon.compiler.java.metadata.Name;
import org.eclipse.ceylon.compiler.java.metadata.TypeInfo;
import org.eclipse.ceylon.compiler.java.metadata.TypeParameter;
import org.eclipse.ceylon.compiler.java.metadata.TypeParameters;
import org.eclipse.ceylon.compiler.java.runtime.model.TypeDescriptor;

@Ceylon(major = 8)
@Method
public final class synchronize_ {
    
    private synchronize_() {
    }
    
    @TypeParameters({@TypeParameter(value="Return")})
    @TypeInfo("Return")
    public static <Return> Return synchronize(
            @Ignore TypeDescriptor $reifiedReturn,
            @Name("on")
            @TypeInfo("ceylon.language::Object")
            final Object on,
            @Name("do")
            @TypeInfo("ceylon.language::Callable<Return,ceylon.language::Empty>")
            final Callable<? extends Return> toDo
            ) {
        synchronized (on) {
            return toDo.$call$();
        }
    }
    
}
