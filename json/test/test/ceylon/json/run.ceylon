import ceylon.json { parse }

doc "Run the module `test.ceylon.json`."
void run() {
    print(parse("{}"));
    print(parse("{\"foo\": \"bar\"}"));
    print(parse("{\"s\": \"bar\", \"t\": true, \"f\": false, \"n\": null}"));
    print(parse("{\"i\": 12, \"f\": 12.34, \"ie\": 12e10, \"fe\": 12.34e10}"));
    print(parse("{\"i\": -12, \"f\": -12.34, \"ie\": -12e10, \"fe\": -12.34e10}"));
    print(parse("{\"ie\": 12E10, \"fe\": 12.34E10}"));
    print(parse("{\"ie\": 12e+10, \"fe\": 12.34e+10}"));
    print(parse("{\"ie\": 12e-10, \"fe\": 12.34e-10}"));
    print(parse("{\"s\": \"escapes \\\\ \\\" \\/ \\" + "b \\" + "f \\" + "t \\" + "n \\" + "r \\u0053 \\u3042\"}"));
    print(parse("{\"obj\": {\"gee\": \"bar\"}}"));
    print(parse("{\"arr\": [1, 2, 3]}"));
    print(parse("{\"svn_url\":\"https://github.com/ceylon/ceylon-compiler\",\"has_downloads\":true,\"homepage\":\"http://ceylon-lang.org\",\"mirror_url\":null,\"has_issues\":true,\"updated_at\":\"2012-04-11T10:20:59Z\",\"forks\":22,\"clone_url\":\"https://github.com/ceylon/ceylon-compiler.git\",\"ssh_url\":\"git@github.com:ceylon/ceylon-compiler.git\",\"html_url\":\"https://github.com/ceylon/ceylon-compiler\",\"language\":\"Java\",\"organization\":{\"gravatar_id\":\"a38479e9dc888f68fb6911d4ce05d7cc\",\"url\":\"https://api.github.com/users/ceylon\",\"avatar_url\":\"https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png\",\"id\":579261,\"login\":\"ceylon\"},\"has_wiki\":true,\"fork\":false,\"git_url\":\"git://github.com/ceylon/ceylon-compiler.git\",\"created_at\":\"2011-01-24T14:25:50Z\",\"url\":\"https://api.github.com/repos/ceylon/ceylon-compiler\",\"size\":2413,\"private\":false,\"open_issues\":81,\"description\":\"Ceylon compiler (ceylonc: Java backend), Ceylon documentation generator (ceylond) and Ceylon ant tasks.\",\"owner\":{\"gravatar_id\":\"a38479e9dc888f68fb6911d4ce05d7cc\",\"url\":\"https://api.github.com/users/ceylon\",\"avatar_url\":\"https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png\",\"id\":579261,\"login\":\"ceylon\"},\"name\":\"ceylon-compiler\",\"watchers\":74,\"pushed_at\":\"2012-04-11T07:43:33Z\",\"id\":1287859}"));
}