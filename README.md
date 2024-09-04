# CatsApp

Given challenge: [iOSdeveloperchallengeMid_Seniorv2.pdf](https://github.com/user-attachments/files/16874902/iOSdeveloperchallengeMid_Seniorv2.pdf)

![catapp](https://github.com/user-attachments/assets/efb2d118-3fb4-4145-b96b-843f60fb9a93)


## Implemented Key Requirements
- [X] iPhone and iPad oriented app
- [X] Display Cats API Data
- [X] Networking layer using Combine Framework
- [X] TabBar with Cats list and Favorites views
- [X] Cats List and Favorites views: Swift and UIKit with auto layout
- [X] UICollectionViewCompositionalLayout and UICollectionViewDiffableDataSource
- [X] Details view: SwiftUI 
- [X] Clean Architecture with MVVM
- [X] Offline functionality: CoreData to store all the breeds
- [X] SOLID Principles
- [X] Modular Design
- [X] Error Handling: Displaying error dialog in case some network API error with retry option
- [X] Unit tests

### Discrepancies in the Response
1) Not matching data:
- Issue: The expected object from GET /breeds<br>

![image](https://github.com/user-attachments/assets/2443dd7a-5180-4035-ad7c-224c84313590)

- Expected: "image" object should contain the url to get the breed image, but for some reason, the image object was always nil.

### My Solution
A breed object have a reference image ID, so what I did was call GET /images/{imageID} for each breed to get and use that image.

## Architecture
**MAKE IT WORK, MAKE IT PERFECT**<br>
I followed <ins>**clean architecture**</ins> principles by focusing on separation of concerns, dependency inversion, and keeping core logic independent of external frameworks. This methodology ensures that each layer functions independently, making the project robust, maintainable, flexible, and scalable. Additionally, this approach simplifies the testing of implemented features and facilitates the integration of new ones.

## Tests
F.I.R.S.T Principles of testing:<br>
- Fast
- Isolated/Independent
- Repeatable
- Self-validating
- Thorough

By following the F.I.R.S.T Principles we can establish a robust testing framework that improves code quality, speeds up development, and ensures a smooth, reliable user experience. Additionally, this approach helps prevent bugs from emerging during change requests.

### Thanks for reviewing my challenge, I am open to any suggestion and to improve! :)
