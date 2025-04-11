# NaeilBurgerCamp

<div align=center>
<img src="https://github.com/user-attachments/assets/dc59825e-0db9-4531-b0ac-b0628eb112e7" width="350"/>
</div>

## 프로젝트 소개

**NaeilBurgerCamp**는 햄버거 전문점 앱을 클론 코딩한 iOS 사이드 프로젝트입니다.  
사용자는 카테고리별 메뉴를 확인하고, 장바구니에 담아 주문할 수 있습니다.  
실제 운영 중인 앱의 UX를 기반으로 직관적인 흐름과 반응성을 고려하여 제작했습니다.

- **메뉴 카테고리 조회**: 단품, 세트, 사이드, 음료 등 카테고리별 메뉴 확인
- **메뉴 상세 정보 확인**: 이미지, 이름, 가격 등의 상세 정보 제공
- **장바구니 기능**: 선택한 상품을 장바구니에 담고 주문 가능
- **실시간 주문 처리**: 주문 데이터는 Firestore에 실시간 반영
- **다국어 지원(Localization)**: 한국어, 영어, 일본어 지원
- **다크 모드 대응**: iOS 환경에 맞춘 다크 모드 UI 적용

> 본 프로젝트는 팀원 4인이 Clean Architecture를 기반으로 역할을 나누어 협업하였으며,  
> `RxSwift` 기반의 비동기 처리와 `Firestore` 실시간 데이터베이스를 활용하여 구현되었습니다.

## 시연 영상
https://github.com/user-attachments/assets/5d356eef-735b-472c-906e-fb4e2f20e9bd

## 기술스택
### 📌 개발 환경
- **Swift**  
  iOS 앱 개발을 위한 프로그래밍 언어
- **Xcode 16.0**  
  iOS 앱 개발을 위한 공식 IDE

### 🎨 UI 구성
- **UIKit**  
  전통적인 iOS UI 구성 프레임워크
- **SnapKit**  
  AutoLayout을 코드로 간결하게 작성할 수 있는 DSL 라이브러리
- **UICollectionView Compositional Layout**  
  복잡한 레이아웃을 손쉽게 구성할 수 있는 컬렉션 뷰 레이아웃 방식
- **DiffableDataSource**  
  스냅샷 기반의 안정적인 데이터 소스 처리 방식

### 🔄 반응형 프로그래밍
- **RxSwift**  
  비동기 처리 및 이벤트 스트림을 다루는 리액티브 프로그래밍 라이브러리

### 🌍 글로벌 대응
- **Localization**  
  다국어 지원을 위한 다국어 번역 처리

### ☁️ 백엔드 및 데이터 관리
- **Firebase (Firestore)**  
  실시간 데이터베이스 및 백엔드 서비스 제공 플랫폼


