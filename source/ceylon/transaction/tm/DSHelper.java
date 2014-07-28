package ceylon.transaction.tm;

import ceylon.transaction.tm.InitializationException;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;

/**
 * @author <a href="mailto:mmusgrov@redhat.com">Mike Musgrove</a>
 */
public class DSHelper {
    private static final String DB_PROPERTIES_NAME = "dbc.properties";
    private static final DataSourceManagerImpl dataSourceManager = new DataSourceManagerImpl();
    private static final Set<String> jndiBindings = new HashSet<String>();

    public static void bindDataSources() throws InitializationException {
        bindDataSources(DB_PROPERTIES_NAME);
    }

    public static void bindDataSources(String dbConfigFileName) throws InitializationException {
        registerJndiBindings(dbConfigFileName);
    }

    public static void registerDriverSpec(String driverClassName,
                            String moduleName, String moduleVersion, String dataSourceClassName) {
        dataSourceManager.registerDriverSpec(driverClassName, moduleName, moduleVersion, dataSourceClassName);
    }

    public static void registerDSUrl(String binding, String driver, String databaseUrl,
                    String userName, String password) throws InitializationException {
        dataSourceManager.registerDataSource(binding, driver, databaseUrl, null, -1, userName, password);
    }

    public static void registerDSName(String binding, String driver, String databaseName, String host, long port,
                    String userName, String password) throws InitializationException {
        dataSourceManager.registerDataSource(binding, driver, databaseName, host, port, userName, password);
    }

    private static Set<String> registerJndiBindings(String dbConfigFileName) throws InitializationException {
        Map<String, DbProps> dbConfigs = new DbProps().getConfig(dbConfigFileName);

        for (DbProps props : dbConfigs.values()) {
            String url = props.getDatabaseURL();

            dataSourceManager.registerDriverSpec(props.getDriver(), props.getModuleName(),
                props.getModuleVersion(), props.getDataSourceClassName());

            if (url != null && url.length() > 0)
                dataSourceManager.registerDataSource(props.getBinding(), props.getDriver(), url,
                    props.getDatabaseUser(), props.getDatabasePassword());
            else
                dataSourceManager.registerDataSource(props.getBinding(), props.getDriver(), props.getDatabaseName(),
                    props.getHost(), props.getPort(), props.getDatabaseUser(),props.getDatabasePassword());

            jndiBindings.add(props.getBinding());
        }

        return jndiBindings;
    }
}

