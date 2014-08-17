import ceylon.time {

    Period
}
shared abstract class ZoneRule() of standardZoneRule | PeriodZoneRule | BasedZoneRule {}

shared object standardZoneRule extends ZoneRule(){}

shared class PeriodZoneRule(period) extends ZoneRule(){
    shared Period period;
}

shared class BasedZoneRule(ruleName) extends ZoneRule(){
    shared String ruleName;
}
