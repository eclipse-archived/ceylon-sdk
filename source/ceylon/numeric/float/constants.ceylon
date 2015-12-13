import java.lang {
    JMath=Math
}

"The `Float` which best approximates the 
 mathematical constant \{#0001D452}, the 
 base of the natural logarithm."
see(`function exp`,`function log`)
shared native Float e;

"The Float which best approximates the 
 mathematical constant \{#03C0}, the ratio 
 of the circumference of a circle to its 
 diameter."
shared native Float pi;

"The `Float` which best approximates the 
 mathematical constant \{#0001D452}, the 
 base of the natural logarithm."
see(`function exp`,`function log`)
shared native("jvm") Float e => JMath.\iE;

"The Float which best approximates the 
 mathematical constant \{#03C0}, the ratio 
 of the circumference of a circle to its 
 diameter."
shared native("jvm") Float pi => JMath.\iPI;

"The `Float` which best approximates the 
 mathematical constant \{#0001D452}, the 
 base of the natural logarithm."
see(`function exp`,`function log`)
shared native("js") Float e {
    dynamic {
        return Math.\iE;
    }
}

"The Float which best approximates the 
 mathematical constant \{#03C0}, the ratio 
 of the circumference of a circle to its 
 diameter."
shared native("js") Float pi {
    dynamic {
        return Math.\iPI;
    }
}


