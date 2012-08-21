import com.redhat.ceylon.sdk.test{Suite}

class DbcSuite() extends Suite("ceylon.dbc") {
    shared actual Iterable<String->Void()> suite = {
        "Query" -> queryTests,
        "Insert" -> insertTests,
        "Update/Delete" -> updateTests,
        "Calls" -> callTests,
        "Transactions" -> transactionTests
    };
}

shared void run() {
    DbcSuite().run();
}

