# TMDb

 Small project consuming [The Movie Database API](https://developers.themoviedb.org/3/search/search-movies) to show upcoming movies.
 This app was built using Swift 5 with deployment target 11.0.

### Project Dependancies:
* [SwiftLint](https://github.com/realm/SwiftLint) - Lint tool for Swift to help keep consistency while coding
* [CocoaPods-Keys](https://github.com/orta/cocoapods-keys) - Pod to keep API and other secrets hidden from code base and encoded


### Build Instructions:
* Make sure both dependencies are installed locally in your machine, to install follow the instructions in each repository or execute the following commands:
```sh
$ brew install swiftlint
$ gem install cocoapods-keys
```
* Run the pod installation command in the root directory:
```sh
$ pod install
```
* Insert the API key for TMDb when prompted after running the pod installation command.
