""
shared interface Snippet<out Result>
        given Result satisfies Node {

    shared formal Result|Iterable<Result> content;

}