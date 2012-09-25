import ceylon.json { ... }

void testUsage(){
    value json = parse("{\"svn_url\":\"https://github.com/ceylon/ceylon-compiler\",\"has_downloads\":true,\"homepage\":\"http://ceylon-lang.org\",\"mirror_url\":null,\"has_issues\":true,\"updated_at\":\"2012-04-11T10:20:59Z\",\"forks\":22,\"clone_url\":\"https://github.com/ceylon/ceylon-compiler.git\",\"ssh_url\":\"git@github.com:ceylon/ceylon-compiler.git\",\"html_url\":\"https://github.com/ceylon/ceylon-compiler\",\"language\":\"Java\",\"organization\":{\"gravatar_id\":\"a38479e9dc888f68fb6911d4ce05d7cc\",\"url\":\"https://api.github.com/users/ceylon\",\"avatar_url\":\"https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png\",\"id\":579261,\"login\":\"ceylon\"},\"has_wiki\":true,\"fork\":false,\"git_url\":\"git://github.com/ceylon/ceylon-compiler.git\",\"created_at\":\"2011-01-24T14:25:50Z\",\"url\":\"https://api.github.com/repos/ceylon/ceylon-compiler\",\"size\":2413,\"private\":false,\"open_issues\":81,\"description\":\"Ceylon compiler (ceylonc: Java backend), Ceylon documentation generator (ceylond) and Ceylon ant tasks.\",\"owner\":{\"gravatar_id\":\"a38479e9dc888f68fb6911d4ce05d7cc\",\"url\":\"https://api.github.com/users/ceylon\",\"avatar_url\":\"https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png\",\"id\":579261,\"login\":\"ceylon\"},\"name\":\"ceylon-compiler\",\"watchers\":74,\"pushed_at\":\"2012-04-11T07:43:33Z\",\"id\":1287859}");
    
    for(key->item in json.sort((Entry<String,String|Boolean|Integer|Float|Object|Array|NullInstance> x, Entry<String,String|Boolean|Integer|Float|Object|Array|NullInstance> y) x.key.compare(y.key))){
        print("" key " -> " item "");
    }
    
    if(json.getInteger("open_issues") > 0){
        print("Has issues");
    }

    if(exists url = json.getObjectOrNull("organization")?.getString("url")){
        print("Has url " url "");
    }
    
    value results = parse("
{\"results\" : [
 {
  \"module\": \"ceylon.collection\",
  \"versions\": [
   \"0.3.0\", 
   \"0.3.3\" 
  ],
  \"authors\": [
   \"Stéphane Épardaud\" 
  ],
  \"doc\": \"A module for collections\",
  \"license\": \"Apache Software License\"
 },
 {
  \"module\": \"ceylon.io\",
  \"versions\": [
   \"0.3.0\", 
   \"0.3.3\" 
  ],
  \"authors\": [
   \"Stéphane Épardaud\" 
  ],
  \"doc\": \"A module for io\",
  \"license\": \"Apache Software License\"
 }
]}
");
    for(mod in results.getArray("results").objects){
        print("Module: " mod.getString("module") "");
        for(version in mod.getArray("versions").strings){
            print(" Version: " version "");
        }
    }
}