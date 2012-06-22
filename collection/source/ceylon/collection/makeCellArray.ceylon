import ceylon.collection.impl { Arrays { jmakeCellArray = makeCellArray } }

Array<T> makeCellArray<T>(Integer size){
    return jmakeCellArray<T>(size);
}