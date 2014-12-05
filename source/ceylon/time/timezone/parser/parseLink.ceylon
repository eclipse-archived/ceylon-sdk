import ceylon.time.timezone.model {
    RealId,
    AliasId,
    Link
}

shared Link parseLinkLine(String line) {
    value token = line.split(tokenDelimiter).iterator();
    
    assert(is String link = token.next(), link == "Link");
    
    assert (is RealId realId = token.next());
    assert (is AliasId aliasId = token.next());
    return [realId, aliasId];
}
