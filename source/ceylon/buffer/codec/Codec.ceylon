shared interface Codec {
    "A list of common names. The first alias is [[name]]."
    shared formal [String+] aliases;
    "The alias most commonly used for this codec, or otherwise specified by a
     standard."
    shared String name => aliases.first;
    
    "Estimate an initial output buffer size that balances memory conservation
     with the risk of a resize for encoding operations."
    shared formal Integer averageEncodeSize(Integer inputSize);
    "Determine the largest size an encoding output buffer needs to be."
    shared formal Integer maximumEncodeSize(Integer inputSize);
    "Estimate an initial output buffer size that balances memory conservation
     with the risk of a resize for decoding operations."
    shared formal Integer averageDecodeSize(Integer inputSize);
    "Determine the largest size an decoding output buffer needs to be."
    shared formal Integer maximumDecodeSize(Integer inputSize);
}
