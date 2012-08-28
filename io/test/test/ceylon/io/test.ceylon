import com.redhat.ceylon.sdk.test { Suite }

class IoSuite() extends Suite("ceylon.io") {
    shared actual Iterable<String->Void()> suite = {
        "Byte Buffer test" -> testByteBuffer,
        "Byte Buffer resize test" -> testByteBufferResize,
        "Character Buffer test" -> testCharacterBuffer,
        "ASCII encoder test" -> testASCIIEncoder,
        "ASCII full encoder test" -> testFullASCIIEncoder,
        "Latin1 decoder test" -> testLatin1Decoder,
        "Latin1 encoder test" -> testLatin1Encoder,
        "UTF8 decoder test" -> testUTF8Decoder,
        "UTF8 encoder test" -> testUTF8Encoder,
        "UTF16 decoder test" -> testUTF16Decoder,
        "UTF16 encoder test" -> testUTF16Encoder
    };
}

void run() {
    IoSuite().run();
}