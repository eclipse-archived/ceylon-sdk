/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A selection of utility methods for accessing Unicode 
 information about `Character`s and performing locale-aware
 transformations on `String`s:
 
 - [[uppercase]] and [[lowercase]] change the case of a
   `String` according to the rules of a certain locale,
 - [[graphemes]], [[words]], and [[sentences]] allow 
   iteration of the Unicode graphemes, words, and sentences
   in a `String`, according to locale-specific rules,
 - [[characterName]] returns the Unicode character name of
   a character, and
 - [[generalCategory]] and [[directionality]] return the
   Unicode general category and directionality of a 
   `Character`."
by("Tom Bentley")
native("jvm")
module ceylon.unicode maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import java.base "7";
}
