
import ceylon.test { suite }

shared void run() {
    suite("ceylon.interop.java",
        "String tests" -> stringTests,
        "Collection tests" -> collectionTests,
        "Class tests" -> classTests);
}
