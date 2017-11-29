/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""Representation of JSON data as [[events|Event]] pulled from an [[Iterator]].
   
   [[StreamParser]] produces events according to JSON data read from 
   a [[ceylon.json::Tokenizer]].
   
   [[errorReporting]] adapts an Iterator so that exceptions thrown 
   while iterating are *returned from* the iterator, rather 
   than *propagating from* it.
   
   [[streamToVisitor]] provides a bridge between producers of events 
   (in the form of `Iterator`s) and consumers of those events (in the form 
   of a [[ceylon.json::Visitor]].
   
   [[StreamingVisitor]] provides a bridge in the reverse direction. 
   It can be used to produce events by 
   [[visiting|ceylon.json::visit]] a [[ceylon.json::Value]]."""
shared package ceylon.json.stream;