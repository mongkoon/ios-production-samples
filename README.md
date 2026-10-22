# iOS Production Samples

[**English**](README.md) | [한국어](README.ko.md)

A portfolio of **small, independently runnable iOS applications** focused on maintainable architecture, correct asynchronous behavior, and reproducible testing.

The goal is not to build feature-heavy demo apps. Each sample addresses a specific engineering challenge and documents the design decisions, trade-offs, and verification strategy behind its implementation.

## Samples

| Sample | Engineering focus | Current status |
| --- | --- | --- |
| **[Message Inbox](message-inbox/)** | SwiftUI, MVVM-style presentation, Observation, Swift Concurrency, cancellation, dependency injection, deterministic tests | First implementation · simulator build pending verification |

Additional samples will be introduced as distinct, independently maintained projects. Each sample has its own Xcode project, code, tests, and README.

## Getting started

To explore the first sample:

```bash
cd message-inbox
swift test
```

To launch the iOS app, open **[`message-inbox/MessageSample.xcodeproj`](message-inbox/MessageSample.xcodeproj)** in Xcode 16 or later, choose the `MessageSample` scheme and an iOS 17+ simulator, then build and run.

## Repository layout

```text
ios-production-samples/
├── README.md
├── README.ko.md
├── .gitignore
├── .github/
│   └── workflows/
│       └── message-inbox.yml
├── docs/
│   └── engineering-principles.md
└── message-inbox/
    ├── README.md
    ├── README.ko.md
    ├── MessageSample.xcodeproj/
    ├── App/
    ├── Sources/
    ├── Tests/
    ├── Package.swift
    └── docs/
        └── architecture.md
```

## Engineering principles

- **Sample independence:** each sample remains runnable and testable on its own.
- **Documented constraints:** describe what is implemented, what is mocked, and what remains unverified.
- **Testable boundaries:** protocol-based dependencies allow deterministic tests for complex states.
- **Behavior before features:** emphasize data correctness, cancellation, error handling, and failure cases.
- **CI per sample:** checks are declared in a root-level workflow, with commands run in the target sample directory.

Read [Engineering Principles](docs/engineering-principles.md) for how samples are chosen and documented.

## Scope and limitations

These are portfolio demonstrations using fictional data—not released products or substitutes for complete production services. The initial SwiftUI app has not yet been validated on an iOS simulator in this environment. Build results should be verified locally in Xcode and through GitHub Actions. No employer-owned source code or confidential assets are included.

For foundational notes and narrower experiments, visit my [iOS Engineering Lab](https://github.com/mongkoon/ios-engineering-lab).
