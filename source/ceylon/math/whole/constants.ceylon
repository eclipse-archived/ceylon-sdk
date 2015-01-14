"A `Whole` instance representing zero."
shared Whole zero = WholeImpl.OfWords(0, wordsOfSize(0));

"A `Whole` instance representing one."
shared Whole one = WholeImpl.OfWords(1, wordsOfOne(1));

"A `Whole` instance representing negative one."
Whole negativeOne = WholeImpl.OfWords(-1, wordsOfOne(1));

"A `Whole` instance representing two."
shared Whole two = WholeImpl.OfWords(1, wordsOfOne(2));

"A `Whole` instance representing ten."
Whole ten = WholeImpl.OfWords(1, wordsOfOne(10));

// These are used for Whole.offset, so integerAddressableSize is irrelevant
Whole integerMax = wholeNumber(runtime.maxIntegerValue);
Whole integerMin = wholeNumber(runtime.minIntegerValue);

// Word size is 32 for the Java Runtime, 16 for JavaScript
// any factor of integerAddressableSize <= iAS / 2 will work
Integer wordBits = runtime.integerAddressableSize / 2;
Integer wordMask = 2 ^ wordBits - 1;
Integer wordRadix = 2 ^ wordBits;

Integer minAddressableInteger = 1.leftLogicalShift(runtime.integerAddressableSize-1);
Integer maxAddressableInteger = minAddressableInteger.not;

MutableWhole mutableZero() => MutableWhole.OfWords(0, wordsOfSize(0));
MutableWhole mutableOne() => MutableWhole.OfWords(1, wordsOfOne(1));
MutableWhole mutableNegativeOne() => MutableWhole.OfWords(-1, wordsOfOne(1));