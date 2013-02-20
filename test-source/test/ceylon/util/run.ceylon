import ceylon.test {suite}

doc "Run the module `test.ceylon.util`."
void run() {
    suite("ceylon.util",
          "Log test" -> testLog);
}