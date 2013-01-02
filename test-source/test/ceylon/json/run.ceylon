import ceylon.test { ... }

shared void run(){
    suite("ceylon.collection", 
        "Parse" -> testParse,
        "Print" -> testPrint
    );
}


