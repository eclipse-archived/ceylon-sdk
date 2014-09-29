/*
 * Copyright 2011 Red Hat Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
"Transaction example using two databases"
by("Mike Musgrove")
license("http://www.apache.org/licenses/LICENSE-2.0")
module example.ceylon.transaction.recovery "1.1.0" {
    shared import ceylon.transaction "1.1.0";

    // ceylon.dbc dependencies
    import ceylon.collection "1.1.0";
    import ceylon.dbc "1.1.0";

	shared import ceylon.interop.java "1.1.0";
    import java.base "7";

    // use vendor specific datasources
    import org.h2 "1.3.168";

    //import org.postgresql "9.2-1002";
	//import com.ibm.db2.jcc "9.7";
    //import org.hsqldb.hsqldb "20140210.123437-60";
    //import org.hsqldb.hsqldb "2.3.1";
	//import oracle.jdbc.driver "10.2.0.4";
}
