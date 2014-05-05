import ceylon.test { ... }

shared class TestLoggingListener(colorWhite, colorGreen, colorRed) extends SimpleLoggingListener() {
    
    String? colorWhite;
    String? colorGreen;
    String? colorRed;
    
    shared actual void writeBannerSuccess(TestRunResult result) {
        if (exists colorGreen) {
            process.write(colorGreen);
        }
        process.write(banner("TESTS SUCCESS"));
        if (exists colorWhite) {
            process.write(colorWhite);
        }
        process.writeLine();
    }
    
    shared actual void writeBannerFailed(TestRunResult result) {
        if (exists colorRed) {
            process.write(colorRed);
        }
        process.write(banner("TESTS FAILED !"));
        if (exists colorWhite) {
            process.write(colorWhite);
        }
        process.writeLine();
    }
}
