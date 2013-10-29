import ceylon.html {
    Html,
    html5,
    Head,
    Meta,
    Body,
    Div,
    Script,
    CharsetMeta,
    BlockElement
}

"A simple HTML5 boilerplate layout."
shared class BaseLayout(title, body = Div()) satisfies Layout {

    "The page title."
    shared String title;

    "The page meta description."
    shared default String description = "";

    shared default {Script*} headScripts = {};

    //shared default {String*} stylesheets = {};

    "The page body _block_."
    shared BlockElement|Null|{BlockElement*} body;

    shared default {Script*} bodyScripts = {};

    shared default BlockElement|Null|{BlockElement*} footer => {};

    html => Html {

        doctype = html5;

        Head {
            title = title;
            headChildren = concatenate(
                {
                    CharsetMeta(),
                    Meta("description", description)
                },
                //stylesheets,
                headScripts
            );
        };

        Body {
            body,
            Div {
                id = "footer";
                footer
            },
            bodyScripts
        };

    };

}
