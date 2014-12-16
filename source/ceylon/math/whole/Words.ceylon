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
//alias Words => LongArray;
//
//Words newWords(Integer size, Integer initialValue = 0)
//    => javaLongArray(arrayOfSize(size, initialValue));
//
//Integer get(Words words, Integer index)
//    => words.get(index);
//
//Integer size(Words words)
//    => words.size;

// Array<Object>
alias Words => Array<Object>;
Words newWords(Integer size, Integer initialValue = 0)
    => arrayOfSize<Object>(size, initialValue);

Integer get(Words words, Integer index) {
    assert (is Integer result = words.getFromFirst(index));
    return result;
}

Integer size(Words words)
    => words.size;

// Array<Integer>
//alias Words => Array<Integer>;
//
//Words newWords(Integer size, Integer initialValue = 0)
//    => arrayOfSize<Integer>(size, initialValue);
//
//Integer get(Words words, Integer index) {
//    assert (is Integer result = words.getFromFirst(index));
//    return result;
//}
//
//Integer size(Words words)
//    => words.size;

// JArrayList<Integer>
//alias Words => JArrayList<Integer>;
//
//Words newWords(Integer size, Integer initialValue = 0) {
//    value array = JArrayList<Integer>(size);
//    for (_ in 0:size) {
//        array.add(initialValue);
//    }
//    return array;
//}
//
//Integer get(Words words, Integer index)
//    => words.get(index);
//
//Integer size(Words words)
//    => words.size();

// Common
Words wordsOfOne(Integer word) {
    value result = newWords(1);
    set(result, 0, word);
    return result;
}

Words prependWord(Integer other, Words words) {
    value result = newWords(size(words) + 1);
    set(result, 0, other);
    copyWords(words, result, 0, 1);
    return result;
}

void copyWords(Words source,
        Words destination,
       Integer sourcePosition = 0,
       Integer destinationPosition = 0,
       Integer length = size(source) - sourcePosition) {
    
    for (i in 0:length) {
        value sp = sourcePosition + i;
        value dp = destinationPosition + i;
        set(destination, dp, get(source, sp));
    }
}

Words skipWords(Words words, Integer length) {
    assert (length <= size(words));
    if (length == words.size) {
        return newWords(0);
    }
    else {
        value result = newWords(size(words) - length);
        copyWords(words, result, length);
        return result;
    }
}

Boolean wordsEqual(Words first, Words second) {    
    if (size(first) != size(second)) {
        return false;
    }
    for (i in 0:size(first)) {
        if (get(first, i) != get(second, i)) {
            return false;
        }
    }
    return true;
}

void set(Words words, Integer index, Integer word) {
    words.set(index, word);
}
