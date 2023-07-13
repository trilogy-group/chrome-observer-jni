This project requires at least make version 3.25 and Xcode 14.3 with Command Line Tools, as this is an Objective-C++ project.

The JNI headers and libraries are from the MacOS x86_64 Java 8 Amazon Corretto distribution.

The library is built on a Mac mini M2 with the x86_64 architecture to be used on Java x86_64 runtimes, so this will not work for arm64 Java installations. **This will require Rosetta on arm64.**

Run these commands to build the library:

```
mkdir build
cd build
cmake ..
make
make install
```
The make install command will move the compiled dylib library to the lib directory.