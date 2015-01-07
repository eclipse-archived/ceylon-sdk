import ceylon.time.timezone.model {
    RealName,
    AliasName,
    Link
}

shared Link parseLinkLine(String line) {
    value token = line.split(tokenDelimiter).iterator();
    
    assert(is String link = token.next(), link == "Link");
    
    assert (is RealName realId = token.next());
    assert (is AliasName aliasId = token.next());
    return [realId, aliasId];
}
