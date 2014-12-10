import ceylon.interop.java {
    javaLongArray
}

import java.lang {
    LongArray
}

alias Words => LongArray;

Words newWords(Integer size, Integer initialValue = 0) {
    return javaLongArray(arrayOfSize(size, initialValue));
}

Words wordsOfOne(Integer word) {
    value result = newWords(1);
    result.set(0, word);
    return result;
}

Words consWord(Integer other, Words words) {
    value result = newWords(words.size + 1);
    result.set(0, other);
    copyWords(words, result, 0, 1);
    return result;
}

void copyWords(Words source,
        Words destination,
       Integer sourcePosition = 0,
       Integer destinationPosition = 0,
       Integer length = source.size - sourcePosition) {
    source.copyTo(destination, sourcePosition, destinationPosition, length);   
}

Words skipWords(Words words, Integer length) {
    assert (length <= words.size);
    if (length == words.size) {
        return newWords(0);
    }
    else {
        value result = newWords(words.size - length);
        copyWords(words, result, length);
        return result;
    }
}

Integer? lastIndexWhere(Words words, Boolean selecting(Integer element)) {
    variable value index = words.size;
    while (index>0) {
        index--;
        value element=words.get(index); 
        if (selecting(element)) {
            return index;
        }
    }
    return null;
}

Boolean wordsEqual(Words first, Words second) {    
    if (first.size != second.size) {
        return false;
    }
    for (i in 0:first.size) {
        if (first.get(i) != second.get(i)) {
            return false;
        }
    }
    return true;
}
