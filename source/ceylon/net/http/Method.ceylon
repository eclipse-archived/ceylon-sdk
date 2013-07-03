"Http request method"
by ("Jean-Charles Roger", "Matej Lazar")
shared interface Method {
    shared default actual Boolean equals(Object that) {
        if (this == that) {
            return true;
        } else {
            if (is Method that) {
                return that.string.equals(string);
            } else {
                return false;
            }
        }
    }
}

shared abstract class AbstractMethod()
    of options | get | head | post | put | delete | trace | connect 
    satisfies Method {

    shared actual Boolean equals(Object that) => super.equals(that); 
}

shared object options extends AbstractMethod() {
    shared actual String string = "OPTIONS";
}

shared object get extends AbstractMethod() {
    shared actual String string = "GET";
}

shared object head extends AbstractMethod() {
    shared actual String string = "HEAD";
}

shared object post extends AbstractMethod() {
    shared actual String string = "POST";
}

shared object put extends AbstractMethod() {
    shared actual String string = "PUT";
}

shared object delete extends AbstractMethod() {
    shared actual String string = "DELETE";
}

shared object trace extends AbstractMethod() {
    shared actual String string = "TRACE";
}

shared object connect extends AbstractMethod() {
    shared actual String string = "CONNECT";
}

"Parse a method string to Method instance"
shared Method parseMethod(String method) {
    
    if ( method == options.string ) {
        return options;
    } else if ( method == get.string ) {
        return get;
    } else if ( method == head.string ) {
        return head;
    } else if ( method == post.string ) {
        return post;
    } else if ( method == put.string ) {
        return put;
    } else if ( method == delete.string ) {
        return delete;
    } else if ( method == trace.string ) {
        return trace;
    } else if ( method == connect.string ) {
        return connect;
    } else {
        object m satisfies Method {
            shared actual String string = method.uppercased;
            shared actual Boolean equals(Object that) => super.equals(that);
        }
        return m;
    }
}