"""Contains everything required to parse and serialise JSON 
   data.
   
   Sample usage for parsing and accessing JSON:
   
       String getAuthor(String json){
           value parsedJson = parse(json);
           "author must be a string"
           assert(is String author = parsedJson["author"]);
           return author;
       }
   
   Alternatively, this variation will result in an 
   [[InvalidTypeException]] instead of an [[AssertionError]]
   if the input JSON data doesn't have the expected format:
   
       String getAuthor(String json){
           value parsedJson = parse(json);
           return parsedJson.getString("author");
       }
   
   You can iterate JSON objects too:
   
       {String*} getModules(String json){
           value parsedJson = parse(json);
           if(is Array modules = parsedJson.get("modules")){
               return { for (mod in modules) 
                          if(is Object mod, 
                             is String name = mod.get("name")) 
                            name 
                      };
           }
           throw Exception("Invalid JSON data");
       }
   
   Sample usage for generating JSON data:
   
       String getJSON(){
           value json = Object {
               "name" -> "Introduction to Ceylon",
               "authors" -> Array {
                   "Stef Epardaud",
                   "Emmanuel Bernard"
               }
           };
           return json.string;
       }
 """
by("Stéphane Épardaud")
license("Apache Software License")
module ceylon.json "1.1.0" {
    shared import ceylon.collection "1.1.0";
}
