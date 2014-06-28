import ceylon.collection { StringBuilder }
"Abstract class for [[Decoder]] objects, which abstracts
 the [[StringBuilder]]."
by("Stéphane Épardaud")
abstract class AbstractDecoder() satisfies Decoder {
    
    // FIXME: this shouldn't really be exposed, should it?
    shared StringBuilder builder = StringBuilder();

    "Consumes all the characters available in the underlying [[builder]]. Returns null if empty.
     Resets the builder."
    shared actual String? consumeAvailable() {
        // consume all we have without checking for missing things
        if(builder.size > 0){
            value ret = builder.string;
            builder.reset();
            return ret;
        }else{
            return null;
        }
    }

    "Returns the contents of the underlying [[builder]] and resets it."
    default shared actual String done() {
        value ret = builder.string;
        builder.reset();
        return ret;
    }
}