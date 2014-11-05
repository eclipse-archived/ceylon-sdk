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

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.redhat.ceylon.common.FileUtil;
import com.redhat.ceylon.compiler.java.runtime.tools.Backend;
import com.redhat.ceylon.compiler.java.runtime.tools.CeylonToolProvider;
import com.redhat.ceylon.compiler.java.runtime.tools.Runner;
import com.redhat.ceylon.compiler.java.runtime.tools.RunnerOptions;

public class WarInitializer implements ServletContextListener {

	@Override
	public void contextDestroyed(final ServletContextEvent sce) {
		this.runner.cleanup();
		if (this.tmpRepo != null) {
			FileUtil.deleteQuietly(this.tmpRepo);
		}
	}

	@Override
	public void contextInitialized(final ServletContextEvent sce) {
		final ServletContext context = sce.getServletContext(); 
		final File repo = setupRepo(context);
		final Properties properties = moduleProperties(context);
		final RunnerOptions options = new RunnerOptions();
		
		options.setOffline(true);
		options.setSystemRepository("flat:" + repo.getAbsolutePath());
		
		this.runner = CeylonToolProvider.getRunner(Backend.Java, options, 
				properties.getProperty("moduleName"),
				properties.getProperty("moduleVersion"));
		
		this.runner.run();
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
	private Runner runner;
}


