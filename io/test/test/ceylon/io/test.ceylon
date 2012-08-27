import com.redhat.ceylon.sdk.test { Suite }

class IoSuite() extends Suite("ceylon.io") {
    shared actual Iterable<String->Void()> suite = {
        "Byte Buffer test" -> testByteBuffer,
        "Byte Buffer resize test" -> testByteBufferResize,
        "Character Buffer test" -> testCharacterBuffer,
        "UTF8 decoder test" -> testUTF8Decoder,
        "UTF16 decoder test" -> testUTF16Decoder,
        "ASCII encoder test" -> testASCIIEncoder,
        "ASCII full encoder test" -> testFullASCIIEncoder
    };
}

void run() {
    IoSuite().run();
}