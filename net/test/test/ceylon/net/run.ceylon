import com.redhat.ceylon.sdk.test {Suite}

class NetSuite() extends Suite("ceylon.net") {
    shared actual Iterable<String->Void()> suite = {
        "URI Decomposition test" -> testDecomposition,
        "URI Composition test" -> testComposition,
        "URI Invalid port" -> testInvalidPort,
        "URI Invalid port2" -> testInvalidPort2,
        "URI Decoding test"-> testDecoding,
        "HTTP testGet" -> testGet,
        "HTTP testGetUtf8" -> testGetUtf8,
        "HTTP testGetChunked" -> testGetChunked
    };
}

void run() {
    NetSuite().run();
}