import ceylon.test {
    ...
}
import ceylon.test.engine {
    DefaultLoggingListener
}

class TestLoggingListener(resetColor, colorGreen, colorRed) extends DefaultLoggingListener() {
    
    String? resetColor;
    String? colorGreen;
    String? colorRed;
    Boolean useColors = !((resetColor?.empty else true) || (colorGreen?.empty else true) || (colorRed?.empty else true));
    
    shared actual void writeBannerSuccess(TestRunResult result) {
        if (useColors) {
            assert (exists colorGreen);
            process.write(colorGreen);
        }
        process.write(banner("TESTS SUCCESS"));
        if (useColors) {
            assert (exists resetColor);
            process.write(resetColor);
        }
        process.writeLine();
    }
    
    shared actual void writeBannerFailed(TestRunResult result) {
        if (useColors) {
            assert (exists colorRed);
            process.write(colorRed);
        }
        process.write(banner("TESTS FAILED !"));
        if (useColors) {
            assert (exists resetColor);
            process.write(resetColor);
        }
        process.writeLine();
    }
    
}