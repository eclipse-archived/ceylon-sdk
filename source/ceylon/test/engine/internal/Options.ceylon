/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    ArrayList
}

class Options {
    
    shared String[] modules;
    shared String[] tests;
    shared String[] tags;
    shared Boolean report;
    shared String? reportsDir;
    shared Boolean xmlJUnitReport;
    shared Integer? port;
    shared String? tap;
    shared String? colorReset;
    shared String? colorGreen;
    shared String? colorRed;
    String colorKeyPrefix = "org.eclipse.ceylon.common.tool.terminal.color";
    
    shared new parse() {
        value moduleArgs = ArrayList<String>();
        value testArgs = ArrayList<String>();
        value tagArgs = ArrayList<String>();
        variable value prev = "";
        variable value reportArg = false;
        variable String? reportsDirArg = null;
        variable value xmlJUnitReportArg = false;
        variable Integer? portArg = null;
        variable String? tapArg = null;
        variable String? colorResetArg = process.propertyValue("``colorKeyPrefix``.reset");
        variable String? colorGreenArg = process.propertyValue("``colorKeyPrefix``.green");
        variable String? colorRedArg = process.propertyValue("``colorKeyPrefix``.red");
        
        for (String arg in process.arguments) {
            if (prev == "--module") {
                moduleArgs.add(arg);
            }
            if (prev == "--test") {
                testArgs.add(arg);
            }
            if (prev == "--tag") {
                tagArgs.add(arg);
            }
            if (prev == "--reports-dir") {
                reportsDirArg = arg;
            }
            if (prev == "--``colorKeyPrefix``.reset") {
                colorResetArg = arg;
            }
            if (prev == "--``colorKeyPrefix``.green") {
                colorGreenArg = arg;
            }
            if (prev == "--``colorKeyPrefix``.red") {
                colorRedArg = arg;
            }
            if (arg.startsWith("--port")) {
                assert (is Integer p = Integer.parse(arg[7...]));
                portArg = p;
            }
            if (arg == "--tap") {
                tapArg = "-";
            }
            if (arg.startsWith("--tap=")) {
                tapArg = arg["--tap=".size...];
            }
            if (arg == "--report") {
                reportArg = true;
            }
            if (arg == "--xml-junit-report") {
                xmlJUnitReportArg = true;
            }
            
            prev = arg;
        }
        
        modules = moduleArgs.sequence();
        tests = testArgs.sequence();
        tags = tagArgs.sequence();
        tap = tapArg;
        report = reportArg;
        reportsDir = reportsDirArg;
        xmlJUnitReport = xmlJUnitReportArg;
        port = portArg;
        colorReset = colorResetArg;
        colorGreen = colorGreenArg;
        colorRed = colorRedArg;
    }
    
}
