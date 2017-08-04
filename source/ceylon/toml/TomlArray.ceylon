import ceylon.collection {
    MutableList, ArrayList
}

"A TOML Array."
shared class TomlArray satisfies MutableList<TomlValue> {
    ArrayList<TomlValue> delegate;

    "Create a new [[TomlArray]] containing the given [[elements]]."
    shared new ({TomlValue*} elements = []) {
        delegate = ArrayList { *elements };
    }

    new create(ArrayList<TomlValue> delegate) {
        this.delegate = delegate;
    }

    shared actual TomlArray clone()
        =>  create(delegate.clone());

    lastIndex => delegate.lastIndex;
    set(Integer index, TomlValue element) => delegate.set(index, element);
    add(TomlValue element) => delegate.add(element);
    getFromFirst(Integer index) => delegate.getFromFirst(index);
    insert(Integer index, TomlValue element) => delegate.insert(index, element);
    delete(Integer index) => delegate.delete(index);

    iterator() => delegate.iterator();
    clear() => clear();
    equals(Object other) => delegate.equals(other);
    hash => delegate.hash;
}
