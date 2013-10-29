import ceylon.html.serializer {
    consoleSerializer
}


class User(name) {
    shared String name;
}

class UserRow(User user) satisfies Snippet<Tr> {

    content = Tr {
        Td(user.hash.string),
        Td(user.name)
    };

}


[User+] users = [User {
    name = "Daniel Rochetti";
}, User {
    name = "John Doe";
}];

Html page = Html {
    doctype = html5;
    Head {
        title = "Page Title";
        CharsetMeta("utf-8"),
        CssLink("http://fonts.googleapis.com/css?family=Open+Sans")
    };
    Body {
        Div {
            classNames = ["wrapper", "container"];
            nonstandardAttributes = [
                "ng-controller"->"UsersController"
            ];
            P(
                users.empty then
                    "No users..."
                else
                    "There are ``users.size`` users!"
            ),
            Table {
                id = "users";
                data = ["total"->users.size];
                header = {
                    Th("#"),
                    Th("Name")
                };
                for (i -> user in users.indexed)
                    UserRow(user)
            },
            users.size > 1 then
                Div {
                    "``users.size`` records";
                    classNames = "pagination";
                }
        }
    };
};

"Run the module `ceylon.html`."
void run() {
    consoleSerializer.serialize(page);
}