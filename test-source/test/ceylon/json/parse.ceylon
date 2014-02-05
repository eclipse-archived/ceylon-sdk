import ceylon.json { ... }
import ceylon.test { ... }

String herdJson = """
                     {"total": 47,
                      "start": 0,
                      "results" : [
                      {
                       "module": "cayla",
                       "versions": [
                        "0.1.0", 
                        "0.2.0", 
                        "0.2.1", 
                        "0.2.2" 
                       ],
                       "doc": "# The Cayla Web Framework\n\nCayla makes easy creating web application with Ceylon.\n\n## Creating a simple application in seconds\n\n### Import the Cayla module\n\n    module my.app \"1.0.0\" {\n      import cayla \"0.2.2\";\n    }\n\n### Write the controller\n\n    import cayla { ... }\n\n    object controllers {\n      route(\"/\")\n      shared class Index() extends Controller() {\n        shared actual default Response handle() => ok().body(\"Hello World\");\n      }\n    }\n\n    shared void run() {\n      value application = Application(controllers);\n      application.run();\n    }\n\n### Build and run!\n\n    > ceylon compile my.app\n    ...\n    > ceylon run my.app/1.0\n    started\n\n## Application\n\nApplications are create via the [[Application]] objects that takes as argument a Ceylon declaration or an object that\nis scanned to discover the controllers:\n\n### Package applications\n\n    Application(`package my.controllers`)\n\n### Object applications\n\n    Application(controllers)\n\n### Application life cycle\n\nApplication can be started with [[Application.run]] or [[Application.start]]:\n\n- `run` run the application and blocks until the current process reads a line (like enter keystroke).\n- `start` starts the application asynchronously and returns a `Promise<Runtime>` providing a fine grained control over\n  the application life cycle.\n\n### Application configuration\n\nConfiguration is handled by the [[Config]] class. By default the appliation is bound on the 8080 port\nand on all available interfaces. Explicit config can be provided when the application is created:\n\n    Application(`package my.controllers`, Config{port = 80;});\n\n## Controllers \n\nControllers must extend the [[Controller]] interface, they can declare parameters which shall declares the \n`String` type, be shared and immutable. Such parameters are mapped to*query* or *path*  request parameters.\n\n### Query parameters\n\n    route(\"/greeter\")\n    shared clas Greeter(String name) extends Controller() {\n      shared actual default Response handle() => ok().body(\"Hello ``name``\");\n    }\n\n### Path parameters\n\n    route(\"/greeter/:name\")\n    shared clas Greeter(String name) extends Controller() {\n      shared actual default Response handle() => ok().body(\"Hello ``name``\");\n    }\n\nPath parameters can match \n\n* a single path segment (i.e that does not contain any `/` chars) declared with the `:` prefix like `:name`\n* zero or more segments `*` prefix like `*name`\n* one or more segments `+` prefix like `+name`\n\n### Controller URL\n\nControllers can be addressed using the redefined [[Controller.string]] method. In a controller the expression\n`Greeter(\"Cayla\")` will produce the *http://localhost:8080/greeter?name=Cayla* or the \n*http://localhost:8080/greeter/Cayla* URL.\n\n## Controller logic\n\nDuring an invocation Cayla dispatches the request to the [[Controller.handle]] method. This method should implement\nthe controller behavior.\n\nIt is also possible to override the [[Controller.invoke]] method instead that provides access to the [[RequestContext]]\nclass that exposes Cayla objects.\n\nBoth methods returns a [[Response]] object that is sent to the client via Vert.x\n\n## Responses\n\nThe [[Response]] class is the base response, the [[Status]] class extends the response class to define the http status\nand the [[Body]] class extends the [[Status]] with a response body.\n\nCreating responses is usually done via the fluent API and the top level functions such as [[ok]], [[notFound]] or\n[[error]].\n\n    return notFound().body(\"Not found!!!!\");\n\n## Http methods\n\nBy default a controller is bound to a route for all Http methods. This can be restricted by using annotations like\n[[get]], [[post]], [[head]], [[put]], etc...\n\n    get route(\"/greeter\")\n    shared clas Greeter(String name) extends Controller() {\n      shared actual default Response handle() => ok().body(\"Hello ``name``\");\n    }\n\n",
                       "license": "", 
                       "dependencies": [
                        {
                         "module": "ceylon.net",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "vietj.vertx",
                         "version": "0.3.4",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.build.engine",
                       "versions": [
                        "1.0.0" 
                       ],
                       "doc": "The goal of this module is to provide a goal/task based build engine to achieve actions.\nIt could be used to handle development tasks like compile, test, document, run module,  ...\nor any other action like files copy, directory cleanup, ...\n\n\n`ceylon.build.engine` objective is to achieve requested goals by executing their\nassociated task function and orchestrating their dependencies.\n\nMore detailled documentation on how to create and use `Goal` and `GoalSet`\ncan be found in module `ceylon.build.task`.\n\n# Build module\n\nA build module is a standard ceylon module that has in its `run()` function a call to\n`build(String project, {<Goal|GoalSet>+} goals)`.\n\n```ceylon\nimport ceylon.build.engine { build }\nimport ceylon.build.task { Goal }\nimport ceylon.build.tasks.ceylon { ceylonModule }\nimport ceylon.build.tasks.file { delete, copy }\nimport ceylon.file { parsePath }\n\nvoid run() {\n    String myModule = \"mod\";\n    build {\n        project = \"My Build Project\";\n        Goal {\n            name = \"clean\";\n            delete {\n                path = parsePath(\"modules/``myModule``\");\n            }\n        },\n        ceylonModule {\n            moduleName = myModule;\n            testModuleVersion = \"1.0.0\";\n        },\n        Goal {\n            name = \"publish-local\";\n            copy {\n                source = parsePath(\"modules/``myModule``\");\n                destination = parsePath(\"/path/to/local/ceylon/repo/``myModule``\");\n                overwrite = true;\n            }\n        }\n    };\n}\n```\nThis simple build module defines two goals and one goal set.\n\n- `\"clean\"` goal deletes directory `\"modules/mod\"`\n- `\"publish-local\"` copies files from `\"modules/mod\"` to `\"/path/to/local/ceylon/repo/mod\"`\n- `ceylonModule` function returns a goal set containing `\"compile\"`, `\"tests-compile\"`,\n`\"test\"` and `\"doc\"` goals. Those goals are provided by `ceylon.build.tasks.ceylon` module\nto handle ceylon modules development lifecycle. \n\n# Execution\n\nWhen this `yourbuildmodule` is launched, it will build the goal graph and run requested goal's task and their\ndependencies.\n\nUsing the above goals declarations, launching `ceylon run yourbuildmodule/1.0.0 clean compile doc` will result\nin the execution of goal `\"clean\"`, `\"compile\"` and `doc` in this order.\n\nArguments can be passed to each goal task using the `-Dgoal:argument` syntax.\n\nFor example, `compile` task has support for `--javac` argument and `doc` task for `--non-shared` and\n`--source-code` arguments, then, the following command can be used:\n`ceylon run mybuildmodule/1.0.0 test doc -Dcompile:--javac=-g:source,lines,vars -Ddoc:--non-shared -Ddoc:--source-code`\n\n# Dependencies\n\nSometimes, it is needed to always execute a goal before another one.\nIn that case, the second goal can declare a dependency on the first one as below:\n```ceylon\nimport ceylon.build.engine { build }\nimport ceylon.build.task { Goal }\nimport ceylon.build.tasks.ceylon { compile, compileTests, document, runModule }\n\nvoid run() {\n    String myModule = \"mod\";\n    String myTestModule = \"test.mod\";\n    Goal compileGoal = Goal {\n        name = \"compile\";\n        compile {\n            modules = myModule;\n        }\n    };\n    Goal compileTestsGoal = Goal {\n        name = \"tests-compile\";\n        dependencies = [compileGoal];\n        compileTests {\n            modules = myTestModule;\n        }\n    };\n    Goal testGoal = Goal {\n        name = \"test\";\n        dependencies = [compileTestsGoal];\n        runModule {\n            moduleName = myTestModule;\n            version = \"1.0.0\";\n        }\n    };\n    Goal docGoal = Goal {\n        name = \"doc\";\n        document {\n            modules = myModule;\n            includeSourceCode = true;\n        }\n    };\n    build {\n        project = \"My Build Project\";\n        compileGoal,\n        compileTestsGoal,\n        testGoal,\n        docGoal\n    };\n}\n```\n\nIn this example, `\"tests-compile\"` declares a dependency on `\"compile\"` and\n`\"test\"` declares a dependency on `\"tests-compile\"`.\n\nExecuting `ceylon run mybuildmodule/1.0.0 test` will result in the execution\nof goals `\"compile\"`, `\"tests-compile\"` and `\"test\"` in order.\nAs you can see, dependencies are recursives because not only direct dependencies\nof `\"test\"` are put in the execution list, but also indirect dependencies\n(dependencies of dependencies of ...)\n\n## Goals re-ordering\n\nAnother feature of the dependency resolution mechanism is that it will re-order\ngoal execution list to satisfy dependencies.\n\nFor example, executing `ceylon run mybuildmodule/1.0.0 test tests-compile compile`\nwill result in the execution of goals `\"compile\"`, `\"tests-compile\"` and `\"test\"`\nin this order because it is the only execution order that satisfies dependencies.\n\nIn a general way, goals will be executed in the order they are requested as long\nthat it satisfies declared dependencies. Otherwise, dependencies, will be moved\nbefore in the execution list to restore consistency.\n\n## Multiple goals occurences\n\nIn case a goal is requested multiple times (could be directly, or by dependency to it),\nthe engine ensures that it will be executed only once.\n\nUsing previous example, executing `ceylon run mybuildmodule/1.0.0 test tests-compile compile`\nwill result in the execution of goals `\"compile\"`, `\"tests-compile` and `\"test\"` in this order.\nEven if `\"compile\"` and `\"tests-compile\"` are requested twice (once directly, and once per dependency).",
                       "license": "[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)", 
                       "dependencies": [
                        {
                         "module": "ceylon.build.task",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.collection",
                         "version": "1.0.0",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.interop.java",
                         "version": "1.0.0",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.build.task",
                       "versions": [
                        "1.0.0" 
                       ],
                       "doc": "This module defines the base elements of `ceylon.build` for declaring goals and tasks.\n\n# Goal\n`ceylon.build.engine` is designed to work with goals.\n\nA [[Goal]] represents an action that can be launched by the engine.\nIt has a name and a tasks list.\n- `Goal.name` is used in command line to ask for a goal execution.\n- `Goal.tasks` is a list of operations that will be executed in order when the goal name is specified.\n- `Goal.dependencies` is a list of goals that must be executed before current goal's tasks.\n\n## Simple goal definition\nHere is an example of how to define a simple `Goal`:\n```ceylon\nGoal hello = Goal {\n    name = \"hello\";\n    function(Context context) {\n        context.writer.info(\"Hello World!\");\n        return done;\n    }\n};\n```\n## Task definition\nA [[Task]] is an operation that will be executed when the goal name is specified.\n\nIt takes a [[Context]] in input and returns an [[Outcome]] object telling if task execution succeed or failed.\n\nHere is an example of a simple task that will display `\"Hello World!\"` message:\n```ceylon\nOutcome helloTask(Context context) {\n    context.writer.info(\"Hello World!\");\n    return done;\n}\n```\n\nA task can also return a success / failure message\n```ceylon\nOutcome myTask(Context context) {\n    try {\n        processMyXXXTask();\n        return Success(\"operation xxx done\");\n    } catch (Exception exception) {\n        return Failure(\"failed to do xxx\", exception);\n    }\n}\n```\n\n## Goal with multiple tasks\nA goal can have several tasks.\n\n```ceylon\nGoal myGoal = Goal {\n    name = \"myGoal\";\n    function(Context context) {\n        context.writer.info(\"starting\");\n        return done;\n    },\n    function(Context context) {\n        context.writer.info(\"running\");\n        return done;\n    },\n    function(Context context) {\n        context.writer.info(\"stopping\");\n        return done;\n    }\n};\n```\nThey will all be executed in order when goal execution is requested.\nIf one of the tasks fails, execution will stop and failure will be reported.\n\n## Dependencies\nA goal can also define dependencies to other goals.\nDependencies will be executed (even if not explicitly requested) before all other goals in the execution\nlist that depend on those.\n\n\n```ceylon\nGoal compile = Goal {\n    name = \"compile\";\n    function(Context context) {\n        context.writer.info(\"compiling!\");\n        return done;\n    }\n};\nGoal run = Goal {\n    name = \"run\";\n    dependencies = [compile];\n    function(Context context) {\n        context.writer.info(\"running!\");\n        return done;\n    }\n};\n```\nWith the above code, requesting execution of `run` goal will result in execution of goals `compile`\nfollowed by `run`.\n\n## Goals without tasks\nIt is possible to define a goal that don't have any tasks like below:\n```ceylon\nGoal testGoal = Goal {\n    name = \"test\";\n};\n```\nSuch a goal is useless, because it will not trigger any tasks execution.\n\nHowever, if dependencies are added it becomes a great way to group goals.\n\nRequesting the execution of a such goal will cause the execution (as for any goals) of all of its dependencies.\nThe execution of those dependencies will be done in the order of declaration as long as\ndependencies between goals of the current execution list are satisfied.\nIf they are not, goals will be re-ordered to satisfy dependencies.\n\nHere is an example:\n```ceylon\nGoal compileGoal = Goal {\n    name = \"compile\";\n    compile {\n        modules = \"my.module\";\n    }\n};\nGoal compileTestsGoal = Goal {\n    name = \"compile-tests\";\n    compileTests {\n        modules = \"test.my.module\";\n    }\n};\nGoal runTestsGoal = Goal {\n    name = \"run-tests\";\n    runModule {\n        moduleName = \"test.my.module\";\n        version = \"1.0.0\";\n    }\n};\nGoal testGoal = Goal {\n    name = \"test\";\n    dependencies = [compileTestsGoal, runTestsGoal];\n};\n```\nExecution of `testGoal` will result in execution of goals `compileTestsGoal` followed by `runTestsGoal`.\n\nAs a goals without tasks is like any other goal from a dependency point of view, it can be used as a\ndependency which enables interesting constructions like below:\n```ceylon\nGoal fullBuild = Goal {\n    name = \"full-build\";\n    dependencies = [compileGoal, test];\n};\n```\nExecution of `fullBuild` will trigger execution of `compileGoal`, `compileTestsGoal` and then `runTestsGoal`.\n\n# GoalSet\nA [[GoalSet]] is a set of goals that can be imported in a build configuration.\n\nFor example, if a `ceylonModule` goal set provides goals to compile, compile tests, run tests\nand document a ceylon module and you have differents ceylon modules in your build, then,\nyou are likely to want to rename `\"compile\"`, `\"tests-compile\"`, `\"test\"` and `\"doc\"` to something\nlike `\"compile.mymodule1\"`, `\"tests-compile.mymodule1\"`, ...\n\nHere is an example of goal set definition from `ceylon.build.tasks.ceylon` module   \n```ceylon\n\"Returns a `GoalSet` providing compile, tests-compile, test and doc goals for a ceylon module.\"\nshared GoalSet ceylonModule(\n        \"module name\"\n        String moduleName,\n        \"test module name\"\n        String testModuleName = \"test.``moduleName``\",\n        \"test module version\"\n        String testModuleVersion = \"1.0.0\",\n        \"rename function that will be applied to each goal name.\"\n        String(String) rename = keepCurrentName()) {\n    return GoalSet {\n        Goal {\n            name = rename(\"compile\");\n            compile {\n                modules = moduleName;\n            }\n        },\n        Goal {\n            name = rename(\"tests-compile\");\n            compile {\n                modules = testModuleName;\n                sourceDirectories = testSourceDirectory;\n            }\n        },\n        Goal {\n            name = rename(\"test\");\n            runModule {\n                moduleName = testModuleName;\n                version = testModuleVersion;\n            }\n        },\n        Goal {\n            name = rename(\"doc\");\n            document {\n                modules = moduleName;\n            }\n        }\n    };\n}\n```\nIt can be used as following:\n```ceylon\nGoalSet ceylonModuleA = ceylonModule {\n    moduleName = \"moduleA\";\n    rename = suffix(\".a\");\n};\nGoalSet ceylonModuleB = ceylonModule {\n    moduleName = \"moduleB\";\n    rename = suffix(\".b\");\n};\n```\nThis will import goals `\"compile.a\"`, `\"tests-compile.a\"`, `\"test.a\"`, `\"doc.a\"`,\n`\"compile.b\"`, `\"tests-compile.b\"`, `\"test.b\"`, `\"doc.b\"` in the build configuration.\n",
                       "license": "[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)", 
                       "dependencies": [
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.build.tasks.ceylon",
                       "versions": [
                        "1.0.0" 
                       ],
                       "doc": "Provides `Task` to launch ceylon `compile`, `compile-js`, `doc`, `run`, `run-js` command line tools\n\n### Compile\nTasks to compile to both jvm and javascript backend are available.\nThey support various options.\n\nA simple task to compile to jvm backend:\n```ceylon\nTask compileTask = compile {\n    modules = \"my.module\";\n};\n```\nA simple task to compile to javascript backend:\n```ceylon\nTask compileJsTask = compileJs {\n    modules = \"my.module\";\n};\n```\nSeveral modules can be compile at once:\n```ceylon\nTask compileTask = compile {\n    modules = [\"my.module1\", \"my.module2\"];\n};\n```\nCompiler options can be configured:\n```ceylon\nTask compileTask = compile {\n    modules = [\"my.module\", \"test.my.module\"];\n    encoding = \"UTF-8\";\n    sourceDirectories = [\"source\", \"test-source\"];\n    outputRepository = \"~/.ceylon/repo\";\n};\n```\n#### Compile tests\nTasks to compile tests are provided.\nThey are shortcuts for respectively [[compile]] and [[compileJs]] functions with\n`sourceDirectories` argument set to `[\"test-source\"]`\n \nTask to compile tests to jvm backend:\n```ceylon\nTask compileTestsTask = compileTests {\n    modules = \"test.my.module\";\n};\n```\nTask to compile tests to javascript backend:\n```ceylon\nTask compileJsTestsTask = compileJsTests {\n    modules = \"test.my.module\";\n};\n```\n\n### Doc\nA simple document task:\n```ceylon\nTask documentTask = document {\n    modules = \"my.module\";\n};\n```\nSeveral options can be configured:\n```ceylon\nTask documentTask = document {\n    modules = \"my.module\";\n    includeSourceCode = true;\n    includeNonShared = true;\n};\n```\n\n### Run\nA simple task to run a module on jvm backend:\n```ceylon\nTask runTestsTask = runModule {\n    moduleName = \"test.my.module\";\n    version = \"1.0.0\";\n};\n```\n\nA simple task to run a module on javascript backend:\n```ceylon\nTask runJsTestsTask = runModule {\n    moduleName = \"test.my.module\";\n    version = \"1.0.0\";\n};\n```\n\nSeveral options can be configured:\n```ceylon\nTask runTestsTask = runModule {\n    moduleName = \"test.my.module\";\n    version = \"1.0.0\";\n    functionNameToRun = \"customMain\";\n};\n```\n",
                       "license": "[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)", 
                       "dependencies": [
                        {
                         "module": "ceylon.build.task",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.build.tasks.commandline",
                         "version": "1.0.0",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.build.tasks.commandline",
                       "versions": [
                        "1.0.0" 
                       ],
                       "doc": "This modules provides functions to execute commands.\n\nThe following example will create a task that when called will execute `git pull` command.\n```ceylon\nTask updateTask = command(\"git pull\");\n```\n[[command]] function is a `Task` wrapper for [[executeCommand]] function.\n\nCommands are executed in a synchronous way. This means that both functions will wait\nfor command to exit before returning.\n",
                       "license": "[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)", 
                       "dependencies": [
                        {
                         "module": "ceylon.build.task",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.file",
                         "version": "1.0.0",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.process",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.build.tasks.file",
                       "versions": [
                        "1.0.0" 
                       ],
                       "doc": "Functions and `Task` wrappers to copy / delete files and directories.\n\n### Delete\n\nThis module provides two functions to delete files and directories.\n- [[deletePath]]: function to delete files / directories that can be used in your own tasks\n- [[delete]]: function creating a wrapper `Task` for [[deletePath]] function\n\nHere is an example of a task which will delete `\"modules\"` directory.\n```ceylon\nTask cleanTarget = delete {\n    path = parsePath(\"modules\");\n};\n```\n\nA filter can be added to that task to only delete files with extensions `\"car\"` and `\"car.sha1\"`\n```ceylon\nTask cleanTarget = delete {\n    path = parsePath(\"modules\");\n    filter = extensions(\"car\", \"car.sha1\");\n};\n```\n\n### Copy\n\nThis module provides two functions to copy files and directories.\n- [[copyFiles]]: function to copy files / directories that can be used in your own tasks\n- [[copy]]: function creating a wrapper `Task` for [[copyFiles]] function\n\nHere is an example of a task which will copy file `\"modules/mymodule/1.0.0/module-1.0.0.car\"`\nto `\"container/modules\"`.\n```ceylon\nTask deploy = copy {\n    source = parsePath(\"modules/mymodule/1.0.0/module-1.0.0.car\");\n    destination = parsePath(\"container/modules\");\n};\n```\nNote that copy acts the same way as the `cp` Unix command when a single file is given in input\n- If the destination is a directory, it will copy the file under the destination directory.\n(`modules/mymodule/1.0.0/module-1.0.0.car` -> `\"container/modules/module-1.0.0.car` in our example)\n- If the destination is a file it will overwrite it or fail depending of overwrite configuration\n(`modules/mymodule/1.0.0/module-1.0.0.car` -> `\"container/modules\"` in our example)\n- If the destination doesn't exist, it will use copy input file to destination\n(`modules/mymodule/1.0.0/module-1.0.0.car` -> `\"container/modules\"` in our example)\n\nA directory can also be copied recursively as below\n```ceylon\nTask deploy = copy {\n    source = parsePath(\"modules\");\n    destination = parsePath(\"container/modules\");\n    filter = extensions(\"car\");\n};\n```\n",
                       "license": "[ASL 2.0](http://www.apache.org/licenses/LICENSE-2.0)", 
                       "dependencies": [
                        {
                         "module": "ceylon.build.task",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.file",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.collection",
                       "versions": [
                        "0.3.1", 
                        "0.3.2", 
                        "0.4", 
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Stéphane Épardaud" 
                       ],
                       "doc": "A module for collections.\n\nYou can find here the following mutable collection types:\n\n- [[MutableList]]\n- [[MutableSet]]\n- [[MutableMap]]\n\nAlong with concrete implementations for each:\n\n- [[LinkedList]]\n- [[HashSet]]\n- [[HashMap]]\n",
                       "license": "Apache Software License", 
                       "dependencies": [
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".js"
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.dbc",
                       "versions": [
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Enrique Zamudio" 
                       ],
                       "doc": "This module offers some components for JDBC-based\ndatabase connectivity. The main component is simply\ncalled Sql and is meant to be used with a `DataSource`\nthat has been already been configured. ",
                       "license": "Apache Software License 2.0", 
                       "dependencies": [
                        {
                         "module": "ceylon.collection",
                         "version": "1.0.0",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.math",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "java.jdbc",
                         "version": "7",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.file",
                       "versions": [
                        "0.3", 
                        "0.3.1", 
                        "0.3.2", 
                        "0.4", 
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Gavin King" 
                       ],
                       "doc": "API for accessing hierarchical file systems. Clients use [[Path]]s to\nobtain [[Resource]]s representing files or directories.\n\n`Path` contains many useful operations for manipulating paths:\n\n    value path = parsePath(\"/Users/Trompon/Documents\");\n    value child = path.childPath(\"hello.txt\");\n    value sibling = child.siblingPath(\"goodbye.txt\");\n    value parent = path.parent;\n\nThe attribute [[resource|Path.resource]] of `Path` is used to obtain \na `Resource`. It is usually necessary to narrow a `Resource` to one\nof the following enumerated subtypes before performing operations on \nit:\n\n- a [[File]] contains data,\n- a [[Directory]] contains other resources, \n- a [[Link]] is a symbolic link to another resource, or \n- a [[Nil]] is an unoccupied location in the filesystem where a \n  resource may safely be created.\n\nTo create a file named `hello.txt` in the home directory, we could do \nthe following:\n\n    value filePath = home.childPath(\"hello.txt\");\n    if (is Nil loc = filePath.resource) {\n        value file = loc.createFile();\n        try (writer = file.Overwriter()) {\n            writer.writeLine(\"Hello, World!\");\n        }\n    }\n    else {\n        print(\"file already exists\");\n    }\n\nNote the difference between a [[File.Overwriter]], which destroys the\nexisting contents of the file, if any, and a [[File.Appender]], which \nleaves them intact.\n\nTo print the contents of the file we just created, we could do this:\n\n    value filePath = home.childPath(\"hello.txt\");\n    if (is File file = filePath.resource) {\n        try (reader = file.Reader()) {\n            print(reader.readLine());\n        }\n    }\n    else {\n        print(\"file does not exist\");\n    }\n\nNow, to rename the file:\n\n    value filePath = home.childPath(\"hello.txt\");\n    if (is File file = filePath.resource) {\n        value newPath = filePath.siblingPath(\"goodbye.txt\");\n        if (is Nil loc = newPath.resource) {\n           file.move(loc);\n        }\n        else {\n            print(\"target file already exists\");\n        }\n    }\n    else {\n        print(\"source file does not exist\");\n    }\n\nTo list the contents of a directory, we have two possibilities.\nWe can list just the direct contents:\n\n    if (is Directory dir = home.resource) {\n        for (path in dir.childPaths()) {\n            print(path);\n        }\n    }\n    else {\n        print(\"directory does not exist\");\n    }\n\nAlternatively, we can create a [[Visitor]] that walks the whole \ndirectory tree rooted at a given path:\n\n    object visitor extends Visitor() {\n        file(File file) => print(file.path);\n    }\n    home.visit(visitor);\n\nFile systems other than the default file system are supported. For \nexample, a file system for a zip file may be created using the\nconvenience function [[createZipFileSystem]].\n\n    value zipPath = home.childPath(\"myzip.zip\");\n    if (is Nil|File loc = zipPath.resource) {\n        value zipSystem = createZipFileSystem(loc);\n        value entryPath = zipSystem.parsePath(\"/hello.txt\");\n        if (is Nil entry = entryPath.resource) {\n            value filePath = home.childPath(\"hello.txt\");\n            if (is File file = filePath.resource) {\n                file.copy(entry);\n            }\n            else {\n                print(\"source file does not exist\");\n            }\n        }\n        else {\n            print(\"entry already exists\");\n        }\n        zipSystem.close();\n    }\n",
                       "license": "", 
                       "dependencies": [
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.html",
                       "versions": [
                        "1.0.0" 
                       ],
                       "authors": [
                        "Daniel Rochetti" 
                       ],
                       "doc": "This module allows you to write HTML templates\nfor both server and client using only Ceylon.",
                       "license": "", 
                       "dependencies": [
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".js"
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.interop.java",
                       "versions": [
                        "0.3.1", 
                        "0.4", 
                        "0.4.1", 
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "The Ceylon Team" 
                       ],
                       "doc": "A selection of utility methods to improve Java interoperability.\n\nThe following methods and types exist:\n\n- `javaString(String string)` - takes a Ceylon String and turns it into a Java String\n- `JavaIterator<T>(Iterator<T> iter)` - takes a Ceylon Iterator and turns it into a Java Iterator\n- `JavaIterable<T>(Iterable<T> iter)` - takes a Ceylon Iterable and turns it into a Java Iterable\n- `CeylonIterator<T>(JIterator<T> iter)` - takes a Java Iterator and turns it into a Ceylon Iterator\n- `CeylonIterable<T>(JIterable<T> iter)` - takes a Java Iterable and turns it into a Ceylon Iterable\n- `JavaCollection({T*} items)` - takes a Ceylon list of items and turns them into a Java Collection\n- `javaClass<T>()` - returns the Java Class reference for type T\n- `javaClass(Object obj)` - takes a class instance and returns a Java Class reference for its type\n",
                       "license": "", 
                       "dependencies": [
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.io",
                       "versions": [
                        "0.4", 
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Stéphane Épardaud" 
                       ],
                       "doc": "This module allows you to read and write to streams, such as files, sockets and pipes.\n\nIt also defines character sets, for encoding and decoding bytes to strings, as well\nas buffers of bytes and characters for input/output.\n\nSee the `ceylon.io` package for usage examples.",
                       "license": "Apache Software License", 
                       "dependencies": [
                        {
                         "module": "ceylon.collection",
                         "version": "1.0.0",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.file",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.json",
                       "versions": [
                        "0.3.1", 
                        "0.3.2", 
                        "0.4", 
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Stéphane Épardaud" 
                       ],
                       "doc": "Contains everything required to parse and serialise JSON data.\n\nSample usage for parsing and accessing JSON:\n\n    String getAuthor(String json){\n        value parsedJson = parse(json);\n        if(is String author = parsedJson.get(\"author\")){\n            return author;\n        }\n        throw Exception(\"Invalid JSON data\");\n    }\n\nOr if you're really sure that you should have a String value:\n\n    String getAuthor(String json){\n        value parsedJson = parse(json);\n        return parsedJson.getString(\"author\")){\n    }\n\nYou can iterate Json objects too::\n\n    {String*} getModules(String json){\n        value parsedJson = parse(json);\n        if(is Array modules = parsedJson.get(\"modules\")){\n            return { for (mod in modules) \n                       if(is Object mod, is String name = mod.get(\"name\")) \n                         name \n                   };\n        }\n        throw Exception(\"Invalid JSON data\");\n    }     \nSample usage for generating JSON data:\n\n    String getJSON(){\n        value json = Object {\n            \"name\" -> \"Introduction to Ceylon\",\n            \"authors\" -> Array {\n                \"Stef Epardaud\",\n                \"Emmanuel Bernard\"\n            }\n        };\n        return json.string;\n    }\n",
                       "license": "Apache Software License", 
                       "dependencies": [
                        {
                         "module": "ceylon.collection",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".js"
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.language",
                       "versions": [
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Enrique Zamudio",  
                        "Gavin King",  
                        "Stephane Epardaud",  
                        "Tako Schotanus",  
                        "Tom Bentley" 
                       ],
                       "doc": "The Ceylon language module containing the core types \nreferred to in the language specification.",
                       "license": "http://www.apache.org/licenses/LICENSE-2.0.html", 
                       "dependencies": [
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".js"
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.math",
                       "versions": [
                        "0.1", 
                        "0.2", 
                        "0.3.1", 
                        "0.3.2", 
                        "0.4", 
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Tom Bentley" 
                       ],
                       "doc": "This module provides four APIs:\n\n- `ceylon.math.decimal`&mdash;an arbitrary-precision decimal\n  numeric type,\n- `ceylon.math.whole`&mdash;an arbitrary-precision integer\n  numeric type,\n- `ceylon.math.float`&mdash;various common mathematical \n  functions for floating-point numbers, and\n- `ceylon.math.integer`&mdash;various common functions for\n  integers.\n\nThe types [[Whole|ceylon.math.whole::Whole]] and \n[[Decimal|ceylon.math.decimal::Decimal]] are first-class numeric \ntypes and support all the usual mathematical operations:\n\n    Whole i = wholeNumber(12P);\n    Whole j = wholeNumber(3);\n    Whole n = i**j + j;\n    print(n); //prints 1728000000000000000000000000000000000003\n\nOperations on `Decimal`s can result in a non-terminating \ndecimal representation. In such cases, it is necessary to \nperform the operations with _rounding_. The function\n`implicitlyRounded()` performs a computation with rounding.\n\n    Decimal x = decimalNumber(66.0G);\n    Decimal y = decimalNumber(100.0T);\n    Decimal z = decimalNumber(66.0f);\n    Decimal d = implicitlyRounded(() (x+z)/y/x, round(40, halfUp));\n    print(d); //prints 1.000000000000000000000001E-14\n\nHere, the expression `(x+z)/y/x`, which has no terminating \ndecimal representation, is evaluated with the intermediate \nresult of each constituent operation rounded down to 40\ndecimal digits.",
                       "license": "", 
                       "dependencies": [
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.net",
                       "versions": [
                        "0.3.1", 
                        "0.3.2", 
                        "0.4", 
                        "0.5", 
                        "0.5.1", 
                        "0.5.2", 
                        "0.5.3", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Stéphane Épardaud, Matej Lazar" 
                       ],
                       "doc": "This module allows you to represent URIs, to connect to HTTP servers and to run a HTTP server.\n\nSample usage for getting the contents of an HTTP URI:\n\n    void getit(String uriAsString){\n        URI uri = parseURI(uriAsString);\n        Request request = uri.get();\n        Response response = request.execute();\n        print(response.contents);\n    }\n\nSample usage for running a HTTP server:\n    void runServer() {\n        //create a HTTP server\n        value server = createServer {\n            //an endpoint, on the path /hello\n            Endpoint {\n                path = startsWith(\"/hello\");\n                //handle requests to this path\n                service(Request request, Response response) =>\n                        response.writeString(\"hello world\");\n            },\n            WebSocketEndpoint {\n                path = startsWith(\"/websocket\");\n                onOpen = void (WebSocketChannel channel) { print(\"server: Channel opened.\"); };\n                onClose = void (WebSocketChannel channel, CloseReason closeReason) { print(\"server: Channel closed.\"); };\n                onError = void (WebSocketChannel webSocketChannel, Exception? throwable) {};\n                onText = void (WebSocketChannel channel, String text) {\n                    print(\"Server received:\");\n                    print(text);\n                    channel.sendText(text.uppercased);\n                };\n                onBinary = void (WebSocketChannel channel, ByteBuffer binary) {\n                    String data = utf8.decode(binary);\n                    print(\"Server received binary message:\");\n                    print(data);\n                    value encoded = utf8.encode(data.uppercased);\n                    channel.sendBinary(encoded);\n                };\n            }\n        };\n\n        //start the server on port 8080\n        server.start(8080);\n    }",
                       "license": "Apache Software License", 
                       "dependencies": [
                        {
                         "module": "ceylon.collection",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.file",
                         "version": "1.0.0",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "ceylon.io",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "io.undertow.core",
                         "version": "1.0.0.Beta20",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "org.jboss.xnio.api",
                         "version": "3.1.0.CR7",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "org.jboss.xnio.nio",
                         "version": "3.1.0.CR7",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.process",
                       "versions": [
                        "0.3.1", 
                        "0.3.2", 
                        "0.4", 
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Gavin King" 
                       ],
                       "doc": "API for running native commands in a child process.\nClients simply create `Process`es using the\n`createProcess()` method. The new process starts\nexecuting immediately.\n  \n    Process process = createProcess { \n        command = \"ls -l\";\n        path = home;\n    };\n  \nBy default, the standard input, output, and error \nstreams of the new child process are piped to and\nfrom the current process by exposing a `Writer` and\n`Reader`s.\n  \n    if (is Reader reader = process.output) {\n        while (exists line = reader.readLine()) {\n            print(line);\n        }\n    }\n  \nThe standard input, output, and error streams may be\nredirected by specifying an `Input` or `Output` to\n`createProcess()`.\n  \n    Process process = createProcess {\n        command = \"ls -l\";\n        path = home;\n        OverwriteFileOutput output { \n            path=home.childPath(\"out.txt\");\n        }\n        AppendFileOutput error { \n            path=home.childPath(\"err.txt\");\n        }\n    };\n  \nThe objects `currentInput`, `currentOutput`, and \n`currentError` allow the standard input, output, and \nerror streams to be redirected to the standard input, \noutput, and error streams of the current virtual\nmachine process.\n  \n    Process process = createProcess {\n        command = \"ls -l\";\n        path = home;\n        output = currentOutput;\n        error = currentError;\n    };\n  \nTo wait for the child process to terminate, call\nthe `waitForExit()` method of `Process`.",
                       "license": "", 
                       "dependencies": [
                        {
                         "module": "ceylon.file",
                         "version": "1.0.0",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        },  
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": false,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.test",
                       "versions": [
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Tomáš Hradec",  
                        "Tom Bentley" 
                       ],
                       "doc": "\nThe `ceylon.test` module is a simple framework to write repeatable tests.\n\nTests execute the code of the module under test and \ncan make assertions about what it does. For example,\n \n* do functions, when called with certain arguments, return the expected results?\n* do classes behave as required?\n* etc.\n\nThe usual way to use this module is to write your tests (which make\ncalls to the declarations under test) as top level functions or\nas methods of top level classes, annotating them with [[test]]. \n\nFor example, here is a trivial [[test]] function, which will always succeed.\n```\ntest\nvoid shouldAlwaysSucceed() {}\n```\n\nAssertions can be evaluated by using the language's `assert` statement \nor with the various `assert...` functions, for example:\n```\nassert(is Hobbit frodo);\nassert(exists ring);\n\nassertNotEquals(frodo, sauron);\nassertThatException(() => gandalf.castLightnings()).hasType(`NotEnoughMagicPowerException`);\n```\n\nIt's also perfectly acceptable to throw \n[[AssertionException]] directly.\n\nA test function which completes without propogating an exception is \nclassified as a [[success]]. A test function which propogates \nan [[AssertionException]] is classified as a [[failure]]. A test \nfunction which propogates any other type of `Exception` is classified as \nan [[error]].\n\nTest functions can be grouped together inside a class.\n```\nclass YodaTest() {\n\n    test void shouldBeJedi() {\n        assert(yoda is Jedi);\n    }\n\n    test void shouldHavePower() {\n        assert(yoda.midichloriansCount > 1k);\n    }\n```\n\nCommon initialization logic can be placed into separate functions, \nwhich run [[before|beforeTest]] or [[after|afterTest]] each test.\n```\nclass StarshipTest() {\n \n    beforeTest void init() => starship.chargePhasers();\n     \n    afterTest void dispose() => starship.shutdownSystems();\n```\n\nSometimes you want to temporarily disable a test or a group of tests, \nthis can be done via the [[ignore]] annotation.\n```\ntest\nignore(\"still not implemented\")\nvoid shouldBeFasterThanLight() {\n```\n\nTests can be run programmatically for a whole module, a package or only \nindividual classes and functions. This is usually achieved using the\n[[createTestRunner]] factory method, most simply by giving it the \ndeclaration of the module to be run:\n```\nvalue result = createTestRunner([`module com.acme`]).run();\nprint(result.isSuccess);\n```\nOr by enumerating the things to be tested:\n```\nvalue result = createTestRunner([\n        `shouldBeFasterThanLight`,\n        `StarshipTest`]).run();\nprint(result.isSuccess);\n```\n\nAlthough you can implement the [[TestRunner]] interface directly,\n[[createTestRunner]] has numerous defaulted parameters which usually \nmean you don't have to.\n \nUsing listeners you can react to important events during test execution, \nor you can exclude particular tests, or execute them in a specific order.\n```\nobject ringingListener satisfies TestListener {\n    shared actual void testError(TestResult result) => alarm.ring();\n}\n \nBoolean integrationTestFilter(TestDescription d) {\n    return d.name.endsWith(\"IntegrationTest\");\n}\n \nComparison failFastComparator(TestDescription d1, TestDescription d2) {\n    return dateOfLastFailure(d1) <=> dateOfLastFailure(d2);\n}\n \nTestRunner runner = createTestRunner{\n    sources = [`module com.acme`];\n    listeners = [ringingListener];\n    filter = integrationTestFilter;\n    comparator = failFastComparator;\n};\n```\n",
                       "license": "Apache Software License", 
                       "dependencies": [
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".js"
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.time",
                       "versions": [
                        "0.5", 
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Diego Coronel",  
                        "Roland Tepp" 
                       ],
                       "doc": "Date and Time library for Ceylon language SDK.\n\nThis library is loosely modeled/inspired by the JodaTime/JSR-310 date/time library.\n",
                       "license": "", 
                       "dependencies": [
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".js"
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      }, 
                      {
                       "module": "ceylon.unicode",
                       "versions": [
                        "0.6", 
                        "0.6.1", 
                        "1.0.0" 
                       ],
                       "authors": [
                        "Tom Bentley" 
                       ],
                       "doc": "A selection of utility methods for accessing Unicode information\nabout `Character`s.",
                       "license": "", 
                       "dependencies": [
                        {
                         "module": "java.base",
                         "version": "7",
                         "shared": true,
                         "optional": false,
                         "maven": false
                        } 
                       ],
                       "artifacts": [
                        {
                         "suffix": ".car",
                         "binaryMajorVersion": 6,
                         "binaryMinorVersion": 0
                        }, 
                        {
                         "suffix": ".src"
                        }
                       ]
                      } 
                     ]}
                     """;

