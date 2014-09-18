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
    
    variable StringCell? head = null;
    variable StringCell? tail = null;
    
    "The strings that have been appended."
    value strings => StringCellIterable(head);
    
    "Returns the length of the current content, that is,
     the [[size|String.size]] of the produced [[string]]."
    shared Integer size => length;
    
    "The resulting string. If no characters have been
     appended, the empty string."
    shared actual String string => "".join(strings);
    
    "Append the characters in the given [[string]]."
    shared StringBuilder append(String string) {
        if (!string.empty) {
            value cell = StringCell(string);
            if (exists parent = tail) {
                parent.next = cell;
            }
            else {
                head = cell;
            }
            tail = cell;
            length+=string.size;
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
    
    "Prepend the characters in the given [[string]]."
    shared StringBuilder prepend(String string) {
        if (!string.empty) {
            head = StringCell(string, head);
            if (!tail exists) {
                tail = head;
            }
            length+=string.size;
        }
        return this;
    }
    
    "Prepend the characters in the given [[strings]]."
    shared StringBuilder prependAll({String*} strings) {
        for (s in strings) {
            prepend(s);
        }
        return this;
    }
    
    "Append the given [[character]]."
    shared StringBuilder appendCharacter(Character character) {
        //TODO: optimize this with a CharacterCell!
        append(character.string);
        return this;
    }
    
    "Prepend the given [[character]]."
    shared StringBuilder prependCharacter(Character character) {
        //TODO: optimize this with a CharacterCell!
        prepend(character.string);
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
        head = null;
        tail = null;
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
                return append(string);
            }
            else if (index<=0) {
                return prepend(string);
            }
            else {
                variable value start=0;
                variable value cell = head;
                while (exists current = cell) {
                    value str = current.string;
                    value end=start+str.size;
                    if (index==end) {
                        current.next = StringCell(string, current.next);
                        break;
                    }
                    else if (index<end) {
                        value loc = index-start;
                        current.string = str[...loc-1];
                        current.next = StringCell(string, StringCell(str[loc...], current.next));
                        break;
                    }
                    cell=current.next;
                    start=end;
                }
                length+=string.size;
                return this;
            }
        }
        else {
            return this;
        }
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
            value str = string;
            clear();
            append(str[...index-1]);
            append(str[index+length...]);
        }
        return this;
    }
    
    "Deletes the specified [[number of characters|length]] 
     from the start of the string. If `length` is 
     nonpositive, nothing is deleted."
    shared StringBuilder deleteInitial(Integer length) {
        value str = string.terminal(string.size-length);
        head = tail = StringCell(str);
        this.length = str.size;
        return this;
    }
    
    "Deletes the specified [[number of characters|length]] 
     from the end of the string. If `length` is nonpositive, 
     nothing is deleted."
    shared StringBuilder deleteTerminal(Integer length) {
        value str = string.initial(string.size-length);
        head = tail = StringCell(str);
        this.length = str.size;
        return this;
    }
        
}

class StringCell(string, next=null) {
    shared actual variable String string;
    shared variable StringCell? next;
}

class StringCellIterable(StringCell? head) 
        satisfies {String*} {
    shared actual Iterator<String> iterator() {
        object iter satisfies Iterator<String> {
            variable value cell = head;
            shared actual String|Finished next() { 
                if (exists current=cell) {
                    cell = current.next;
                    return current.string;
                }
                else {
                    return finished;
                }
            }
        }
        return iter; 
    }
}