import java.lang {
    LongArray
}

// LongArray
alias Words => LongArray;

Words wordsOfSize(Integer size)
    => LongArray(size);

Integer getw(Words words, Integer index)
    => WordsUtils.get(words, index);

void setw(Words words, Integer index, Integer word) {
    WordsUtils.set(words, index, word);
}

Integer sizew(Words words)
    => words.size;

void copyWords(
        Words source,
        Words destination,
        Integer sourcePosition = 0,
        Integer destinationPosition = 0,
        Integer length = sizew(source) - sourcePosition) {
    source.copyTo(destination, sourcePosition, destinationPosition, length);
}

Words clonew(Words source) => source.clone();

// Array<Object>
//shared alias Words => Array<Object>;
//Words wordsOfSize(Integer size)
//    => arrayOfSize<Object>(size, 0);
//
//Integer getw(Words words, Integer index) {
//    assert (is Integer result = words.getFromFirst(index));
//    return result;
//}
//
//void setw(Words words, Integer index, Integer word) {
//    words.set(index, word);
//}
//
//Integer sizew(Words words)
//    => words.size;
//
//void copyWords(
//        Words source,
//        Words destination,
//        Integer sourcePosition = 0,
//        Integer destinationPosition = 0,
//        Integer length = sizew(source) - sourcePosition) {
//    source.copyTo(destination, sourcePosition, destinationPosition, length);
//}

// Array<Integer>
//shared alias Words => Array<Integer>;
//
//Words wordsOfSize(Integer size)
//    => arrayOfSize<Integer>(size, 0);
//
//Integer getw(Words words, Integer index) {
//    assert (is Integer result = words.getFromFirst(index));
//    return result;
//}
//
//void setw(Words words, Integer index, Integer word) {
//    words.set(index, word);
//}
//
//Integer sizew(Words words)
//    => words.size;
//
//void copyWords(
//        Words source,
//        Words destination,
//        Integer sourcePosition = 0,
//        Integer destinationPosition = 0,
//        Integer length = sizew(source) - sourcePosition) {
//    source.copyTo(destination, sourcePosition, destinationPosition, length);
//}

// JArrayList<Integer>
//shared alias Words => JArrayList<Integer>;
//
//Words wordsOfSize(Integer size) {
//    value array = JArrayList<Integer>(size);
//    for (_ in 0:size) {
//        array.add(0);
//    }
//    return array;
//}
//
//Integer getw(Words words, Integer index)
//    => words.get(index);
//
//void setw(Words words, Integer index, Integer word) {
//    words.set(index, word);
//}
//
//Integer sizew(Words words)
//    => words.size();
//
//void copyWords(Words source,
//        Words destination,
//       Integer sourcePosition = 0,
//       Integer destinationPosition = 0,
//       Integer length = sizew(source) - sourcePosition) {
//
//    for (i in 0:length) {
//        value sp = sourcePosition + i;
//        value dp = destinationPosition + i;
//        setw(destination, dp, getw(source, sp));
//    }
//}

// Common
Words wordsOfOne(Integer word) {
    value result = wordsOfSize(1);
    setw(result, 0, word);
    return result;
}

Words copyAppend(Integer wordsSize, Words words, Integer other) {
    value result = wordsOfSize(wordsSize + 1);
    copyWords(words, result, 0, 0, wordsSize);
    setw(result, wordsSize, other);
    return result;
}

Boolean wordsEqual(Integer firstSize, Words first,
                   Integer secondSize, Words second) {
    if (firstSize != secondSize) {
        return false;
    } else if (first === second) {
        return true;
    } else {
        for (i in 0:firstSize) {
            if (getw(first, i) != getw(second, i)) {
                return false;
            }
        }
        return true;
    }
}
