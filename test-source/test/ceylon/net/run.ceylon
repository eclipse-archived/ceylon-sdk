import ceylon.test {suite}

void run() {
    suite("ceylon.net",
        "URI Decomposition test" -> testDecomposition,
        "URI Composition test" -> testComposition,
        "URI Invalid port" -> testInvalidPort,
        "URI Invalid port2" -> testInvalidPort2,
        "URI Decoding test"-> testDecoding,
        "HTTP testGet" -> testGet,
        "HTTP testGetUtf8" -> testGetUtf8,
        "HTTP testGetUtf8 2" -> testGetUtf8_2,
        "HTTP testGetChunked" -> testGetChunked);
}