import ceylon.test { suite }

"Run the module `test.ceylon.html`."
shared void run() {
    suite("ceylon-html",
        "Serialization" -> testHtmlSerialization
    );
}