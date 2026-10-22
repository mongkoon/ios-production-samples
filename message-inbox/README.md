# Message Sample — iOS Production Engineering

A compact **SwiftUI messaging inbox** that demonstrates how I approach maintainable architecture, asynchronous state, correctness, and testability in iOS development.

> **Status:** Functional first iteration. A local demo using synthetic data — not a messaging service and not a reproduction of any employer's proprietary code.

## What this demonstrates

- **SwiftUI / iOS 17+:** inbox, conversation detail, native search, loading/empty/error states.
- **Modern state management:** `@Observable` view models isolated to `@MainActor`.
- **Async correctness:** `async/await`, cancellation-aware tasks, debounce, and epoch-based stale-result rejection.
- **Separation of concerns:** repository protocol, dependency injection, independently testable domain/presentation logic.
- **Deterministic verification:** actor-controlled test repository forces out-of-order completions and non-cooperative cancellation.

## Run the app

1. Open **`MessageSample.xcodeproj`** in Xcode 16 or later.
2. Choose the `MessageSample` scheme and an iOS 17+ simulator.
3. Build and Run (`⌘R`). No credentials, APIs, or external dependencies.

**Tests:** Open a terminal in this sample directory and run `swift test`. The portable `MessageCore` Swift package contains all non-UI code and its Swift Testing suites. Alternatively, open `Package.swift` in Xcode and run the package tests there.

## Project structure

```text
App/                               SwiftUI application and views
Sources/MessageCore/               domain types, repository and view models
Tests/MessageCoreTests/            deterministic behavior and repository tests
MessageSample.xcodeproj/           native Xcode iOS app project
Package.swift                      standalone MessageCore + Swift Testing
docs/architecture.md              architecture decisions and trade-offs
```

## Invariants under test

1. Search result B must not be overwritten by the older response A.
2. Failure from an obsolete request must not replace a successful current state.
3. An active request failure creates a user-visible retryable state.
4. A cancelled task must not publish late data, even if its repository ignores cancellation.

## Trade-offs and future work

The demo repository is deliberately in-memory. It avoids pretending that network operations, secure storage, message delivery, or paging are implemented. The next milestone can add a URLSession-backed adapter with injected transport, persisted caching, pagination and UI tests without changing the view models' public contract.

Read [architecture decisions](docs/architecture.md).

## Authorship and boundaries

An independent educational portfolio project. All conversations are fictional. No Kakao, Enuma, or other employer-owned source code is included.
