"Use `key` to match bareKeys or `val` for tokens for integers, floats, dates, and
 booleans. Either will work for all other tokens."
shared class LexerMode of key | val {
    shared new key {}
    shared new val {}
}
