"Builder utility for constructing immutable 
 [[sequences|Sequential]] by incrementally appending 
 elements. A newly-instantiated `SequenceBuilder` produces
 the [[empty sequence|empty]] `[]`."
shared class SequenceBuilder<Element>() {
    
    "The number of elements in [[elements]] which are part of the sequence"
    variable Integer length = 0;
    
    "The storage for the elements in the sequence. 
     Only the first [[length]] elements are in the sequence."
    variable Array<Element>? elements = null;
    
    "Returns the storage array ready for storing [[extra]] more elements.
     Reallocates and copies existing entries if needed."
    Array<Element> getStorage(Integer extra, Element exemplar) {
        if (exists existing = elements) {
            if (existing.size >= length + extra) {
                return existing;
            } else {
                value newArray = arrayOfSize<Element>(newSize(length, existing.size, extra), exemplar);
                existing.copyTo(newArray);
                elements = newArray;
                return newArray;
            }
        } else {
            value newArray = arrayOfSize<Element>(extra, exemplar);
            elements = newArray;
            return newArray;
        }
    }
    
    Integer newSize(Integer length, Integer existingSize, Integer extra) {
        return length+extra;
    }
    
    
    "The resulting sequence. If no elements have been 
     appended, the [[empty sequence|empty]] `[]`."
    shared default Element[] sequence {
        return length == 0 then package.empty else ArraySequence(elements.take(length));
    }
    
    "Append an [[element]] to the sequence and return this 
     builder"
    shared default SequenceBuilder<Element> append(Element element) {
        getStorage(1, element).set(length, element);
        length++;
        return this;
    }
    
    "Append multiple [[elements]] to the sequence and return 
     this builder"
    shared default SequenceBuilder<Element> appendAll({Element*} elements) {
        if (is List<Element> elements, exists first=elements.first) {// find out length efficiently if we can
            value extra = elements.size;
            value store = getStorage(extra, first);
            value index = length;
            variable value i = 0;
            while (i < extra) {
                store.set(length+i, element);
            }
            length+=extra;
        } else {
            // we can't get the length efficiently
            for (element in elements) {
                append(element);
            }
        }
        return this;
    }
    
    "The size of the resulting [[sequence]]."
    shared Integer size {
        return length;
    }
    
    "Determine if the resulting [[sequence]] is empty."
    shared Boolean empty => length==0;
    
    "Removes all the elements from the sequence being built."
    shared SequenceBuilder<Element> deleteAll() {
        length = 0;
        return this;
    }
    
    "Removes the last [[number]] elements from the sequence being built.
     Removes all the elements if there are fewer than elements than [[number]].
     Does nothing if number is negative."
    shared SequenceBuilder<Element> deleteTerminal(Integer number) {
        if (number > 0) {
            if (length > number) {
                length -= number;
            } else {
                length = 0;
            }
        }
        return this;
    }
    
    "Removes the first [[number]] elements from the sequence being built.
     Removes all the elements if there are fewer than elements than [[number]].
     Does nothing if number is negative."
    shared SequenceBuilder<Element> deleteInitial(Integer number) {
        if (number > 0) {
            if (length > number) {
                assert(exists existing = elements) {
                    existing.copyTo(existing, number, 0, length);
                    length -= number;
                } 
            } else {
                length = 0;
            }
        }
        return this;
    }
}
