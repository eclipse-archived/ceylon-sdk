This example shows how run a transaction that uses two resources (an h2 database and a dummy resource).

The txn-store.tar archive contains an example that demonstrates recovery. Copy the archive to the ceylon-sdk directory
(cp txn-store.tar ../../../../..).

cd <ceylon-sdk dirctory> 
rm -rf tmp; tar -xf source/example/ceylon/transaction/recovery/txn-store.tar
java -jar ./test-deps/org/h2/1.3.168/org.h2-1.3.168.jar &

The h2 database in tmp/ceylondb.h2.db contains 1 in doubt transacton (SELECT * FROM INFORMATION_SCHEMA.IN_DOUBT) which is adding 2 rows to the CEYLONKV relation (so SELECT * FROM CEYLONKV returns no rows). The h2 console pops up in your web browser. To log in you need the following entries:
    Driver Class: org.h2.Driver
    JDBC URL:  jdbc:h2:<ceylon-sdk directory>/tmp/ceylondb
    User Name: sa
    Password: sa

Force a recovery scan by running the recovery manager in interactive mode:

ceylon run --run=ceylon.transaction.rm.run --define=interactive= --define=dbc.properties=tmp/dbc.properties ceylon.transaction
> scan
> quit

Now SELECT * FROM CEYLONKV will return 2 rows and there should be no in doubt transactions.

