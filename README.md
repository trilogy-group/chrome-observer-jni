This is a MacOS Java PoC console application that, through JNI, observes the Google Chrome app for changes in windows and tabs when the app is selected and obtains the current Window or tab title and URL.

The library is built on a Mac mini M2 with the x86_64 architecture to be used on Java x86_64 runtimes, so this will not work for arm64 Java installations. **This will require Rosetta on arm64.**

The app dynamic library is in the ./chrome-observer/lib folder.

This app uses maven and you need to set the path to where the dynamic library resides, so first compile the java app, then add the following VM options, either through the IDE if being debugged, or through the mvn command in the terminal:

```
-Dexec.mainClass="com.crossover.App" -Djava.library.path=/ABSOLUTE_PATH_TO_PROJECT/chrome-observer/lib
```
