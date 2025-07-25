# 🧭 용인시 노인 길안내 어플리케이션 - Pilot Function 2

본 프로젝트는 **용인시 노인을 위한 길안내 어플리케이션**의 Pilot 기능 2 구현을 목적으로 한 **Flutter 기반 크로스 플랫폼 앱**입니다.  
Flutter 프레임워크를 활용해 Android, iOS, Web 등 다양한 플랫폼에서 동작하도록 개발되었습니다.

---

## 🛠️ 기술 스택

- **Framework**: Flutter
- **Language**: Dart
- **지도 API**: Naver Map (네이버 지도 SDK 사용)
- **지원 플랫폼**: Android, iOS, Web, Windows, Linux, macOS

---

## 📁 디렉토리 구조

```plaintext
.
├── android/            # Android 플랫폼 코드
├── ios/                # iOS 플랫폼 코드
├── lib/                # 앱의 주요 Dart 소스코드
├── linux/              # Linux 플랫폼 코드
├── macos/              # macOS 플랫폼 코드
├── test/               # 테스트 코드
├── web/                # 웹앱 관련 코드
├── windows/            # Windows 플랫폼 코드
├── .github/workflows/  # CI/CD 설정
├── .metadata           # Flutter 프로젝트 메타정보
├── .gitignore          # Git 무시 파일 목록
├── LICENSE             # 라이선스 정보
├── README.md           # 설명 문서
├── pubspec.yaml        # 패키지 메타 및 의존성 관리
├── pubspec.lock        # 실제 설치된 패키지 버전 기록
├── analysis_options.yaml # 분석 도구 설정
```

## 🚀 실행 방법
Flutter 개발 환경이 구성되어 있어야 합니다.
아래 명령어로 프로젝트를 실행할 수 있습니다:

```
flutter pub get        # 의존성 설치
flutter run            # 앱 실행
```

웹에서 실행 시:
```
flutter run -d chrome
```
