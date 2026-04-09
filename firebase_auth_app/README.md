# Firebase Authentication in Flutter

This project is a Flutter app that uses Firebase Authentication with Email/Password sign in.

## Features
- Register a new user with email and password
- Sign in with an existing account
- Sign out from the profile screen
- Display the current user's email
- Update the current user's password
- Validate email format
- Validate password length of at least 6 characters

## Files
- `main.dart` initializes Firebase and launches the app
- `auth_service.dart` contains authentication logic
- `authentication_screen.dart` contains register and sign in UI
- `profile_screen.dart` contains current user email, logout, and password update UI

## Validation
- Email must include `@`
- Password must be at least 6 characters long

## Testing Completed
- Valid register
- Invalid email check
- Short password check
- Valid sign in
- Logout flow
- Password update flow
- Sign in again with updated password