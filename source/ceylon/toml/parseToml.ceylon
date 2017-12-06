/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.toml.parser {
    parse
}

"Parse a TOML document."
throws(`class TomlParseException`, "If the input cannot be parsed")
shared TomlTable | TomlParseException parseToml({Character*} input) {
    let ([result, *errors] = parse(input));
    if (nonempty errors) {
        return TomlParseException(errors.collect(Exception.message), result);
    }
    return result;
}
