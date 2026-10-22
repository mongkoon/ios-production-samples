# iOS Production Samples

[English](README.md) | **한국어**

iOS 실무 개발에서 중요한 **아키텍처, 비동기 처리 정확성, 상태 관리, 자동화 테스트**를 보여주기 위한 독립 실행형 샘플 앱 모음입니다.

많은 기능을 구현하기보다는 각각의 샘플에서 특정 엔지니어링 문제를 해결하고, 그 근거와 트레이드오프 및 검증 방법을 문서화하는 데 집중합니다.

## 샘플 목록

| 샘플 | 주요 주제 | 현재 상태 |
| --- | --- | --- |
| **[Message Inbox](message-inbox/README.ko.md)** | SwiftUI, MVVM 방식의 상태 관리, Observation, Swift Concurrency, 취소 처리, 의존성 주입, 결정적 테스트 | 첫 구현 · iOS 시뮬레이터 빌드 검증 전 |

새 샘플은 독립적인 기술적 주제가 있을 때만 추가하며, 각 샘플은 자체 Xcode 프로젝트와 README, 테스트 코드를 가집니다.

## 실행 방법

```bash
cd message-inbox
swift test
```

iOS 앱은 Xcode 16 이상에서 **`message-inbox/MessageSample.xcodeproj`**를 열고, `MessageSample` 스킴과 iOS 17 이상 시뮬레이터를 선택해 실행합니다.

## 저장소 구조

```text
ios-production-samples/
├── README.md
├── README.ko.md
├── .gitignore
├── .github/workflows/message-inbox.yml
├── docs/engineering-principles.md
└── message-inbox/
    ├── README.md
    ├── README.ko.md
    ├── MessageSample.xcodeproj/
    ├── App/
    ├── Sources/
    ├── Tests/
    ├── Package.swift
    └── docs/architecture.md
```

## 운영 원칙

- 샘플마다 빌드와 테스트를 독립적으로 실행할 수 있도록 구성합니다.
- 실제 구현과 Mock 데이터, 아직 검증하지 않은 부분을 구분해 기술합니다.
- 프로토콜과 의존성 주입으로 재현 가능한 테스트를 작성합니다.
- 공통 코드는 실제 재사용성이 확인된 후에만 분리합니다.
- GitHub Actions 워크플로는 저장소 루트에서 관리합니다.

보다 자세한 기준은 [Engineering Principles](docs/engineering-principles.md)를 확인하세요.

## 범위 및 한계

이 저장소의 앱은 실제 서비스가 아닌 구직 포트폴리오용 샘플이며 가상의 데이터를 사용합니다. 현재 환경에서는 iOS 시뮬레이터 빌드를 아직 검증하지 못했으므로 Xcode와 GitHub Actions에서 검증이 필요합니다. 회사 소유 코드나 기밀 자료는 포함하지 않습니다.

기초 개념과 실험은 별도의 [iOS Engineering Lab](https://github.com/mongkoon/ios-engineering-lab)에 정리합니다.
