# DevSearch

DevSearch is a small SwiftUI app for searching GitHub users and viewing their public repositories.

## Features

- Search GitHub users by username
- View user profile information
- View public repositories sorted by stars
- Add and remove users from Favorites
- Save favorite users locally with UserDefaults
- Loading, empty, success and error states
- Improved profile and repository card UI
- Pull to refresh on profile screen
- Haptic feedback when adding/removing favorites
- Recent search history

## Tech Stack

- Swift
- SwiftUI
- MVVM
- URLSession
- async/await
- Decodable
- UserDefaults
- GitHub REST API

## Architecture

The project uses a simple MVVM structure:

- `Views` display UI and react to state changes
- `ViewModels` handle screen state and business logic
- `Services` handle API requests
- `Models` describe GitHub API response objects
- `Storage` handles local persistence with UserDefaults
- `Utils` contains shared helper types like `ViewState`

## Requirements

- iOS 16+
- Xcode 15+
