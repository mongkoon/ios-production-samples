# Architecture Decisions

## Scope

The sample intentionally does not implement a backend, login, persistence, or chat sending. Its purpose is to demonstrate production-minded **read-side UI architecture**, observability, and predictable async state handling.

## Components

```text
SwiftUI Views
  ↓ UI actions / observation
@MainActor @Observable View Models
  ↓ calls protocol abstraction
ConversationRepository: Sendable
  ↓ injected implementation
DemoConversationRepository  (replaceable with a real network adapter)
```

- **View layer:** presentation only; owns `.task(id:)` and SwiftUI search binding.
- **View models:** main actor ownership of UI state, epochs prevent obsolete updates.
- **Repository contract:** `Sendable` protocol; supports dependency injection.
- **Demo adapter:** synthetic data, network-like delays, cooperative cancellation.
- **Testing:** a manually controlled actor forces adverse completion order without real-time sleeps.

## Search cancellation and stale-response protection

1. Search text changes and synchronously invalidates the previous request with an epoch increment.
2. SwiftUI cancels the old `.task(id:)` and debounces the new one by 250 ms.
3. The new load records its epoch before awaiting the repository.
4. The model commits results only when the task is not cancelled **and** its epoch is still current.
5. Cancellation is not rendered as an error; a genuinely failed latest request produces a retryable error.

Why use both cancellation and epoch validation? Cancellation in Swift is cooperative. A callback-based or third-party API can ignore it and return a late value. Epoch validation is an independent UI correctness invariant.

## Limits and next iterations

- Search results are fetched from mock data, not a real server.
- There is no local persistence or paging.
- Automated tests focus on the core behavior; UI automation and accessibility audits are planned.
- The project's `.xcodeproj` links the same core files that `Package.swift` compiles independently so app and SwiftPM tests stay consistent.
