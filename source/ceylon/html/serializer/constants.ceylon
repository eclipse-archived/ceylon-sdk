import ceylon.collection {
    unmodifiableSet,
    HashSet
}

Range<Character> asciiCharacterRange = ' '..'~';

// can't use Range<Character> since these are
// not all valid code points (e.g. #37F)
// http://www.w3.org/TR/REC-xml/#NT-NameChar
[Range<Integer>+] xmlNameStartCharRanges = [
        ':'.integer..':'.integer,
        '_'.integer..'_'.integer,
        'A'.integer..'Z'.integer,
        'a'.integer..'z'.integer,
        #C0..#D6,
        #D8..#F6,
        #F8..#2FF,
        #370..#37D,
        #37F..#1FFF,
        #200C..#200D,
        #2070..#218F,
        #2C00..#2FEF,
        #3001..#D7FF,
        #F900..#FDCF,
        #FDF0..#FFFD,
        #10000..#EFFFF];

// http://www.w3.org/TR/REC-xml/#NT-NameChar
[Range<Integer>+] xmlNameCharRanges = [
        '-'.integer..'-'.integer,
        '.'.integer..'.'.integer,
        '0'.integer..'9'.integer,
        #B7..#B7,
        #300..#36F,
        #203F..#2040,
        *xmlNameStartCharRanges];

// http://www.w3.org/TR/html5/syntax.html#elements-0
Set<String> voidElements = unmodifiableSet(HashSet {
        "area", "base", "br", "col", "embed", "hr",
        "img", "input", "keygen", "link", "meta",
        "param", "source", "track", "wbr"});

// http://www.w3.org/TR/html5/syntax.html#elements-0
Set<String> rawTextElements = unmodifiableSet(HashSet {
        "script", "style"});

// http://www.w3.org/TR/html5/syntax.html#elements-0
Set<String> escapableRawTextElements = unmodifiableSet(HashSet {
        "textarea", "title"});
