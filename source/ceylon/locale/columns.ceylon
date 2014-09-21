{String?*} columns(String line) => line.split('|'.equals, true, false)
        .map(String.trimmed)
        .map((col) => !col.empty then col);