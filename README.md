# InterestingNumbersLibrary

InterestingNumbersLibrary is a Swift Package that fetches interesting number facts from the Numbers API.

## Overview

The main class, `NumbersManager`, is responsible for fetching facts about numbers. The fetched facts can either be a single fact about a number or multiple facts about different numbers. These facts are returned as a dictionary where the keys are the numbers and the values are the facts.

## How to Use

### Setup

Import the package to your project:

```swift
import InterestingNumbersLibrary
```

Instantiate the `NumbersManager` class:

```swift
let numbersManager = NumbersManager()
```

Set the delegate to receive the fetched facts or errors:

```swift
numbersManager.delegate = self
```

Your class needs to conform to the `NumbersManagerDelegate` protocol:

```swift
extension YourClass: NumbersManagerDelegate {
    func didUpdateNumberFacts(_ manager: NumbersManager, facts: [String: String]) {
        // Handle the fetched facts
    }

    func didFailWithError(error: Error) {
        // Handle the error
    }
}
```

### Fetch Facts

To fetch a single fact about a number:

```swift
numbersManager.isParseOneFact = true
numbersManager.userInputNumber = "10"
numbersManager.fetchFacts(numbers: "10")
```

To fetch multiple facts:

```swift
numbersManager.isParseOneFact = false
numbersManager.fetchFacts(numbers: "1..3")
```

## Testing

The library also includes a dependency injection feature for testing purposes. You can initialize the `NumbersManager` with a custom `URLSession`:

```swift
let mockSession = URLSession(configuration: .ephemeral)
let numbersManager = NumbersManager(session: mockSession)
```

## Contributions

Contributions are welcome. Please open a pull request with your changes.

## License

This project is open-source and available under the MIT license.

## Important

Please note that the Numbers API might have rate limits. Check the [Numbers API documentation](http://numbersapi.com/) for more information.
