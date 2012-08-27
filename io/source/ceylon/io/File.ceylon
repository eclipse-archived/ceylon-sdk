
shared abstract class File() extends FileDescriptor(){
    
    shared formal variable Integer position;
    
    shared formal Integer size;
    
    // FIXME: should this be the setter for `size`?
    // due to the semantics of truncate (only works if smaller) this is not clear:
    // if we call truncate with a larger than size param, the size will not change
    // unless we also write there 
    shared formal void truncate(Integer size);
}