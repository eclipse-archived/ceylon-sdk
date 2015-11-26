shared interface Codec {
    shared formal [String+] aliases;
    shared default String name => aliases.first;
    
    shared formal Integer averageEncodeSize(Integer inputSize);
    shared formal Integer maximumEncodeSize(Integer inputSize);
    shared formal Integer averageDecodeSize(Integer inputSize);
    shared formal Integer maximumDecodeSize(Integer inputSize);
}
