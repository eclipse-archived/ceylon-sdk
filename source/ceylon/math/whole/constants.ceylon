"A `Whole` instance representing zero."
shared Whole zero = Whole.OfWords(0, wordsOfSize(0));

"A `Whole` instance representing one."
shared Whole one = Whole.OfWords(1, wordsOfOne(1));

"A `Whole` instance representing negative one."
Whole negativeOne = Whole.OfWords(-1, wordsOfOne(1));

"A `Whole` instance representing two."
shared Whole two = Whole.OfWords(1, wordsOfOne(2));

"A `Whole` instance representing ten."
Whole ten = Whole.OfWords(1, wordsOfOne(10));

// These are used for Whole.offset, so integerAddressableSize is irrelevant
Whole integerMax = wholeNumber(runtime.maxIntegerValue);
Whole integerMin = wholeNumber(runtime.minIntegerValue);

// Word size is 32 for the Java Runtime, 16 for JavaScript
// any factor of integerAddressableSize <= iAS / 2 will work
Integer wordBits = runtime.integerAddressableSize / 2;
//Integer wordSize = 4; // FIXME, using 4 for testing
Integer wordMask = 2 ^ wordBits - 1;
Integer wordRadix = 2 ^ wordBits;

// FIXME, mixing shift & subtraction prob won't work on JS:
Integer maxAddressableInteger = 1.leftLogicalShift(runtime.integerAddressableSize-1)-1;
Integer minAddressableInteger = 1.leftLogicalShift(runtime.integerAddressableSize-1);

MutableWhole mutableZero() => MutableWhole.OfWords(0, wordsOfSize(0));
MutableWhole mutableOne() => MutableWhole.OfWords(1, wordsOfOne(1));
MutableWhole mutableNegativeOne() => MutableWhole.OfWords(-1, wordsOfOne(1));