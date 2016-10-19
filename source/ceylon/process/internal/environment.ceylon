import java.lang {
    System {
        getenv
    }
}

shared object environment
        satisfies Iterable<String->String> {
    iterator()
            => { for (entry in getenv().entrySet())
                 entry.key.string -> entry.\ivalue.string }
            .iterator();
}





