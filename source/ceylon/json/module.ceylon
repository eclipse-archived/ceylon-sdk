"""Contains everything required to parse and serialise JSON data.
   
   Sample usage for parsing and accessing JSON:
   
       String getAuthor(String json){
           value parsedJson = parse(json);
           if(is String author = parsedJson.get("author")){
               return author;
           }
           throw Exception("Invalid JSON data");
       }
   
   Or if you're really sure that you should have a String value:
   
       String getAuthor(String json){
           value parsedJson = parse(json);
           return parsedJson.getString("author")){
       }
   
   You can iterate Json objects too::
   
       {String*} getModules(String json){
           value parsedJson = parse(json);
           if(is Array modules = parsedJson.get("modules")){
               return { for (mod in modules) 
                          if(is Object mod, is String name = mod.get("name")) 
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
module ceylon.json "1.0.2" {
    shared import ceylon.collection "1.0.0";
}
