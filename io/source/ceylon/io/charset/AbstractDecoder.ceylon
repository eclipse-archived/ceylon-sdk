
abstract class AbstractDecoder() satisfies Decoder{
    shared StringBuilder builder = StringBuilder();

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
    
    default shared actual String done() {
        value ret = builder.string;
        builder.reset();
        return ret;
    }
}