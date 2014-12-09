import java.lang {
    LongArray
}
import ceylon.interop.java {
    javaLongArray
}

class Words {
    LongArray array;

    shared new Words(Integer size, Integer initialValue = 0) {
        array = javaLongArray(arrayOfSize(size, initialValue));
    }

    shared new OfOne(Integer word) {
        array = javaLongArray(arrayOfSize(1, word));
    }

    new Internal(LongArray array) {
        this.array = array;
    }

    shared Words skip(Integer length) {
        assert (length <= size);
        if (skip == size) {
            return Words(0);
        }
        else {
            value newArray = javaLongArray(arrayOfSize(size - length, 0));
            array.copyTo(newArray, length);
            return Internal(newArray);
        }
    }

    shared Words follow(Integer other) {
        value newArray = javaLongArray(arrayOfSize(size + 1, 0));
        newArray.set(0, other);
        array.copyTo(newArray, 0, 1);
        return Internal(newArray);
    }

    shared Integer size => array.size;

    shared void set(Integer index, Integer  element) {
        array.set(index, element);  
    }

    shared Boolean empty => size == 0;

    shared Integer first => getFromFirst(0);

    shared Integer last => getFromLast(0);

    shared Integer get(Integer index) => getFromFirst(index);

    shared Integer getFromLast(Integer index) => getFromFirst(size - index - 1); 

    shared Integer getFromFirst(Integer index) {
        return array.get(index);
    }

    shared Integer? lastIndex => size > 0 then size-1;

    shared actual Integer hash => array.hash;

    shared actual Boolean equals(Object that) {
        if (is Words that) {
            if (size != that.size) {
                return false;
            }
            for (i in 0:size) {
                if (get(i) != that.get(i)) {
                    return false;
                }
            }
            return true;
        }
        else {
            return false;
        }
    }

    shared Integer? lastIndexWhere(Boolean selecting(Integer element)) {
        variable value index = size;
        while (index>0) {
            index--;
            value element=getFromFirst(index); 
            if (selecting(element)) {
                return index;
            }
        }
        return null;
    }
}
