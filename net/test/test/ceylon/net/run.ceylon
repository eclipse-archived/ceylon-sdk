import com.redhat.ceylon.sdk.test {Suite}

class NetSuite() extends Suite("ceylon.net") {
    shared actual Iterable<Entry<String, Callable<Void>>> suite = {
        "Decomposition test" -> testDecomposition,
        "Composition test" -> testComposition,
        "Invalid port" -> testInvalidPort,
        "Invalid port2" -> testInvalidPort2,
        "Decoding test"-> testDecoding,
        "testGet" -> testGET, 
        "testGetJson" -> testGETJSON
    };
}

void run() {
    NetSuite().run();
}