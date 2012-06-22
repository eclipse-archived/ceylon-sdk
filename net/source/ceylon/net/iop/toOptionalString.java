package ceylon.net.iop;

@com.redhat.ceylon.compiler.java.metadata.Ceylon(major = 1)
@com.redhat.ceylon.compiler.java.metadata.Method
public final class toOptionalString {

    private toOptionalString() {
    }

    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared")})
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language.Nothing|ceylon.language.String")
    public static ceylon.language.String toOptionalString(@com.redhat.ceylon.compiler.java.metadata.Name("s")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language.String")
    final java.lang.String s) {
        return s != null ? ceylon.language.String.instance(s) : null;
    }
}
