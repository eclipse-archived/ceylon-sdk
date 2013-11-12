
"""It's basically a factory of [[Node]]. Implement this
   interface to create reusable HTML fragments.

   For example a snippet to build a modal dialog, like this:
   ```
   shared class Dialog(String title, Boolean closeable = true,
                Div body, Button* buttons = {})
            satisfies Snippet<Div> {

        content => Div {
            classNames = "modal";
            Aria {
                role = dialog;
            };
            Div {
                classNames = "modal-header";
                H4(title),
                closeable then Button {
                    "&times;";
                    classNames = "close";
                }
            },
            Div {
                classNames = "modal-body";
                body
            },
            Div {
                classNames = "modal-footer";
                buttons
            }
        }
   }
   ```
   """
shared interface Snippet<out Result>
        given Result satisfies Node {

    "Build the snippet content."
    shared formal Result|{Result*}|Null content;

    shared default actual String string {
        if (exists c = content) {
            return c.string;
        }
        return "null result from snippet ``this``";
    }

}
