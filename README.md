# 집중의 순간 (Moment of Focus)

목탁 소리에 집중하며 무념무상 상태에 들어가는 iOS 명상 수행 앱.

## 앱 소개

핸드폰이 목탁이 됩니다. 화면을 탭하면 목탁 소리가 울리고, 박자에 맞춰 탭할수록 더 깊은 단계로 진입합니다.

### 5단계 수행 시스템

| 단계 | BPM | 가이드 빛 | 설명 |
|------|-----|-----------|------|
| 1단계 (따라) | 80 BPM | ✅ | 템포를 따라 쳐주세요 |
| 2단계 (느껴) | 68 BPM | ✅ | 소리를 느끼며 쳐주세요 |
| 3단계 (전환) | 56 BPM | ❌ | 진동을 느끼며 쳐주세요 |
| 4단계 (내면) | 44 BPM | ❌ | 내 안의 리듬으로 쳐주세요 (무음) |
| 5단계 (심장) | 내 심박수 | ✅ | 심장의 리듬으로 쳐주세요 |

### 진급 조건
- **Perfect** 판정 10회 연속 → 다음 단계 자동 진급
- 타이밍 판정: Perfect (±12%), Near (±25%), Off

## 설치 및 실행

### 요구사항
- macOS 13.0 이상
- Xcode 15.0 이상
- iOS 16.0 이상 기기 또는 시뮬레이터
- Apple 개발자 계정 (실기기 실행 시)

### 실행 방법

```bash
# 1. 저장소 클론
git clone https://github.com/shrewcheetah-hue/jipjung-swift.git
cd jipjung-swift

# 2. Xcode로 열기
open JipjungSungan.xcodeproj
```

Xcode에서:
1. `JipjungSungan.xcodeproj` 파일을 더블클릭하여 Xcode 실행
2. 상단 타겟 선택에서 실행할 기기 또는 시뮬레이터 선택
3. `⌘ + R` 로 빌드 및 실행

### 실기기 실행 시 서명 설정
1. Xcode → JipjungSungan 타겟 → Signing & Capabilities
2. Team: 본인의 Apple 개발자 계정 선택
3. Bundle Identifier: `com.jipjung.sungan` (또는 원하는 ID로 변경)

## 목탁 소리 파일 추가 (선택사항)

앱에 목탁 소리 파일을 포함하면 더 실감나는 수행이 가능합니다.

1. `moktak.mp3` 또는 `moktak.wav` 파일 준비
2. Xcode에서 `JipjungSungan` 그룹에 파일 추가 (Copy items if needed 체크)
3. Target Membership에서 `JipjungSungan` 체크

소리 파일이 없으면 시스템 사운드로 대체됩니다.

## 다국어 지원

시스템 언어에 따라 자동으로 언어가 선택됩니다:
- 🇰🇷 한국어 (ko)
- 🇺🇸 영어 (en)
- 🇯🇵 일본어 (ja)
- 🇨🇳 중국어 간체 (zh)
- 🇫🇷 프랑스어 (fr)

## 화면 구성

- **시작 화면**: 단계 선택, 5단계 심장 버튼, 달의 기운 버튼
- **수행 화면**: 목탁 탭 영역, 타이밍 링(수축 원), HUD, 진급 진행바
- **결과 화면**: 수행 통계, 격려 메시지, 다시하기
- **심장 단계**: 심박수 탭 측정, BPM 표시, 수행 시작
- **달의 기운**: 오늘의 달 위상, 음력 날짜, 자정 카운트다운, 기도 좋은 시간

## 기술 스택

- **언어**: Swift 5.0
- **프레임워크**: SwiftUI, AVFoundation, UIKit (햅틱), Combine
- **최소 iOS**: 16.0
- **Bundle ID**: com.jipjung.sungan

## 라이선스

개인 사용 목적으로 제작된 앱입니다.
