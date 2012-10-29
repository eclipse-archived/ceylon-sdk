doc "Contains everything required to parse and serialise JSON data.
     
     Sample usage for parsing and accessing JSON:
     
         String getAuthor(String json){
             value parsedJson = parse(json);
             if(is Object parsedJson){
                 if(is String author = parsedJson.get(\"author\")){
                     return author;
                 }
             }
             throw Exception(\"Invalid JSON data\");
         }
     
     Sample usage for generating JSON data:
     
         String getJSON(){
             value json = Object{
                 \"name\" -> \"Introduction to Ceylon\",
                 \"authors\" -> Array{
                     \"Stef Epardaud\",
                     \"Emmanuel Bernard\"
                 }
             };
             return json.string;
         }
     
     "
by "Stéphane Épardaud"
license "Apache Software License"
module ceylon.json '0.4' {
    import ceylon.collection '0.4';
}
