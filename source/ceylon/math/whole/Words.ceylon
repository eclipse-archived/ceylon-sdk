alias Words => Array<Object>;

Words newWords(Integer size, Integer initialValue = 0) {
    return arrayOfSize<Object>(size, initialValue);
    //value array = ArrayList<Integer>(0);
    //for (i in 0:size) {
    //    array.add(initialValue);
    //}
    //return array;
}

Words wordsOfOne(Integer word) {
    value result = newWords(1);
    result.set(0, word);
    return result;
}

Words consWord(Integer other, Words words) {
    value result = newWords(size(words) + 1);
    result.set(0, other);
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
        destination.set(dp, get(source, sp));
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

Integer? lastIndexWhere(Words words, Boolean selecting(Integer element)) {
    variable value index = size(words);
    while (index>0) {
        index--;
        value element = get(words, index); 
        if (selecting(element)) {
            return index;
        }
    }
    return null;
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

Integer get(Words words, Integer index) {
    assert (is Integer result = words.getFromFirst(index));
    return result;
}

void set(Words words, Integer index, Integer word) {
    words.set(index, word);
}

Integer size(Words words) {
    return words.size;
}
