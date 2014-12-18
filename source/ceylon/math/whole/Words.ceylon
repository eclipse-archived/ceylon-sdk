import java.lang {
    LongArray
}
import ceylon.interop.java {
    javaLongArray
}
import java.util {
    JArrayList=ArrayList
}

// LongArray
alias Words => LongArray;

Words wordsOfSize(Integer size)
    => WholeJava.longArrayOfSize(size);

Integer getw(Words words, Integer index)
    => WholeJava.get(words, index);

void setw(Words words, Integer index, Integer word) {
    WholeJava.set(words, index, word);
}

Integer sizew(Words words)
    => words.size;

// Array<Object>
//alias Words => Array<Object>;
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

// Array<Integer>
//alias Words => Array<Integer>;
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

// JArrayList<Integer>
//alias Words => JArrayList<Integer>;
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

// Common
Words wordsOfOne(Integer word) {
    value result = wordsOfSize(1);
    setw(result, 0, word);
    return result;
}

Words copyAppend(Integer wordsSize, Words words, Integer other) {
    value result = wordsOfSize(wordsSize + 1);
    copyWords(words, result);
    setw(result, wordsSize, other);
    return result;
}

void copyWords(Words source,
        Words destination,
       Integer sourcePosition = 0,
       Integer destinationPosition = 0,
       Integer length = sizew(source) - sourcePosition) {
    
    for (i in 0:length) {
        value sp = sourcePosition + i;
        value dp = destinationPosition + i;
        setw(destination, dp, getw(source, sp));
    }
}

Boolean wordsEqual(Integer firstSize, Words first,
                   Integer secondSize, Words second) {
    if (firstSize != secondSize) {
        return false;
    }
    for (i in 0:firstSize) {
        if (getw(first, i) != getw(second, i)) {
            return false;
        }
    }
    return true;
}
