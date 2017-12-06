/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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