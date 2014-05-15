"Builder utility for constructing [[strings|String]] by 
 incrementally appending strings or characters"
shared class StringBuilder() {
    
    variable Array<Character> array = arrayOfSize<Character>(10, 'X');
    variable Integer length = 0;
    
    "Returns the storage array ready for storing [[extra]] more elements.
     Reallocates and copies existing entries if needed."
    Array<Character> getStorage(Integer extra) {
        if (exists existing = array) {
            if (array.size >= length + extra) {
                return existing;
            } else {
                value newArray = arrayOfSize<Character>(newSize(length, existing.size, extra), 'X');
                existing.copyTo(newArray);
                array = newArray;
                return newArray;
            }
        } else {
            value newArray = arrayOfSize<Character>(extra, 'X');
            elements = newArray;
            return newArray;
        }
    }
    
    "Resize policy"
    Integer newSize(Integer length, Integer existingSize, Integer extra) {
        return length+extra;
    }
    
    "The resulting string. If no characters have been
     appended, the empty string."
    shared actual String string {
        return String(array);
    };
    
    "Append the characters in the given [[string]]."
    shared StringBuilder append(String string) {
        if (nonempty string) {
            value store = getStorage(string.size);
            variable value i = 0;
            while (i < string.size) {
                stores.set(length+i, string[i]);
                i++;
            }
            length+= string.size;
        }
        return this;
    }
    
    "Append the characters in the given [[strings]]."
    shared StringBuilder appendAll({String*} strings) {
        for (s in strings) {
            append(s);
        }
        return this;
    }
    
    "Append the given [[character]]."
    shared StringBuilder appendCharacter(Character character) {
        value store = getStorage(1, character);
        store.set(length, character);
        length++;
        return this;
    }
    
    "Append a newline character."
    shared StringBuilder appendNewline() {
        appendCharacter('\n');
        return this;
    }
    
    "Append a space character."
    shared StringBuilder appendSpace() {
        appendCharacter(' ');
        return this;
    }
    
    "Remove all content and return to initial state."
    shared StringBuilder reset() {
        // TODO The sequnce version is called deleteAll
        length = 0;
        return this;
    }
    
    "Insert a [[string]] at the specified [[index]]. If the 
     `index` is beyond the end of the current string, the 
     new content is simply appended to the current content. 
     If the `index` is a negative number, the new content is
     inserted at index 0."
    shared StringBuilder insert(Integer index, 
        String string) {
        if (nonempty string) {
            value store = getStorage(string.size, string.first);
            // make the gap
            store.copyTo(store, index, index+string.size, this.length-index);
            // copy into it
            variable value i = 0;
            while (i < string.size) {
                stores.set(index+i, string[i]);
                i++;
            }
            length+= string.size;
        }
        return this;
    }
    
    "Insert a [[character]] at the specified [[index]]. If 
     the `index` is beyond the end of the current string, 
     the new content is simply appended to the current 
     content. If the `index` is a negative number, the new 
     content is inserted at index 0."
    shared StringBuilder insertCharacter(Integer index, 
        Character character) {
        return insert(index, character.string);
    }
    
    "Deletes the specified [[number of characters|length]] 
     from the current content, starting at the specified 
     [[index]]. If the `index` is beyond the end of the 
     current content, nothing is deleted. If the number of 
     characters to delete is greater than the available 
     characters from the given `index`, the content is 
     truncated at the given `index`. If `length` is 
     nonpositive, nothing is deleted."
    shared StringBuilder delete(Integer index, Integer length=1) {
        if (index < 0) {
            index = 0;
        } else if (index > this.length) {
            return this;
        }
        array.copyTo(array, index+length, index, this.length-length);
        this.length-=length;
        return this;
    }
    
    "Deletes the specified [[number of characters|length]] 
     from the start of the string. If `length` is 
     nonpositive, nothing is deleted."
    shared StringBuilder deleteInitial(Integer length) {
        if (length > 0) {
            if (this.length > length) {
                assert(exists existing = elements) {
                    existing.copyTo(existing, length, 0, this.length);
                    this.length -= length;
                } 
            } else {
                this.length = 0;
            }
        }
        return this;
    }
    
    "Deletes the specified [[number of characters|length]] 
     from the end of the string. If `length` is nonpositive, 
     nothing is deleted."
    shared StringBuilder deleteTerminal(Integer length) {
        if (length > 0) {
            if (this.length > length) {
                this.length -= length;
            } else {
                this.length = 0;
            }
        }
        return this;
    }
    
    "Returns the length of the current content, that is,
     the [[size|String.size]] of the produced [[string]]."
    shared Integer size {
        return length;
    }
    
}