import com.redhat.ceylon.sdk.test{...}
import ceylon.math.float{...}

Boolean approx(Object? expect, Object? got) {
    if(exists expect){
        if(exists got){
            if (is Float expect) {
                if (is Float got) {
                    // TODO Use MPL to parameterize the tolerance
                    return (expect - got).magnitude < 1.0E-10;
                }
            }
        }
        return false;
    }
    return !exists got;
}

void testSin() {
    print("sin");
    assertEquals{
        expected=0.0; 
        got=sin(0.0); 
        compare=approx;
    };
    assertEquals{
        expected=1.0; 
        got=sin(pi/2); 
        compare=approx;
    };
    assertEquals{
        expected=0.0; 
        got=sin(pi); 
        compare=approx;
    };
    assertEquals{
        expected=-1.0; 
        got=sin(pi*1.5); 
        compare=approx;
    };
    assertEquals{
        expected=0.0; 
        got=sin(2*pi); 
        compare=approx;
    };
    // TODO special cases (e.g. undefined, +/-infinity)
}

void testCos() {
    print("cos");
    assertEquals{
        expected=1.0; 
        got=cos(0.0); 
        compare=approx;
    };
    assertEquals{
        expected=0.0; 
        got=cos(pi/2); 
        compare=approx;
    };
    assertEquals{
        expected=-1.0; 
        got=cos(pi); 
        compare=approx;
    };
    assertEquals{
        expected=0.0; 
        got=cos(pi*1.5); 
        compare=approx;
    };
    assertEquals{
        expected=1.0; 
        got=cos(2*pi); 
        compare=approx;
    };
    // TODO special cases (e.g. undefined, +/-infinity)
}

void testTan() {
    print("tan");
    assertEquals{
        expected=0.0; 
        got=tan(0.0); 
        compare=approx;
    };
    assertEquals{
        expected=1.0; 
        got=tan(pi/4); 
        compare=approx;
    };
    assertEquals{
        expected=-1.0; 
        got=tan(0.75*pi); 
        compare=approx;
    };
    assertEquals{
        expected=0.0; 
        got=tan(pi); 
        compare=approx;
    };
    // TODO special cases (e.g. undefined, +/-infinity)
}

shared void floatTests() {   
    testSin();
    testCos();
    testTan();
}
