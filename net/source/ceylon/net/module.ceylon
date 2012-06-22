Module module {
    name = 'ceylon.net';
    version = '0.5.0';
    by = {"Stéphane Épardaud"};
    license = 'Apache Software License';
    doc = "A module that contains URI stuff";
    dependencies = {
        Import {
            name = 'ceylon.collection';
            version = '0.3.0';
        },
        /*Import {
            name = 'fr.epardaud.iop';
            version = '0.1';
        },*/
        Import {
            name = 'ceylon.json';
            version = '0.3.0';
        }
    };
}