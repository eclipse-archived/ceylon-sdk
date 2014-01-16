package ceylon.interop.java;

import com.redhat.ceylon.compiler.java.Util;


@com.redhat.ceylon.compiler.java.metadata.Ceylon(major = 6)
@ceylon.language.DocAnnotation$annotation$(description = "Takes a Ceylon list of items and turns them into a Java `Collection`")
@ceylon.language.SharedAnnotation$annotation$
@com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation(value = "doc", arguments = {"Takes a Ceylon list of items and turns them into a Java `Collection`"}), @com.redhat.ceylon.compiler.java.metadata.Annotation("shared")})
@com.redhat.ceylon.compiler.java.metadata.SatisfiedTypes({"java.util::Collection<T>"})
@com.redhat.ceylon.compiler.java.metadata.TypeParameters({@com.redhat.ceylon.compiler.java.metadata.TypeParameter(value = "T", variance = com.redhat.ceylon.compiler.java.metadata.Variance.NONE, satisfies = {}, caseTypes = {})})
public class JavaCollection<T> implements com.redhat.ceylon.compiler.java.runtime.model.ReifiedType, java.util.Collection<T> {
    
    public JavaCollection(@com.redhat.ceylon.compiler.java.metadata.Ignore
    com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor $reifiedT, @com.redhat.ceylon.compiler.java.metadata.Name("items")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Iterable<T,ceylon.language::Null>")
    final ceylon.language.Iterable<? extends T, ? extends java.lang.Object> items) {
        this.$reifiedT = $reifiedT;
        this.items = items;
    }
    @com.redhat.ceylon.compiler.java.metadata.Ignore
    private final com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor $reifiedT;
    private final ceylon.language.Iterable<? extends T, ? extends java.lang.Object> items;
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Boolean")
    public final boolean add(@com.redhat.ceylon.compiler.java.metadata.Name("e")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Null|T")
    final T e) {
        throw new java.lang.UnsupportedOperationException("add()");
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Boolean")
    public final boolean addAll(@com.redhat.ceylon.compiler.java.metadata.Name("collection")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Null|java.util::Collection<T>")
    final java.util.Collection<? extends T> collection) {
        throw new java.lang.UnsupportedOperationException("addAll()");
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Anything")
    public final void clear() {
        throw new java.lang.UnsupportedOperationException("clear()");
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Boolean")
    public final boolean contains(@com.redhat.ceylon.compiler.java.metadata.Name("obj")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Null|ceylon.language::Object")
    final java.lang.Object obj) {
        java.lang.Object $obj$1;
        if (($obj$1 = obj) != null) {
            final java.lang.Object $obj$2 = $obj$1;
            return items.contains($obj$2);
        } else {
            return false;
        }
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Boolean")
    public final boolean containsAll(@com.redhat.ceylon.compiler.java.metadata.Name("collection")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Null|java.util::Collection<ceylon.language::Object>")
    final java.util.Collection<?> collection) {
//        java.util.Collection<?> $collection$4;
//        if (($collection$4 = collection) != null) {
//            final java.util.Collection<java.lang.Object> $collection$5 = (java.util.Collection<Object>) $collection$4;
//            return items.containsEvery(new ceylon.interop.java.CeylonIterable<java.lang.Object>(ceylon.language.Object.$TypeDescriptor, $collection$5));
//        } else {
            return false;
//        }
    }
    
  
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Boolean")
    public final boolean isEmpty() {
        return items.getEmpty();
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("java.util::Iterator<T>")
    public final java.util.Iterator<T> iterator() {
        return null;
//        return new ceylon.interop.java.JavaIterator<T>($reifiedT, items.iterator());
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Boolean")
    public final boolean remove(@com.redhat.ceylon.compiler.java.metadata.Name("obj")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Null|ceylon.language::Object")
    final java.lang.Object obj) {
        throw new java.lang.UnsupportedOperationException("remove()");
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Boolean")
    public final boolean removeAll(@com.redhat.ceylon.compiler.java.metadata.Name("collection")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Null|java.util::Collection<ceylon.language::Object>")
    final java.util.Collection<?> collection) {
        throw new java.lang.UnsupportedOperationException("removeAll()");
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Boolean")
    public final boolean retainAll(@com.redhat.ceylon.compiler.java.metadata.Name("collection")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Null|java.util::Collection<ceylon.language::Object>")
    final java.util.Collection<?> collection) {
        throw new java.lang.UnsupportedOperationException("retainAll()");
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Integer")
    public final int size() {
        return (int)items.getSize();
    }

    @java.lang.Override
    public final java.lang.Object[] toArray() {
        return Util.collectIterable(items).toArray();
    }

    @java.lang.Override
    public <S> S[] toArray(S[] arr) {
		return Util.collectIterable(items).toArray(arr);
    }
    
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Boolean")
    public final boolean equals(@com.redhat.ceylon.compiler.java.metadata.Name("that")
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Object")
    final java.lang.Object that) {
        return items.equals(that);
    }
    
    @com.redhat.ceylon.compiler.java.metadata.Annotations({@com.redhat.ceylon.compiler.java.metadata.Annotation("shared"), @com.redhat.ceylon.compiler.java.metadata.Annotation("actual")})
    @ceylon.language.SharedAnnotation$annotation$
    @ceylon.language.ActualAnnotation$annotation$
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.TypeInfo("ceylon.language::Integer")
    public final int hashCode() {
        return items.hashCode();
    }
    
    @java.lang.Override
    @com.redhat.ceylon.compiler.java.metadata.Ignore
    public com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor $getType$() {
        return com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor.klass(ceylon.interop.java.JavaCollection.class, $reifiedT);
    }
}
