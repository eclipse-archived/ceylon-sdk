import ceylon.net.iop { eq }

doc "Represents a URI Authority part (user, password, host and port)"
by "Stéphane Épardaud"
shared class Authority(user = null, password = null, host = null, port = null){
    
    doc "The optional user"
    shared variable String? user;

    doc "The optional password"
    shared variable String? password;

    doc "The optional host"
    shared variable String? host;

    doc "True if the host name is an ipLiteral (IPV6 or later) and has to be represented 
         surrounded by [] (square brackets)"
    shared variable Boolean ipLiteral = false;
    
    doc "The optional port number"
    shared variable Integer? port;
    
    doc "Returns true if the authority part is present (if the host is not null)"
    shared Boolean specified {
        return host exists;
    }
    
    doc "Returns an externalisable (percent-encoded) representation of this part"    
    shared actual String string {
        return toRepresentation(false);
    }

    doc "Returns a human (non parseable) representation of this part"    
    shared String humanRepresentation {
        return toRepresentation(true);
    }

    doc "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"    
    shared String toRepresentation(Boolean human) {
        if(exists String host = host){
            StringBuilder b = StringBuilder();
            if(exists String user = user){
                b.append(human then user else percentEncoder.encodeUser(user));
                if(exists String password = password){
                    b.appendCharacter(':');
                    b.append(human then password else percentEncoder.encodePassword(password));
                }
                b.appendCharacter('@');
            }
            if(ipLiteral){
                b.append("[");
                b.append(host);
                b.append("]");
            }else{
                b.append(human then host else percentEncoder.encodeRegName(host));
            }
            if(exists Integer port = port){
                b.appendCharacter(':');
                b.append(port.string);
            }
            return b.string;
        }
        return "";
    }
    
    doc "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Authority that){
            if(this === that){
                return true;
            }
            return eq(user, that.user)
                && eq(password, that.password)
                && eq(host, that.host)
                && eq(port, that.port)
                && ipLiteral == that.ipLiteral
                && eq(user, that.user);
        }
        return false;
    }
}
