import ceylon.time.timezone.parser {
	parseRuleLine,
	Rule
}
import ceylon.collection {
	MutableMap,
	HashMap,
	MutableList,
	ArrayList
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
	
	for (database in supportedDatabases) {
		value resource = `module ceylon.time`.resourceByPath("``database``");
		if (exists resource) {
			for (line in resource.textContent().lines) {
				//Skip comment lines
				if (line.startsWith("#")) { continue; }
				
				//Remove comments from line
				value fixedLine = removeComments(line);
				
				value tokens = fixedLine.split('\t'.equals);
				value token = tokens.iterator();
				
				value first = token.next();
				
				switch (first)
				case (is String) {
					switch (first)
					case ("Rule") {
						//TODO: Why theres 2 lines without \t at europe file ?? Bug??
						if(tokens.size < 10) {
							print("skip line with wrong number of tokens");
							print(line + " com tokens: ``line.split('\t'.equals).size``");
							print("this occurs inside ``database``");
							continue;
						}
						
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
					}
					case ("Link") {
					}
					else {
					}
				}
				case (is Finished) {
				}
			}
		}
	}
}

String removeComments(String line){
	variable value fixedLine = line;
	if( exists index = fixedLine.firstOccurrence('#') ) {
		fixedLine = line.spanTo(index -1); 
	}
	return fixedLine;
}