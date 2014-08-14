import ceylon.time.timezone.model {
	RealId,
	AliasId,
	Link
}

shared Link parseLinkLine(Iterator<String> token) {
	assert (is RealId realId = token.next());
	assert (is AliasId aliasId = token.next());
	return [realId, aliasId];
}