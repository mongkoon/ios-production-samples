# Engineering Principles

This repository collects independent iOS applications demonstrating *why* an engineering choice was made, how it works, and how it can be verified.

## Criteria for adding a sample

A sample should:

1. Be an independently runnable Xcode project.
2. Isolate a recognizable production engineering problem.
3. Include tests for its most important behavioral invariants.
4. Explain architecture choices and trade-offs in its README or `docs/` folder.
5. Clearly state mocked behaviors, constraints, and limitations.

## How to read the samples

Start with the root README, then follow the sample's README, implementation and tests. The tests are intended as executable evidence for claims about behavior—not merely test-count metrics.

## Design boundaries

- Samples can use different architectures where the trade-offs justify it.
- Share code between samples only when that is itself an intentional, documented design decision.
- Avoid including employer-owned code, credentials, real user data, or proprietary assets.
- CI is sample-specific. When adding a sample, create a corresponding `.github/workflows/<sample>.yml` workflow or update the existing workflow after checking that all paths are correct.

## Verification status

Do not describe an implementation as production-ready solely because unit tests pass. Compile and run the app in a supported Xcode/iOS simulator environment and document any relevant failures before making broader claims.
