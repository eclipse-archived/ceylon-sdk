/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.http.common {
    get
}
import ceylon.http.server {
    AsynchronousEndpoint,
    Request,
    Response,
    startsWith
}
import org.eclipse.ceylon.cmr.api {
    RepositoryManager
}
import org.eclipse.ceylon.cmr.ceylon {
    CeylonUtils
}

RepositoryManager defaultRepoManager
        => CeylonUtils.repoManager().buildManager();

Anything(Request, Response, Anything()) moduleService(
    String root,
    RepositoryManager repoManager)
        => serveModule(
            repoManager,
            root
        );

"""Endpoint for serving Ceylon modules from repositories.
   
   By default this will serve modules obtained from a standard
   [[org.eclipse.ceylon.cmr.api::RepositoryManager]] on the
   given root path. Meaning that when the root path is
   `/modules` a request for
   `/modules/ceylon/math/2.0/ceylon.math-2.0.js` will look
   up the `ceylon.math/2.0` module on the local filesystem
   or will download it from the Herd if necessary and then
   send its JS file to the client as a response.
   
   Usage:
   
       shared void run() { 
          value extraRepo = Collections.singletonList("/custom/path/to/modules");
          value manager = CeylonUtils
              .repoManager()
              .extraUserRepos(extraRepo)
              .buildManager();
   
          value server = newServer {
              RepositoryEndpoint {
                  root = "/modules";
                  repoManager = myRepoManager;
              }
          };
       }"""
by("Bastien Jansen", "Tako Schotanus")
shared class RepositoryEndpoint(
        "The root path associated with the endpoint"
        String root,
        "Optional [[org.eclipse.ceylon.cmr.api::RepositoryManager]] to use for
         looking up the requested modules"
        RepositoryManager repoManager = defaultRepoManager) 
        extends AsynchronousEndpoint(startsWith(root), moduleService(root, repoManager), { get }) {
}