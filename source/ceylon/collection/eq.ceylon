
Boolean eq(Anything a, Anything b){
    if(exists a){
        if(exists b){
            return a == b;
        }
        return false;
    }
    return !b exists;
}
