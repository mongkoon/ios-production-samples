# Message Sample — iOS 포트폴리오

가상의 메시지 목록 및 상세 화면을 통해 **시니어 iOS 개발자의 아키텍처 설계, 비동기 처리, 검증 역량**을 보여주는 SwiftUI 샘플입니다.

**현 상태:** 실행 가능한 첫 버전. 외부 서버 없이 가상 데이터를 사용합니다.

## 핵심

- SwiftUI 메시지 목록/상세/검색 및 로딩·빈 결과·오류 화면
- `@Observable` + `@MainActor` 기반 상태 관리
- 검색 디바운스, Task 취소, 늦게 도착한 결과의 반영 차단
- Repository 추상화 및 의존성 주입
- 인위적으로 응답 순서를 역전시키는 결정적 Swift Testing 테스트

## 실행

1. Xcode에서 `MessageSample.xcodeproj`를 엽니다.
2. `MessageSample` 스킴, iOS 17 이상 시뮬레이터를 선택합니다.
3. `⌘R`로 실행합니다.
4. 핵심 테스트: 이 샘플의 폴더에서 `swift test` 또는 Xcode에서 `Package.swift` 열어 테스트합니다.

더 자세한 설계 근거는 [architecture](docs/architecture.md)를 참고하세요.

이 프로젝트는 학습 및 구직용 독립 샘플이며 상용 회사 코드를 포함하지 않습니다.
