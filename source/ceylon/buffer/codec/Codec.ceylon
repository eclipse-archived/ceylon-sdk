shared interface Codec {
    shared formal [String+] aliases;
    shared default String name => aliases.first;
    
    shared formal Integer minimumForwardRatio;
    shared formal Integer maximumForwardRatio;
    shared default Integer averageForwardRatio
            => (minimumForwardRatio + maximumForwardRatio) / 2;
}