## 아키텍처
![버거킹 아키텍처 구조 001](https://github.com/user-attachments/assets/40d35a27-618d-4211-90c1-77a6601b403e)

## 레이아웃 
<img src="https://github.com/user-attachments/assets/36becdc1-60f3-4c60-a369-6873abd2cc56" width="600"/>

## 역할 분담
<div align=center>
    
  <img width="160px" src="https://avatars.githubusercontent.com/u/20144453?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/96423430?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/127279971?v=4"/> | <img width="160px" src="https://avatars.githubusercontent.com/u/105594739?v=4"/> | 
  |:-----:|:-----:|:-----:|:-----:|
  |[유석환](https://github.com/youseokhwan)|[송규섭](https://github.com/SongKyuSeob)|[고욱현](https://github.com/imo2k)| [이수현](https://github.com/LeeeeSuHyeon) |
  |팀장 👑|팀원 👨🏻‍💻|팀원 👨🏻‍💻|팀원 👨🏻‍💻|
  |`Data Layer`<br/>`Firebase 인프라 구축`<br/>`FirestoreService 구현`<br/>`PlaceOrderView 구현`<br/>|`Presentation Layer`<br/>`UI/UX 디자인`<br/>`MainView 구현`<br/>`다크모드 대응`<br/>|`Presentation Layer`<br/>`View Model 구현`<br/>`다국어 지원(Localization) 구현`<br/>|`Entity 구현`<br/>`UseCase 구현`<br/>`Repository 구현`<br/>`이미지 캐싱 구현`<br/>
</div>

## 파일 구조
```
.
├── NaeilBurgerCamp
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Data
│   │   ├── DTO
│   │   ├── FSError.swift
│   │   ├── FirestoreService.swift
│   │   └── Repository
│   ├── Domain
│   │   ├── Entity
│   │   └── UseCase
│   ├── Presentation
│   │   ├── Launch
│   │   └── Main
│   ├── Resource
│   │   ├── Assets.xcassets
│   │   ├── Font
│   │   ├── Info.plist
│   │   └── Localizable
│   └── Utility
│       ├── Extensions
│       └── ImageLoader
└── NaeilBurgerCamp.xcodeproj
```


## Convention 
### Commit Convention (PR 시 동일하게 적용)
- `feat`: 새로운 기능 추가
- `refactor`: 새로운 기능 추가 없이 개선이 이뤄진 경우(주석 수정, 네이밍 수정 포함)
- `fix`: 버그 수정
- `chore`: 프로젝트 설정, ignore 설정, 패키지 추가 등 코드 외적인 변경 사항
- `docs`: 문서 작업
- `test`: 테스트 관련 작업

###  Coding Convention
- 기본적으로 Swift API Design Guidelines를 기반으로 하거나, Swift Document에 예제로 쓰인 코드 스니펫들을 기준으로 진행
- 파일 생성시 생기는 상단 주석은 삭제
- UI 컴포넌트 네이밍
    - UI 컴포넌트 생성 시, suffix로 컴포넌트 타입 명시
- import 구문
    - Foundation, UIKit 2개는 반드시 맨 위에 작성(소스코드가 어디에 관여하는지 나타내기 때문)
    - 내부 import들을 먼저쓰고, 외부 import들을 밑에 쓴다. (개행은 x)
    - 그 외 순서는 자유롭게
- Extension 파일의 경우는 `{타입}+Extensions.swift` 형태로 작성
    -   ex) Array+Extensions.swift, UIStackView+Extensions.swift

### Branch Convention
- main: 배포 가능한 안정적인 코드가 유지되는 브랜치
- dev: 기본 브랜치로, 기능을 개발하는 브랜치
- {tag}/{#issue-number}-{keyword}
    - ex) feat/#3-category-ui
    - ex) refactor/#5-storage
- {tag}/* 브랜치들은 전부 dev로 PR 발행 후, 팀원 모두의 승인을 받고 merge할 것
- 기본적으로 merge 방식으로 진행, (원하면 rebase해도 상관없음)
- 브랜치는 가급적 소문자로 구성하기!


## 다국어 지원
<table>
  <tr>
    <td style="text-align: center; font-weight: bold;">한국어 지원</td>
    <td style="text-align: center; font-weight: bold;">영어 지원</td>
    <td style="text-align: center; font-weight: bold;">일본어 지원</td>
  </tr>
  <tr>
    <td style="text-align: center;">
      <img src="https://github.com/user-attachments/assets/50d13d41-1c26-4f0f-a6a2-9cd1b00a0c5d" width="300"/>
    </td>
    <td style="text-align: center;">
      <img src="https://github.com/user-attachments/assets/ef5ec927-9fec-45d9-aabf-9dbddd9f79e1" width="300"/>
    </td>
    <td style="text-align: center;">
      <img src="https://github.com/user-attachments/assets/0c3ed97e-3cac-489a-95b2-293fceec456b" width="300"/>
    </td>
  </tr>
</table>


## Usage
```
git clone https://github.com/nbcamp-prplz/NaeilBurgerCamp.git
cd NaeilBurgerCamp/NaeilBurgerCamp
open NaeilBurgerCamp.xcodeproj
# 실행: ⌘ + R 
``` 

## 개발 블로그
- [NSCache + Actor 기반 이미지 캐시 매니저 구현기(1)](https://soo-hyn.tistory.com/145)
- [NSCache + Actor 기반 이미지 캐시 매니저 구현기(1)](https://soo-hyn.tistory.com/146)
- [UICollectionView Compositional Layout 1](https://subkyu-ios.tistory.com/41)
- [Input & Output 패턴 Part. 1](https://velog.io/@o2k_tech/Input-Output-%ED%8C%A8%ED%84%B4-Part.-1)
