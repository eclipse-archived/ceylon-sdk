import ceylon.time.chronology { unixTime }

"Run all ceylon.time module tests"
shared void run(){
print(unixTime.epoch);
    runDateTests();
    runUtilTests();
}
