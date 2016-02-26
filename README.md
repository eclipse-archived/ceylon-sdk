[![Build Status](https://ci-ceylon.rhcloud.com/buildStatus/icon?job=ceylon-sdk)](https://ci-ceylon.rhcloud.com/job/ceylon-sdk/)

# Ceylon SDK

This repository contains the Ceylon SDK.

The module minor.major version aligns with the Ceylon distribution minor.major
version that we use to compile/distribute them. The micro version of each module
can be incremented as needed between Ceylon distribution releases.

Build the compiler and tools
----------------------------

For setting up the development environment and compiling and building the distribution
take a look at [ceylon-dist](https://github.com/ceylon/ceylon-dist#ceylon-distribution).

If after having built the distribution you want to build and test the SDK
return to `ceylon-sdk` and run 

    ant clean publish
    
To run the tests type

    ant test

## License

The content of this repository is released under the ASL v2.0
as provided in the LICENSE file that accompanied this code.

By submitting a "pull request" or otherwise contributing to this repository, you
agree to license your contribution under the license mentioned above.
