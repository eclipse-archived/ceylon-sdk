import ceylon.io { FileDescriptor }
import ceylon.file { File, Resource }
import ceylon.io.impl { OpenFileImpl }

doc "Represents a file object we can read/write to."
shared interface OpenFile satisfies FileDescriptor {

    doc "Returns the `Resource` object that contains metadata about this open resource."
    shared formal Resource resource;

    doc "The current position within this open file. The position is used to
         indicate where read/writes will start, and increases on every read/write
         operation that successfully completes."
    shared formal variable Integer position;
    
    doc "The current size of this open file."
    shared formal Integer size;
    
    doc "Truncates this open file to the given `size`. The new `size` has to be
         smaller than the current `size`."
    // FIXME: should this be the setter for `size`?
    // due to the semantics of truncate (only works if smaller) this is not clear:
    // if we call truncate with a larger than size param, the size will not change
    // unless we also write there 
    shared formal void truncate(Integer size);

}


doc "Creates a new [[OpenFile]] to read/write to the given [[resource]]."
see (OpenFile)
shared OpenFile newOpenFile(Resource resource){
    return OpenFileImpl(resource);
}
