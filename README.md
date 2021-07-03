# IncrementalSearch

### Environment

Xcode 12.5, deployment target 14.5, written in Swift

### Overview

This is a project trying to implement incremental search for Github repositories based on MVVM architecture. The UI mimics the search page design used in iOS App Store (embedding the search bar in the navigation bar).

### Function
1. The tableview below search bar will show the current search results (by default, 30 items)
2. A throttling function (delay 0.5 sec) is also implemented in `textDidChange` searchbar delegate method to prevent calling API too frequently. 
3. Error handling is implemented. For example, if there is no internet, the app will present the alert.
4. Tap the search result and the app will transit to a `SFSafariViewController` opening the link of the corresponding repository.
