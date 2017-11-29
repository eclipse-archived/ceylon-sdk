/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.sql {
    Connection
}

import javax.sql {
    DataSource
}

"Obtain a connection source, that is, an instance of 
 `Connection()`, for a given JDBC [[dataSource]]."
see (`function newConnectionFromDataSourceWithCredentials`)
shared Connection newConnectionFromDataSource
        (DataSource dataSource)()
        => dataSource.connection;

"Obtain a connection source, that is, an instance of 
 `Connection()`, for a given JDBC [[dataSource]], and
 given credentials."
see (`function newConnectionFromDataSource`)
shared Connection newConnectionFromDataSourceWithCredentials
        (DataSource dataSource, String user, String pass)()
        => dataSource.getConnection(user, pass);

