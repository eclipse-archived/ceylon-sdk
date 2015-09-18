import java.lang {
    System {
        getenv
    }
}

shared object environment
        satisfies Iterable<String->String> {
    iterator() => object 
            satisfies Iterator<String->String> {   
        value env = getenv().entrySet().iterator();
        next() => if (env.hasNext()) 
                then let (entry = env.next())
                    entry.key.string -> entry.\ivalue.string 
                else finished;
    };   
}





