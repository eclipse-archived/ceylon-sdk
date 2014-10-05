shared interface Transaction {
    shared formal void markRollbackOnly();
    shared formal void commit();
    shared formal void rollback();
    shared formal Status status;
    shared formal void setTimeout(Integer timeout);
}

shared abstract class Status() of 
        active | committed | rolledback | 
        markedRolledBack | 
        preparing | prepared | committing | rollingBack | 
        unknown | noTransaction {}

shared object noTransaction extends Status() {}
shared object unknown extends Status() {}
shared object rollingBack extends Status() {}
shared object committing extends Status() {}
shared object preparing extends Status() {}
shared object prepared extends Status() {}
shared object markedRolledBack extends Status() {}
shared object rolledback extends Status() {}
shared object committed extends Status() {}
shared object active extends Status() {}
