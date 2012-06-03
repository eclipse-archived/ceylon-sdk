import ceylon.fs.internal { allStores=stores }

shared interface Store {
    shared formal Integer totalSpace;
    shared formal Integer availableSpace;
    shared formal Integer usableSpace;
    shared formal Boolean writable;
    shared formal String name;
}

shared Store[] stores = allStores;