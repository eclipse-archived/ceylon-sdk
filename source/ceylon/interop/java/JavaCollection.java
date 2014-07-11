package ceylon.interop.java;

import java.util.Iterator;

import ceylon.language.Finished;

@com.redhat.ceylon.compiler.java.metadata.Ceylon(major = 7)
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
        if (collection != null) {
            ceylon.language.Iterator iterator = items.iterator();
            Object o;
            while (!((o = iterator.next()) instanceof Finished)) {
                if (!items.contains(o)) {
                    return false;
                }
            }
            return true;
        } else {
            return false;
        }
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
        return new ceylon.interop.java.JavaIterator<T>($reifiedT, items.iterator());
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
        return collectIterable(items).toArray();
    }

    @java.lang.Override
    public <S> S[] toArray(S[] arr) {
        if (items.longerThan(arr.length)) {
            ReflectingObjectArrayBuilder<S> builder = new ReflectingObjectArrayBuilder<S>(5, (Class<S>)arr.getClass().getComponentType());
            ceylon.language.Iterator iterator = items.iterator();
            Object o;
            while (!((o = iterator.next()) instanceof Finished)) {
                builder.appendRef((S)o);
            }
            return builder.build();
        } else {
            int ii = 0;
            ceylon.language.Iterator iterator = items.iterator();
            Object o;
            while (!((o = iterator.next()) instanceof Finished)) {
                arr[ii] = (S)o;
                ii++;
            }
            if (ii < arr.length) {
                arr[ii] = null;
            }
            return arr;
        }
    }
    
    @SuppressWarnings("unchecked")
    private static <T> java.util.List<T> collectIterable(ceylon.language.Iterable<? extends T, ?> sequence) {
        java.util.List<T> list = new java.util.LinkedList<T>();
        if (sequence != null) {
            ceylon.language.Iterator<? extends T> iterator = sequence.iterator();
            Object o; 
            while((o = iterator.next()) != ceylon.language.finished_.get_()){
                list.add((T)o);
            }
        }
        return list;
    }
    
    private static abstract class ArrayBuilder<A> {
        private static final int MIN_CAPACITY = 5;
        private static final int MAX_CAPACITY = java.lang.Integer.MAX_VALUE;
        /** The number of elements in {@link #array}. This is always <= {@link #capacity} */
        protected int size;
        /** The length of {@link #array} */
        protected int capacity;
        /** The array */
        protected A array;
        ArrayBuilder(int initialSize) {
            capacity = Math.max(initialSize, MIN_CAPACITY);
            array = allocate(capacity);
            size = 0;
        }
        /** Append all the elements in the given array */
        final void appendArray(A elements) {
            int increment = size(elements);
            int newsize = this.size + increment;
            ensure(newsize);
            System.arraycopy(elements, 0, array, this.size, increment);
            this.size = newsize;
        }
        /** Ensure the {@link #array} is as big, or bigger than the given capacity */
        protected final void ensure(int requestedCapacity) {
            if (this.capacity >= requestedCapacity) {
                return;
            }
            
            int newcapacity = requestedCapacity+(requestedCapacity>>1);
            if (newcapacity < MIN_CAPACITY) {
                newcapacity = MIN_CAPACITY;
            } else if (newcapacity > MAX_CAPACITY) {
                newcapacity = requestedCapacity;
                if (newcapacity > MAX_CAPACITY) {
                    throw new AssertionError("can't allocate array bigger than " + MAX_CAPACITY);
                }
            }
            
            A newArray = allocate(newcapacity);
            System.arraycopy(this.array, 0, newArray, 0, this.size);
            this.capacity = newcapacity;
            this.array = newArray;
        }
        
        /**
         * Allocate and return an array of the given size
         */
        protected abstract A allocate(int size);
        /**
         * The size of the given array
         */
        protected abstract int size(A array);
        
        /**
         * Returns an array of exactly the right size to contain all the 
         * appended elements.
         */
        A build() {
            if (this.capacity == this.size) {
                return array;
            }
            A result = allocate(this.size);
            System.arraycopy(this.array, 0, result, 0, this.size);
            return result;
        }
    }
    
    private static final class ReflectingObjectArrayBuilder<T> extends ArrayBuilder<T[]> {
        private final java.lang.Class<T> klass;
        public ReflectingObjectArrayBuilder(int initialSize, java.lang.Class<T> klass) {
            super(initialSize);
            this.klass = klass;
        }
        @SuppressWarnings("unchecked")
        @Override
        protected T[] allocate(int size) {
            return (T[])new Object[size];
        }
        @Override
        protected int size(T[] array) {
            return array.length;
        }
        
        public void appendRef(T t) {
            ensure(size+1);
            array[size] = t;
            size++;
        }
        public T[] build() {
            T[] result = (T[])java.lang.reflect.Array.newInstance(klass, this.size);
            System.arraycopy(this.array, 0, result, 0, this.size);
            return result;
        }
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
