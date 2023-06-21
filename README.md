## Incomptaible Package Checker

Incompatible Package Checker for Flutter  The Incompatible Package Checker for Flutter is a useful tool for Flutter developers. This plugin scans your Flutter project for any incompatible packages or dependencies that may cause conflicts or errors during runtime.

## Getting Started

- Add the dependency to your pubspec.yml file
  ```
  dependencies:
    incompatible_package_checker: ^1.0.0+1
    
    ```
## Usage

- Use Pub global to activate the dependency
    ` dart pub global activate incompatible_package_checker `

- Now check the run command to see the output

  ` dart run incompatible_package_checker `

  

##  Note: by default,All the platforms(Android, iOS, Windows,Linux,MacOS,Web) will be considered and result will be available for all platforms but in case you want only for specific platforms then pass values in command arguments.

**For Example**
 ``` 
 dart run incompatible_package_checker android,ios,web 
 
 ```
# Output
![output](https://raw.githubusercontent.com/Djsmk123/incompatible_package_checker_flutter/main/assets/ouput.png)
 # Available platforms
- For Android : `android`
- For iOS : `ios`
- For Windows : `windows`
- For Web : `web`
- for Mac OS : `macos`
- For Linux : `linux`


