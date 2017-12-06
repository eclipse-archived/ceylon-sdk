/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A [[ParseException]] that may be thrown by [[parseToml]]."
shared class TomlParseException(
        "A list of parse errors"
        shared [String+] errors,
        "A [[TomlTable]] representing the parsable portions of the input document"
        shared TomlTable partialResult)
        extends ParseException("``errors.first`` (``errors.size`` total errors)") {}
