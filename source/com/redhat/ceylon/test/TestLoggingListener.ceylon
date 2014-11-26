import ceylon.test {
    ...
}
import ceylon.test.core {
    DefaultLoggingListener
}

shared class TestLoggingListener(resetColor, colorGreen, colorRed) extends DefaultLoggingListener() {
    
    String? resetColor;
    String? colorGreen;
    String? colorRed;
    
    shared actual void writeBannerSuccess(TestRunResult result) {
        if (exists colorGreen) {
            process.write(colorGreen);
        }
        process.write(banner("TESTS SUCCESS"));
        if (exists resetColor) {
            process.write(resetColor);
        }
        process.writeLine();
    }
    
    shared actual void writeBannerFailed(TestRunResult result) {
        if (exists colorRed) {
            process.write(colorRed);
        }
        process.write(banner("TESTS FAILED !"));
        if (exists resetColor) {
            process.write(resetColor);
        }
        process.writeLine();
    }
}
