/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""
   The `ceylon.html` module contains HTML5 templating engine:
   
   - with an elegant and type safe way of creating templates
   - witch works on both platforms, server (jvm) and client (js) 
   - based on named argument invocations syntax
   - supporting reusability of snippets and lazy evaluation
   
   ------------------------------------------------------------------
   
   #### CONTENT
   
   1. [What does it look like?](#what)
   1. [Basic usage](#basic)
   1. [Iteration](#iteration)
   1. [Conditions](#conditions)
   1. [Lazy evaluation](#lazy)
   1. [Reusable blocks and layouts](#layout)
   
   ------------------------------------------------------------------
   
   #### <a name="what"></a> WHAT DOES IT LOOK LIKE?
   
   A quick preview shows code example, which starts HTTP server, see module `ceylon.http.server`, 
   and on each request returns simple HTML5 document with obligatory greeting. Note that 
   the module is not tied with any web framework, it can be used anywhere.
   
   ```
   value server = newServer {
       Endpoint {
           path = startsWith("/");
           service = (req, res) {
               renderTemplate(
                   Html {
                       Body {
                           H1 { "Hello `` req.queryParameter("name") else "World" `` !" }
                       }
                   },
                   res.writeString);
           };
       }
   };
   server.start();
   ```
   
   ------------------------------------------------------------------
   
   #### <a name="basic"></a> BASIC USAGE
   
   The module contains HTML elements, which can be composed together into template. 
   The element has attributes and content (usually other elements or text data).
   Each element can belong to predefined content category (eg. flow, phrasing, metadata, ...). 
   Those categories are then used to specifying permitted element's children.
   During rendering of template is applied automatic escaping of all potentially unsafe data.
   
   Let's look on more complicated example, below is template with login form 
   and with a preview of generated HTML in the second half.
      
   <table style='width:100%'>
     <tr style='vertical-align: top'>
         <td style='width:50%'>
         
   <pre data-language='ceylon'>
   Html {
       Head {
           Title { "Login" },
           Link { href = "/resources/style.css"; rel = "stylesheet"; }
       },
       Body {
           Form { clazz = "login-form"; autocomplete = true;
               H1 { "Login" },
               Label { "Name", 
                   Input { id = "name"; type = InputType.text; } 
               },
               Label { "Password",
                   Input { id = "pswd"; type = InputType.password; }
               },
               Button { type = ButtonType.submit; "Sign in" }
           }
       }
   }
   </pre>
   
         </td>
         <td>
         
   <pre data-language='html'>
   
   &lt;!DOCTYPE html&gt;
   &lt;html&gt;
       &lt;head&gt;
           &lt;title&gt;Login&lt;/title&gt;
           &lt;link href="/resources/style.css" rel="stylesheet"&gt;
       &lt;/head&gt;
       &lt;body&gt;
           &lt;form class="login-form" autocomplete="on"&gt;
               &lt;h1&gt;Login&lt;/h1&gt;
               &lt;label&gt;Name
                   &lt;input id="name" type="text"&gt;
               &lt;/label&gt;
               &lt;label&gt;Password
                   &lt;input id="pswd" type="password"&gt;
               &lt;/label&gt;
               &lt;button type="submit"&gt;Sign in&lt;/button&gt;
           &lt;/form&gt;
       &lt;/body&gt;
   &lt;/html&gt;
   
   </pre>
   
         </td>         
     </tr>
   </table>
   
   ------------------------------------------------------------------
   
   #### <a name="iteration"></a> ITERATION
   
   A _comprehension_ comes handy for iterating over several items and applying 
   filtering and transformation. For example, this snippet use comprehension 
   for transforming list of super-heroes into table rows, with three cells.
   
   <table style='width:100%'>
     <tr style='vertical-align: top'>
         <td style='width:50%'>
         
   <pre data-language='ceylon'>
   Table {
       for(i->superhero in superheroes.indexed)
           Tr {
               Td { "#``i``" },
               Td { superhero.nickname },
               Td { superhero.powers }
           }
   };
   </pre>
   
         </td>
         <td>
         
   <pre data-language='html'>
   &lt;table&gt;
       &lt;tr&gt;
           &lt;td&gt;#1&lt;/td&gt;
           &lt;td&gt;Wolverine&lt;/td&gt;
           &lt;td&gt;regeneration&lt;/td&gt;
       &lt;/tr&gt;
       &lt;tr&gt;
           &lt;td&gt;#2&lt;/td&gt;
           &lt;td&gt;Dr. Manhattan&lt;/td&gt;
           &lt;td&gt;subatomic manipulation&lt;/td&gt;
       &lt;/tr&gt;
       ...
   &lt;/table&gt;
   </pre>
   
         </td>         
     </tr>
   </table>
   
   Alternatively it is possible to use full power of _streams_ API. For example, 
   this snippet contains names of top ten bad guys and use sorting, filtering 
   and final transformation into list element.
   
   <table style='width:100%'>
     <tr style='vertical-align: top'>
         <td style='width:50%'>
         
   <pre data-language='ceylon'>
   Ul {
       badGuys.sort(decreasing).take(10).map((badGuy) =>
           Li { badGuy.name })
   };
   </pre>
   
         </td>
         <td>
         
   <pre data-language='html'>
   &lt;ul&gt;
       &lt;li&gt;Ultron&lt;/li&gt;
       &lt;li&gt;Red Skull&lt;/li&gt;
       &lt;li&gt;Green Goblin&lt;/li&gt;
       ...
   &lt;/ul&gt;
   </pre>
   
         </td>         
     </tr>
   </table>
   
   ------------------------------------------------------------------
   
   #### <a name="conditions"></a> CONDITIONS
   
   Sometimes a fragment of template or attribute value depends on a certain 
   conditions. In that cases is possible to use _then_/_else_ operator 
   
   ```
   Div {
       user.isAdmin then Button { "Delete" }
   }
   ```
   
   or _if_ expression
   
   ```
   Div {
       if (exists user, user.isAdmin) then
           Button { "Delete" }
       else
           Span { "No permission" }
   }
   ```
   
   or _switch_ expression
   
   ```
   Span {
       switch (n)
           case (0) "zero"
           case (1) "one"
           else "many"
   }
   ```
   
   ------------------------------------------------------------------
   
   #### <a name="lazy"></a> LAZY EVALUATION
   
   One possible supported scenarios is _lazy evaluation_ of templates, which 
   allows to create template once, hold its instance, but render it each time 
   with actual data.
   
   This is automatically supported with usage of comprehensions (where elements 
   of resulting iterable are evaluated lazily) or with usage of lazy operations 
   over streams (eg. map method produce lazy view).    
   In the example, the output of print function, for the first time (1), will be 
   list with two items, but list with four items in the second evaluation (2).
   
   ```
   value todoList = ArrayList<String>();
   todoList.add("wake up");
   todoList.add("make coffe");
   
   value todoSnippet = Ul {
       for(todo in todoList)
           Li { todo } 
   };
   print(todoSnippet); // 1.
   
   todoList.add("drink coffe")
   todoList.add("make more coffe")
   
   print(todoSnippet); // 2.
   ```
   
   Another option is to pass no-arg function, returning desired value, instead of 
   value itself. For example this div element, will be hidden, depending on 
   user configuration.
   
   ```
   Div { 
       id = "preview"; 
       hidden = () => !userConfig.showPreview;
       ...
   }
   ```
   
   ------------------------------------------------------------------
   
   #### <a name="layout"></a> REUSABLE BLOCKS and LAYOUTS
   
   Template fragments can be super-easily encapsulated and reused, which safes 
   our fingers and increase readability. If needed, they can be naturally parameterized. 
   Compare this example, form with several input fields and its counterpart.
   
   <table style='width:100%'>
     <tr style='vertical-align: top'>
         <td style='width:50%'>
         
   <pre data-language='ceylon' style='margin-bottom:2px'>
   value form = Form {
       input("firstname", "First name"),
       input("lastname", "Last name"),
       input("phone", "Phone", InputType.phone),
       input("email", "E-mail", InputType.email)
   };
   </pre>
   
   <pre data-language='ceylon'>
   Div input(String id, String label, InputType type=InputType.text) =>
       Div { clazz="form-group";
           Label { forElement = id; label },
           Input { id = id; clazz="form-control"; type=type; }
       };
   </pre>
   
         </td>
         <td>
         
   <pre data-language='html'>
   &lt;form&gt;
       &lt;div class="form-group"&gt;
           &lt;label for="firstname"&gt;First name&lt;/label&gt;
           &lt;input id="firstname" class="form-control" type="text"&gt;
       &lt;/div&gt;
       &lt;div class="form-group"&gt;
           &lt;label for="lastname"&gt;Last name&lt;/label&gt;
           &lt;input id="lastname" class="form-control" type="text"&gt;
       &lt;/div&gt;
       &lt;div class="form-group"&gt;
           &lt;label for="phone"&gt;Phone&lt;/label&gt;
           &lt;input id="phone" class="form-control" type="tel"&gt;
       &lt;/div&gt;
       &lt;div class="form-group"&gt;
           &lt;label for="email"&gt;E-mail&lt;/label&gt;
           &lt;input id="email" class="form-control" type="email"&gt;
       &lt;/div&gt;
   &lt;/form&gt;   
   </pre>
   
         </td>         
     </tr>
     
   </table>
   
   This can be easily used as mechanism for defining common layout for all 
   pages in web application, as sketched in following example.
   
   ```
   Html myHtml(Content<FlowCategory> content) =>
       Html {
           Head {
               Title { "MyApp" },
               Meta { charset="utf-8"; },
               Link { href = "/resources/style.css"; rel = "stylesheet"; }
           },
           Body {
               Div { clazz="content";
                   content
               },
               Div { clazz="footer";
                   "All Rights Reserved."
               }
           }
       };
   ```
   
   Then the page is created as...
   
   ```
   myHtml({
       H1 { "Welcome in MyApp!" },
       Div {
           ...    
       }
   })   
   ```
   
   ------------------------------------------------------------------
   
   
"""
by("Tomáš Hradec", "John Vasileff", "Daniel Rochetti")
suppressWarnings("ceylonNamespace")
label("Ceylon HTML Templating Framework")
module ceylon.html maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {}
