import ceylon.test.engine.spi {
    TestVariantProvider
}
import ceylon.test {
    TestDescription
}

"Default implementation of [[TestVariantProvider]]."
shared class DefaultTestVariantProvider() satisfies TestVariantProvider {
    
    shared actual String variant(TestDescription description, Integer index, Anything[] arguments) {
        value result = StringBuilder();
        
        result.append("(");
        for(arg in arguments.indexed) {
            result.append(stringify(arg.item));
            if( arg.key < arguments.size-1 ) {
                result.append(", ");            
            }
        }
        result.append(")");
        
        return result.string;
    }
    
    String stringify(Anything item) {
        switch(item)
        case(is Null) {
             return "<null>";
        }
        case(is String) {
            return "\"``item``\"";
        }
        case(is Character) {
            return "'``item``'";
        }
        else {
             return item.string;
        }
    }
    
}