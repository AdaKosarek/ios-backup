# StudySync – Flashcards for iOS & watchOS

StudySync is a cross-platform flashcards learning application for iOS and Apple Watch.  
It helps users study efficiently by organizing cards into packages and groups, tracking progress, and enabling quick content import via QR codes.

## Goal
The goal of this project was to practice modern Apple ecosystem development, including local persistence, cross-device communication, data serialization, notifications, and automated testing.

## Features
- Create and manage flashcard packages
- Groups and cards organization
- Study sessions with progress tracking
- QR code import of entire packages
- JSON serialization for data transfer
- Local data persistence with SwiftData
- iPhone ↔ Apple Watch synchronization
- Notifications and reminders
- Unit and UI tests

## How it works
1. Flashcard packages are created or imported via QR code.
2. Data is serialized/deserialized using JSON.
3. Content is stored locally using SwiftData.
4. Study sessions run on both iPhone and Apple Watch.
5. Progress and statistics are synchronized between devices.
6. Notifications help maintain learning streaks.

## Tech stack
- SwiftData
- WatchConnectivity
- JSON serialization
- QR code scanning
- Local notifications
- XCTest (unit + UI testing)

## Purpose
This project serves as an academic and practical exercise to simulate a real-world learning application built with modern Apple technologies.
