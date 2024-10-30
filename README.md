# ComicsApp

Collaborators: Marcos Aldana, Yanelys Velarde, Kevin Sanchez

## Project Overview

**ComicsApp** is a mobile app designed to help users easily browse and keep up with trending manga and comics. In today’s world of diverse entertainment options, finding new titles and tracking favorites can be overwhelming. ComicsApp simplifies this process by allowing users to explore trending manga and comics, bookmark favorites, and keep track of their reading progress.

## Development Tools

The app was built with the following technologies:
- **Swift**: For developing a responsive and native iOS experience.
- **Firebase**: For user authentication, enabling secure sign-in and sign-up.
- **MangaReader API**: Used to fetch manga and comic information, including trending titles and search results ([MangaReader API](https://mangareader-api.vercel.app/)).

## Team Collaboration

Each collaborator contributed unique components to enhance the app's functionality and user experience:

- **Marcos Aldana**: Integrated the MangaReader API, providing the search functionality to retrieve manga and comic data.
- **Yanelys Velarde**: Developed the bookmark management feature and ensured smooth overall app functionality.
- **Kevin Sanchez**: Implemented Firebase for user authentication, handling both the login and sign-up processes.

## Features

ComicsApp offers the following features:
- **Trending Titles**: Explore the most popular and trending manga and comics in real-time.
- **Search**: Find specific manga or comic titles by keyword or genre using the [MangaReader API](https://mangareader-api.vercel.app/).
- **Bookmarking**: Users can bookmark their favorite manga and comics to easily access them later.
- **User Authentication**: Secure login and registration through Firebase, ensuring each user’s bookmarks and preferences are saved.


## Requirements to Run

To run ComicsApp on your device, make sure you meet the following requirements:

1. **Operating System**: macOS or an iOS device (iPhone/iPad).
2. **Xcode**: Install Xcode on macOS to build and run the app. Xcode 12 or later is recommended.
3. **Swift**: Ensure that Swift 5 is enabled in Xcode for compatibility.
4. **Firebase Setup**: Connect your Firebase project for user authentication:
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Enable **Authentication** and download the `GoogleService-Info.plist` file, then add it to your Xcode project.

### Setup and Run

 **Clone the repository** and open the project in Xcode.

