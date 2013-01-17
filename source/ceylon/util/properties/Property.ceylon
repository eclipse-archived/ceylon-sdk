shared interface Property {

	shared formal String key();

	shared formal String asString();

	shared formal Integer asInteger();

	shared formal String[] asStringSequence();

	shared formal Property[] allChildItems();

	shared formal Property? childItem(String childKey);

	shared formal Property[] childItems(String childKey);

}