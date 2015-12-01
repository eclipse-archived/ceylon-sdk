import ceylon.language.meta.declaration {
    FunctionDeclaration
}
import ceylon.test {
    TestCondition,
    TestDescription,
    test
}

shared variable Integer bazTestConditionCounter = 0;
shared variable Boolean? bazTestConditionResult = true;

shared final annotation class BazTestCondition() 
        satisfies OptionalAnnotation<BazTestCondition, FunctionDeclaration> & TestCondition {
    
    shared actual TestCondition.Result evaluate(TestDescription description) {
        bazTestConditionCounter++;
        if( exists r = bazTestConditionResult ) {
            return Result(r, "BazTestCondition");
        } else {
            throw Exception("BazTestCondition");
        }
    }
    
}

shared annotation BazTestCondition bazTestCondition() => BazTestCondition();

test
bazTestCondition
shared void bazWithTestCondition() {
}