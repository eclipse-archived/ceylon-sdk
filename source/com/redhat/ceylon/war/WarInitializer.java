package com.redhat.ceylon.war;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.util.Properties;
import java.util.Collections;

import javax.servlet.ServletContainerInitializer;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.redhat.ceylon.cmr.api.RepositoryManager;
import com.redhat.ceylon.cmr.ceylon.CeylonUtils;

import com.redhat.ceylon.common.FileUtil;

import com.redhat.ceylon.module.loader.FlatpathModuleLoader;
import com.redhat.ceylon.cmr.ceylon.loader.ModuleNotFoundException;

/**
 * A {@link ServletContextListener} that initializes the Ceylon metamodel for
 * web applications packaged by the {@code ceylon war} tool.
 * <p>
 * Note that {@code ServletContextListener}s are not notified of initialization
 * until after {@link ServletContainerInitializer}s have been called. Therefore,
 * if the web application includes a {@code ServletContainerInitializer} that is
 * implemented in Ceylon, it is recommended that the
 * {@code ServletContainerInitializer} force initialization of the Ceylon
 * environment prior to performing other initialization tasks. The
 * {@code WarInitializer} should still be registered with the
 * {@code ServletContext} to ensure
 * {@link #contextDestroyed(ServletContextEvent)} is called.
 * </p>
 * <p>
 * The following can be used to configure the Ceylon environment from a
 * {@code ServletContainerInitializer} implemented in Ceylon, in lieu of the
 * standard {@code web.xml} configuration:
 * </p>
 * <p>
 *
 * <pre>
 * shared class Initializer() satisfies ServletContainerInitializer {
 *     shared actual void onStartup(
 *             Set&lt;Class&lt;out Object>>? set,
 *             ServletContext servletContext) {
 *
 *         value warInitializer = WarInitializer();
 *         warInitializer.initialize(servletContext);
 *         servletContext.addListener(warInitializer);
 *     }
 * }
 * </pre>
 * </p>
 */
public class WarInitializer implements ServletContextListener {

	@Override
	public void contextDestroyed(final ServletContextEvent sce) {
		this.moduleLoader.cleanup();
		this.moduleLoader = null;
		if (this.tmpRepo != null) {
			FileUtil.deleteQuietly(this.tmpRepo);
		}
	}

	@Override
	public void contextInitialized(final ServletContextEvent sce) {
		initialize(sce.getServletContext());
	}

	public void initialize(final ServletContext context) {
		if (moduleLoader != null) {
			return;
		}
		final File repo = setupRepo(context);
		final Properties properties = moduleProperties(context);
		
	        RepositoryManager repositoryManager = CeylonUtils.repoManager()
                  .systemRepo("flat:" + repo.getAbsolutePath())
                  .offline(true)
                  .buildManager();
		
		this.moduleLoader = new FlatpathModuleLoader(repositoryManager, null, Collections.<String,String>emptyMap(), false);
	        try {
        		moduleLoader.loadModule(properties.getProperty("moduleName"),
                                properties.getProperty("moduleVersion"));
	        } catch (ModuleNotFoundException e) {
			throw new RuntimeException(e);
		}
	}

	protected File setupRepo(final ServletContext context) {
		try {
			final URL libDir = context.getResource("/WEB-INF/lib");
			if (libDir.getProtocol().equals("file")) {
				
				return new File(libDir.toURI());
			} else {
				// we're running from the WAR, and need to extract a repo to disk
				final URL libList = context.getResource("/META-INF/libs.txt");
				this.tmpRepo = Files.createTempDirectory("ceylon_war_repo").toFile();
				
				try (BufferedReader reader = new BufferedReader(new InputStreamReader(libList.openStream()))) {
					String filename;
					while ((filename = reader.readLine()) != null) {
						copy(context.getResource("/WEB-INF/lib/" + filename), new File(this.tmpRepo, filename));
					}
				}
			
				return this.tmpRepo;
			}				

		} catch (IOException|URISyntaxException e) {
			throw new RuntimeException(e);
		}
	}
	
	protected Properties moduleProperties(final ServletContext context) {
		final Properties properties = new Properties();
		try (InputStream moduleProps = context.getResourceAsStream("/META-INF/module.properties")) {
			properties.load(moduleProps);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
		
		return properties;
	}
	
	protected void copy(final URL src, final File dest) throws IOException {
		try (InputStream stream = src.openStream()) {
			Files.copy(stream, dest.toPath());
		}
	}
	
	private File tmpRepo;
	private FlatpathModuleLoader moduleLoader;
}


