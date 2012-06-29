import com.redhat.ceylon.sdk.test {Suite}

class NetSuite() extends Suite("ceylon.net") {
    shared actual Iterable<Entry<String, Callable<Void>>> suite = {
        "URI Decomposition test" -> testDecomposition,
        "URI Composition test" -> testComposition,
        "URI Invalid port" -> testInvalidPort,
        "URI Invalid port2" -> testInvalidPort2,
        "URI Decoding test"-> testDecoding,
        "HTTP testGet" -> testGET
    };
}

void run() {
    NetSuite().run();
}