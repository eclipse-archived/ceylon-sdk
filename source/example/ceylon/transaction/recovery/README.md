This example shows how run a transaction that uses two resources (an h2 database and a dummy resource).

The txn-store.tar archive contains an example that demonstrates recovery which you will need to unpack:

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

Running the example against a dummy resource or against other datasources:
======================

  ceylon compile example.ceylon.transaction.recovery

  ceylon run example.ceylon.transaction.recovery

To use other datasources you will need to import the jars containing the java classes for XA. For example,
to include postgresql create an empty postgresql.properties descriptor file and import the jar (org.jumpmind.symmetric.jdbc.postgresql-9.2-1002-jdbc4.jar):

  ceylon import-jar --descriptor=postgresql.properties --out=modules "org.postgresql/9.2-1002" org.jumpmind.symmetric.jdbc.postgresql-9.2-1002-jdbc4.jar --force

Update example/ceylon/transaction/recovery/transaction.ceylon and uncomment the lines that register the driver
and datasource and make sure the dsBindings variable contains "h2" and "postgresql". Similarly if you want to
include other databases in the transaction.

An alternate non programatic alternative is to supply a config file which defines your datasources. Pass
the location of the property file in a process property as follows:

  ceylon run --define=dbc.properties=source/example/ceylon/transaction/recovery/dbc.properties example.ceylon.transaction.recovery

