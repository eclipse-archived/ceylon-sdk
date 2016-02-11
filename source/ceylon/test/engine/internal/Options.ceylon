import ceylon.collection {
    ArrayList
}

class Options {
    
    shared String[] modules;
    shared String[] tests;
    shared String[] tags;
    shared Boolean tap;
    shared Boolean report;
    shared Integer? port;
    shared String? colorReset;
    shared String? colorGreen;
    shared String? colorRed;
    String colorKeyPrefix = "com.redhat.ceylon.common.tool.terminal.color";
    
    shared new parse() {
        value moduleArgs = ArrayList<String>();
        value testArgs = ArrayList<String>();
        value tagArgs = ArrayList<String>();
        variable value prev = "";
        variable value tapArg = false;
        variable value reportArg = false;
        variable Integer? portArg = null;
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
                assert (exists p = parseInteger(arg[7...]));
                portArg = p;
            }
            if (arg == "--tap") {
                tapArg = true;
            }
            if (arg == "--report") {
                reportArg = true;
            }
            
            prev = arg;
        }
        
        modules = moduleArgs.sequence();
        tests = testArgs.sequence();
        tags = tagArgs.sequence();
        tap = tapArg;
        report = reportArg;
        port = portArg;
        colorReset = colorResetArg;
        colorGreen = colorGreenArg;
        colorRed = colorRedArg;
    }
    
}
