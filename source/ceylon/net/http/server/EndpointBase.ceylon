import ceylon.net.http { Method }
abstract shared class EndpointBase(path, acceptMethod) {
    shared Matcher path;

    shared {Method*} acceptMethod;

}
