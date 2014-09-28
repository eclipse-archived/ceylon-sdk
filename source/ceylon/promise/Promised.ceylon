"An object that provides a [[promise]]."
by("Julien Viet")
shared interface Promised<out Value> {
    
    "The promise."
    shared formal Promise<Value> promise;
    
}
