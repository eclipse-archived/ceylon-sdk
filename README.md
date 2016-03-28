[![Build Status](https://ci-ceylon.rhcloud.com/buildStatus/icon?job=ceylon-sdk)](https://ci-ceylon.rhcloud.com/job/ceylon-sdk/)

# Ceylon SDK

This repository contains the Ceylon SDK.

The module minor.major version aligns with the Ceylon distribution minor.major
version that we use to compile/distribute them. The micro version of each module
can be incremented as needed between Ceylon distribution releases.

### Build the compiler and tools

In many cases to be able to build the SDK from the `master` branch you will also need
the very latest Ceylon distribution from its `master` branch. For setting up the
development environment and compiling and building the latest Ceylon distribution
take a look at [ceylon](https://github.com/ceylon/ceylon/tree/master/dist#ceylon-distribution).

If after having built the distribution you want to build and test the SDK
return to this project and follow the instructions in the [Build the SDK](#build-the-sdk) section.

### Build a specific version

If you would like to skip the above step about compiling and building Ceylon and you
would like to build the SDK using an officially released Ceylon distribution you have
already got installed then that is possible but you will have to check out the same
version of the SDK that came with the Ceylon release you are using, like this:

    git checkout VERSION
    
Where `VERSION` is the exact version of the Ceylon distribution you are running
(check this by running `ceylon --version` on the command line). After that you just
follow the instructions in the next section.

*NB: If you are doing this because you found a bug and are trying to fix it then first make
really sure that the bug wasn't fixed in the latest version of the code!*

### Build the SDK

In the root of this project run

    ant clean publish
    
To run the tests type

    ant test

## License

The content of this repository is released under the ASL v2.0
as provided in the LICENSE file that accompanied this code.

By submitting a "pull request" or otherwise contributing to this repository, you
agree to license your contribution under the license mentioned above.
