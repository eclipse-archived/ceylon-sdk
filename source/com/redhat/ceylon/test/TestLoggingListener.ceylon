import ceylon.test { ... }

shared class TestLoggingListener(colorWhite, colorGreen, colorRed) extends SimpleLoggingListener() {

    String? colorWhite;
    String? colorGreen;
    String? colorRed;

    shared actual void writeBannerSuccess(TestRunResult result) {
        if(exists colorGreen) {
            process.write(colorGreen);
        }
        super.writeBannerSuccess(result);
        if(exists colorWhite) {
            process.write(colorWhite);
        }
    }

    shared actual void writeBannerFailed(TestRunResult result) {
        if(exists colorRed) {
            process.write(colorRed);
        }
        super.writeBannerFailed(result);
        if(exists colorWhite) {
            process.write(colorWhite);
        }
    }

}