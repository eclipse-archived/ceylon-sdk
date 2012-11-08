import com.redhat.ceylon.sdk.test{Suite}

class MathSuite() extends Suite("ceylon.math") {
    shared actual Iterable<String->Void()> suite = {
        "Whole" -> wholeTests,
        "Decimal" -> decimalTests,
        "Float" -> floatTests,
        "Integer" -> intTests
    };
}

shared void run() {
    MathSuite().run();
}