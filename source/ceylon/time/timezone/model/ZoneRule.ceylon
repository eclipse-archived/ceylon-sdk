import ceylon.time {

    Period
}
"
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared abstract class ZoneRule() of standardZoneRule | PeriodZoneRule | BasedZoneRule {}

"
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared object standardZoneRule extends ZoneRule(){}

"
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class PeriodZoneRule(period) extends ZoneRule(){
    shared Period period;
}

"
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class BasedZoneRule(ruleName) extends ZoneRule(){
    shared String ruleName;
}
