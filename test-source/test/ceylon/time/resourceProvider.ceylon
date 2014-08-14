import ceylon.time.timezone.parser {
    parseRuleLine,
    parseZoneLine,
    tokenDelimiter
}
import ceylon.collection {
    MutableMap,
    HashMap,
    MutableList,
    ArrayList
}
import ceylon.time.timezone.model {
    Rule,
    ZoneTimeline
}

"Currently the database supported is: http://www.iana.org/time-zones
 
 All resources are located inside the folder ceylon/time and consist of all below files/names,
 also theres a file _version.txt that informs the actual imported database."
[String+] supportedDatabases = ["africa",      "antarctica",   "asia", 
"australasia", "backward",     "etcetera",   
"europe",      "northamerica", "southamerica"];

"This object should load all resources and make them available"
shared object provider {
    
    shared MutableMap<String, MutableList<Rule>> rules = HashMap<String, MutableList<Rule>>();
    shared MutableMap<String, MutableList<ZoneTimeline>> zones = HashMap<String, MutableList<ZoneTimeline>>();
    
    for (database in supportedDatabases) {
        value resource = `module ceylon.time`.resourceByPath("``database``");
        if (exists resource) {
            variable String? lastZoneName = null; 
            for (line in resource.textContent().lines) {
                //Skip comment lines
                if (line.startsWith("#")) { continue; }
                
                //Remove comments from line
                value fixedLine = removeCommentsAndTrim(line);
                
                //Skip blank lines
                if( fixedLine == "") { continue; }
                
                value tokens = fixedLine.split(tokenDelimiter);
                value token = tokens.iterator();
                
                value first = token.next();
                switch (first)
                case (is String) {
                    switch (first)
                    case ("Rule") {
                        lastZoneName = null;
                        [String, Rule] rule = parseRuleLine(token);
                        
                        variable value rulesList = rules.get(rule[0]);
                        if(exists list = rulesList) {
                            list.add(rule[1]);
                        } else {
                            value newList = ArrayList<Rule>();
                            newList.add(rule[1]);
                            rules.put(rule[0], newList);
                        }
                        
                    }
                    case ("Zone") {
                        value zoneTime = parseZoneLine(token);
                        addZone(zoneTime, zones);
                        lastZoneName = zoneTime[0];
                    }
                    case ("Link") {
                        lastZoneName = null;
                        print("Link: ``fixedLine``");
                    }
                    else {
                        if(exists name = lastZoneName) {
                            //print("fromZone: '``fixedLine``'");
                            value zoneTime = parseZoneLine(fixedLine.split(tokenDelimiter).iterator(), name);
                            addZone(zoneTime, zones);
                        }
                    }
                }
                case (is Finished) {
                }
            }
        }
    }
}

void addZone([String, ZoneTimeline] zoneTime, MutableMap<String, MutableList<ZoneTimeline>> zones) {
    variable value zonesList = zones.get(zoneTime[0]);
    if(exists list = zonesList) {
        list.add(zoneTime[1]);
    } else {
        value newList = ArrayList<ZoneTimeline>();
        newList.add(zoneTime[1]);
        zones.put(zoneTime[0], newList);
    }
}

String removeCommentsAndTrim(String line){
    variable value fixedLine = line;
    if( exists index = fixedLine.firstOccurrence('#') ) {
        fixedLine = line.spanTo(index -1); 
    }
    return fixedLine.trimmed;
}