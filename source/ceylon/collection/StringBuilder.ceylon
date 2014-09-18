"""Builder utility for constructing [[strings|String]] by 
   incrementally appending strings or characters.
   
       value builder = StringBuilder();
       builder.append("hello");
       builder.append(' ');
       builder.append("world");
       String hello = builder.string; //hello world"""
shared class StringBuilder() {
    
    "The total length of all the strings that have been 
     appended."
    variable value length = 0;
    
    "The strings that have been appended."
    value strings = LinkedList<String>();
    
    "Returns the length of the current content, that is,
     the [[size|String.size]] of the produced [[string]]."
    shared Integer size => length;
    
    "The resulting string. If no characters have been
     appended, the empty string."
    shared actual String string => "".join(strings);
    
    "Append the characters in the given [[string]]."
    shared StringBuilder append(String string) {
        if (!string.empty) {
            strings.add(string);
            length+=string.size;
        }
        return this;
    }
    
    "Append the characters in the given [[strings]]."
    shared StringBuilder appendAll({String*} strings) {
        this.strings.addAll(strings);
        for (s in strings) {
            length+=string.size;
        }
        return this;
    }
    
    "Append the given [[character]]."
    shared StringBuilder appendCharacter(Character character) {
        strings.add(character.string);
        length++;
        return this;
    }
    
    "Append a newline character."
    shared StringBuilder appendNewline()
            => appendCharacter('\n');
    
    "Append a space character."
    shared StringBuilder appendSpace() 
            => appendCharacter(' ');
    
    "Remove all content and return to initial state."
    shared StringBuilder clear() {
        strings.clear();
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
        if (!string.empty) {
            if (index>=length) {
                strings.add(string);
            }
            else if (index<=0) {
                strings.insert(0, string);
            }
            else {
                variable value start=0;
                variable value slot=0;
                for (str in strings) {
                    value end=start+str.size;
                    if (index==end) {
                        strings.insert(slot+1, string);
                        break;
                    }
                    else if (index<end) {
                        value loc = index-start;
                        strings.set(slot, string);
                        strings.insert(slot, str[...loc-1]);
                        strings.insert(slot+2, str[loc...]);
                        break;
                    }
                    slot++;
                    start=end;
                }
            }
            length+=string.size;
        }
        return this;
    }
    
    "Insert a [[character]] at the specified [[index]]. If 
     the `index` is beyond the end of the current string, 
     the new content is simply appended to the current 
     content. If the `index` is a negative number, the new 
     content is inserted at index 0."
    shared StringBuilder insertCharacter(Integer index, 
        Character character) 
            => insert(index, character.string);
    
    "Deletes the specified [[number of characters|length]] 
     from the current content, starting at the specified 
     [[index]]. If the `index` is beyond the end of the 
     current content, nothing is deleted. If the number of 
     characters to delete is greater than the available 
     characters from the given `index`, the content is 
     truncated at the given `index`. If `length` is 
     nonpositive, nothing is deleted."
    shared StringBuilder delete(Integer index, 
            Integer length=1) {
        if (length<=0 || index>=this.length || index+length<=0) {
            //nothing to do
        }
        else if (index<=0 && length+index>=this.length) {
            clear();
        }
        else {
            //TODO: not very efficient
            value str = string;
            strings.clear();
            value first = str[...index-1];
            value second = str[index+length...];
            if (!first.empty) {
                strings.add(first);
            }
            if (!second.empty) {
                strings.add(second);
            }
            this.length = first.size+second.size;
        }
        return this;
    }
    
    "Deletes the specified [[number of characters|length]] 
     from the start of the string. If `length` is 
     nonpositive, nothing is deleted."
    shared StringBuilder deleteInitial(Integer length) 
            => delete(0, length);
    
    "Deletes the specified [[number of characters|length]] 
     from the end of the string. If `length` is nonpositive, 
     nothing is deleted."
    shared StringBuilder deleteTerminal(Integer length) 
            => delete(this.length-length, length);
        
}