shared test void testParse() {
    value o1 = parse("{}");
    assertEquals(0, o1.size);
    
    value o2 = parse("{\"foo\": \"bar\"}");
    assertEquals(1, o2.size);
    assertEquals("bar", o2["foo"]);
    
    value o3 = parse("{\"s\": \"bar\", \"t\": true, \"f\": false, \"n\": null}");
    assertEquals(4, o3.size);
    assertEquals("bar", o3["s"]);
    assertEquals(true, o3["t"]);
    assertEquals(false, o3["f"]);
    assertEquals(nil, o3["n"]);
    
    value o4 = parse("{\"i\": 12, \"f\": 12.34, \"ie\": 12e10, \"fe\": 12.34e10}");
    assertEquals(4, o4.size);
    assertEquals(12, o4["i"]);
    assertEquals(12.34, o4["f"]);
    assertEquals(12.0e10.integer, o4["ie"]);
    assertEquals(12.34e10, o4["fe"]);
    
    value o5 = parse("{\"i\": -12, \"f\": -12.34, \"ie\": -12e10, \"fe\": -12.34e10}");
    assertEquals(4, o5.size);
    assertEquals(-12, o5["i"]);
    assertEquals(-12.34, o5["f"]);
    assertEquals(-12.0e10.integer, o5["ie"]);
    assertEquals(-12.34e10, o5["fe"]);
    
    value o6 = parse("{\"ie\": 12E10, \"fe\": 12.34E10}");
    assertEquals(2, o6.size);
    assertEquals(12.0e10.integer, o6["ie"]);
    assertEquals(12.34e10, o6["fe"]);
    
    value o7 = parse("{\"ie\": 12e+10, \"fe\": 12.34e+10}");
    assertEquals(2, o7.size);
    assertEquals(12.0e10.integer, o7["ie"]);
    assertEquals(12.34e10, o7["fe"]);
    
    value o8 = parse("{\"ie\": 12e-10, \"fe\": 12.34e-10}");
    assertEquals(2, o8.size);
    assertEquals(12.0e-10, o8["ie"]);
    assertEquals(12.34e-10, o8["fe"]);
    
    value o9 = parse("{\"s\": \"escapes \\\\ \\\" \\/ \\b \\f \\t \\n \\r \\u0053 \\u3042\"}");
    assertEquals(1, o9.size);
    assertEquals("escapes \\ \" / \b \f \t \n \r \{#0053} \{#3042}", o9["s"]);
    
    value o10 = parse("{\"obj\": {\"gee\": \"bar\"}}");
    assertEquals(1, o10.size);
    if(is Object obj = o10["obj"]){
        assertEquals("bar", obj["gee"]);
    }else{
        fail();
    }
    
    value o11 = parse("{\"arr\": [1, 2, 3]}");
    assertEquals(1, o11.size);
    if(is Array arr = o11["arr"]){
        assertEquals(3, arr.size);
        assertEquals(1, arr[0]);
        assertEquals(2, arr[1]);
        assertEquals(3, arr[2]);
    }else{
        fail();
    }
    
    value o12 = parse("{\"svn_url\":\"https://github.com/ceylon/ceylon-compiler\",\"has_downloads\":true,\"homepage\":\"http://ceylon-lang.org\",\"mirror_url\":null,\"has_issues\":true,\"updated_at\":\"2012-04-11T10:20:59Z\",\"forks\":22,\"clone_url\":\"https://github.com/ceylon/ceylon-compiler.git\",\"ssh_url\":\"git@github.com:ceylon/ceylon-compiler.git\",\"html_url\":\"https://github.com/ceylon/ceylon-compiler\",\"language\":\"Java\",\"organization\":{\"gravatar_id\":\"a38479e9dc888f68fb6911d4ce05d7cc\",\"url\":\"https://api.github.com/users/ceylon\",\"avatar_url\":\"https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png\",\"id\":579261,\"login\":\"ceylon\"},\"has_wiki\":true,\"fork\":false,\"git_url\":\"git://github.com/ceylon/ceylon-compiler.git\",\"created_at\":\"2011-01-24T14:25:50Z\",\"url\":\"https://api.github.com/repos/ceylon/ceylon-compiler\",\"size\":2413,\"private\":false,\"open_issues\":81,\"description\":\"Ceylon compiler (ceylonc: Java backend), Ceylon documentation generator (ceylond) and Ceylon ant tasks.\",\"owner\":{\"gravatar_id\":\"a38479e9dc888f68fb6911d4ce05d7cc\",\"url\":\"https://api.github.com/users/ceylon\",\"avatar_url\":\"https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png\",\"id\":579261,\"login\":\"ceylon\"},\"name\":\"ceylon-compiler\",\"watchers\":74,\"pushed_at\":\"2012-04-11T07:43:33Z\",\"id\":1287859}");
    assertEquals(26, o12.size);
    assertEquals("https://github.com/ceylon/ceylon-compiler.git", o12["clone_url"]);
    assertEquals("2011-01-24T14:25:50Z", o12["created_at"]);
	assertEquals("Ceylon compiler (ceylonc: Java backend), Ceylon documentation generator (ceylond) and Ceylon ant tasks.", o12["description"]);
    assertEquals(false, o12["fork"]);
    assertEquals(22, o12["forks"]);
	assertEquals("git://github.com/ceylon/ceylon-compiler.git", o12["git_url"]);
	assertEquals(true, o12["has_downloads"]);
    assertEquals(true, o12["has_issues"]);
    assertEquals(true, o12["has_wiki"]);
	assertEquals("http://ceylon-lang.org", o12["homepage"]);
	assertEquals("https://github.com/ceylon/ceylon-compiler", o12["html_url"]);
    assertEquals(1287859, o12["id"]);
	assertEquals("Java", o12["language"]);
    assertEquals(nil, o12["mirror_url"]);
	assertEquals("ceylon-compiler", o12["name"]);
    assertEquals(81, o12["open_issues"]);
    if(is Object org = o12["organization"]){
        assertEquals(5, org.size);
        assertEquals("https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png", org["avatar_url"]);
        assertEquals("a38479e9dc888f68fb6911d4ce05d7cc", org["gravatar_id"]);
        assertEquals(579261, org["id"]);
        assertEquals("ceylon", org["login"]);
        assertEquals("https://api.github.com/users/ceylon", org["url"]);
    }
    if(is Object owner = o12["owner"]){
        assertEquals(5, owner.size);
        assertEquals("https://secure.gravatar.com/avatar/a38479e9dc888f68fb6911d4ce05d7cc?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-orgs.png", owner["avatar_url"]);
        assertEquals("a38479e9dc888f68fb6911d4ce05d7cc", owner["gravatar_id"]);
        assertEquals(579261, owner["id"]);
        assertEquals("ceylon", owner["login"]);
        assertEquals("https://api.github.com/users/ceylon", owner["url"]);
    }
    assertEquals(false, o12["private"]);
	assertEquals("2012-04-11T07:43:33Z", o12["pushed_at"]);
	assertEquals(2413, o12["size"]);
	assertEquals("git@github.com:ceylon/ceylon-compiler.git", o12["ssh_url"]);
    assertEquals("https://github.com/ceylon/ceylon-compiler", o12["svn_url"]);
    assertEquals("2012-04-11T10:20:59Z", o12["updated_at"]);
    assertEquals("https://api.github.com/repos/ceylon/ceylon-compiler", o12["url"]);
    assertEquals(74, o12["watchers"]);
    
    value o13 = parseArray("[]");
    assertEquals(0, o13.size);
    
    value o14 = parseObjectOrArray("[]");
    assertEquals(0, o14.size);
    
    value o15 = parseObjectOrArray("{}");
    assertEquals(0, o15.size);

    // make sure this passes
    parse(herdJson);
    
    try{
        parse("""{
                 key: 1
                 }""");
        assert(false);
    }catch(Exception x){
        assert(is ParseException x);
        assert(x.message == """Expected " but got k at 2:1 (line:column)""");
        assert(x.line == 2);
        assert(x.column == 1);
    }

    try{
        parse("""{
                 "key": val
                 }""");
        assert(false);
    }catch(Exception x){
        assert(is ParseException x);
        assert(x.message == """Invalid value: expecting object, array, string, number, true, false, null but got v at 2:8 (line:column)""");
        assert(x.line == 2);
        assert(x.column == 8);
    }
}
