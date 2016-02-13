"Creates an encode mapping for [[Substitution]] that performs a Caesar cipher.
 This replaces each of the 26 characters of the basic latin alphabet with
 another of those characters, [[key]] places away from the original.
 
 Both uppercase and lowercase letters are affected."
shared Map<Character,Character> caesarMapping(key) {
    "The maxiumum offset is 25/-25, values of greater mangnitude than this are
     treated modulo 26."
    Integer key;
    
    return map(
        { for (c in 'A'..'Z')
                c->((c.integer - 'A'.integer + key) % 26 + 'A'.integer).character
        }.chain {
            for (c in 'a'..'z')
                c->((c.integer - 'a'.integer + key) % 26 + 'a'.integer).character
        }
    );
}

"A common case of the Caesar cipher, using a key of 13."
shared object rot13 extends Substitution(caesarMapping(13)) {
}
