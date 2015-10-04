import ceylon.test {
    beforeTest,
    afterTest
}

//{String+} dsBindings = { "h2", "postgresql" };
{String+} dsBindings = { "h2" };
{String+} dsBindings2 = { "h2" };

shared beforeTest void setup() {
    init();
}

shared afterTest void tearDown() {
    fini();
}
