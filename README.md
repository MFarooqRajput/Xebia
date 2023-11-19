# Xebia

This is a demo  application that display weather information.

![Screen-Recording-2020-05-14-at-5](https://user-images.githubusercontent.com/21119818/81965122-ac316d00-9628-11ea-9b98-990951f785e1.gif)

# About the Xebia

This application uses https://openweathermap.org/ api to display weather of current location as well as user entered locations.

Current location is fetched using GPS and display
    
- Summary and Detailed weather

- Hourly forecast

- 5 Days forecast

For custom input user need to add comma seprated, minimum 3 and maximum 7 locations.

# Tech

- https://openweathermap.org/ api for weather data
- MVP Architecture
- Xcode 11.4.1
- Apple Swift version 5.2.2
- Only apple's default UI components like UICollectionView, UITableView
- No third party library is used.

# How to Run

- Download OR Use Git or checkout with SVN using the web URL. https://github.com/digitacs/Xebia.git
- Build
- Run

No Pods, Swift Package Manager OR anything else required.

# How to run Unit Test

To Run > Using the Test Navigator
When you hold the pointer over a bundle, class, or method name in the test navigator, a Run button appears. You can run one test, all the tests in a class, or all the tests in a bundle depending on where you hold the pointer in the test navigator list.

- To run all tests in a bundle, hold the pointer over the test bundle name and click the Run button that appears on the right.
- To run all tests in a class, hold the pointer over the class name and click the Run button that appears on the right.
- To run a single test, hold the pointer over the test name and click the Run button that appears on the right.

To Run > Using the Product Menu
Product > Test. Runs the currently active scheme. The keyboard shortcut is Command-U.


To view Coverage > In the reports navigator, you can view results output by test runs.
- Build
- Coverage
- Log

# Modules

There are in total 3 modules: Landing, Current Location's weather and Weather for End User's entered location. 
