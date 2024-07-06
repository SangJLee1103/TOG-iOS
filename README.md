# TOG(기독교인을 위한 AI 채팅 서비스)
> <aside>
💡 TOG는 현대 기독교인들이 일상생활 속에서 신앙적인 질문이나 고민을 언제든지 해결할 수 있도록 돕기 위해 만들어진 인공지능 챗봇입니다.

TOG는 'Tool of GOD'와 'Tool of Grace'의 약자로, 하나님의 도구이자 은혜의 도구가 되고자 하는 뜻을 담고 있습니다.

## 1. 화면구성

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/SangJLee1103/TOG-iOS/assets/76645463/e2573c0e-b93a-4078-ba2a-a1d01b663a87" alt="Screenshot - 1" style="width: 30%;"/>
  <img src="https://github.com/SangJLee1103/TOG-iOS/assets/76645463/0da05fb5-4659-43f0-970c-a5bda27cd662" alt="Screenshot - 2" style="width: 30%;"/>
  <img src="https://github.com/SangJLee1103/TOG-iOS/assets/76645463/c0ac61dc-d564-42bf-8779-47d48f1d0870" alt="Screenshot - 3" style="width: 30%;"/>
</div>

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/SangJLee1103/TOG-iOS/assets/76645463/ada0e130-f928-453b-99e5-d6f5404bbbb0" alt="Screenshot - 4" style="width: 30%;"/>
  <img src="https://github.com/SangJLee1103/TOG-iOS/assets/76645463/317304d3-dc7d-493c-9b36-69b825747d3f" alt="Screenshot - 5" style="width: 30%;"/>
  <img src="https://github.com/SangJLee1103/TOG-iOS/assets/76645463/a5398ed5-34a1-4ed4-9d85-ca73da4e9499" alt="Screenshot - 6" style="width: 30%;"/>
</div>

- 스플래쉬 화면
- 로그인 화면
- 서비스 이용 필수동의
- 채팅화면
- 사이드 메뉴
- 옵션 화면


-> 앱 실행 영상
https://github.com/SangJLee1103/TOG-iOS/assets/76645463/46479b55-ed96-4503-8c31-5ec77a179cdf




## 2. 프레임워크
- UIKit
- SnapKit
- Then
- Alamofire
- RxSwift
- RxCocoa
- RxGesture
- SDWebImage
- Firebase
- MarkdownKit


## 3. 프로젝트 구조

```
├── Resources
     ├── Font
│    └── Assets
└── Sources
     ├── Delegates
     │     ├── AppDelegate
     │     └── SceneDelegate
     ├── Error
     │     └── MyError
     ├── Utils
     │     ├── Constants
     │     ├── UserManager
     │     └── TogAssistant
     ├── Extensions
     │     ├── UIVIewExtension
     │     ├── UIColorExtension
     │     └── UIButtonExtension
     ├── Models
     │     ├── Auth
     |     |    └── User
     │     ├── Chat
     │     |    ├── MusicRouter
     │     |    ├── MusicRepository
     │     |    └── MusicRepositoryImpl 
     │     └── Settings
     │          └── Setting 
     ├── Repositories
     │     ├── Auth
     │     |    ├── UserRepository
     │     |    └── UserRepositoryImpl
     │     ├── Chat
     │     |    ├── ChatRouter
     │     |    ├── ChatRepository
     │     |    └── ChatRepositoryImpl 
     │     └── Base
     │          └── ApiConstant           
     ├── Views
     │     ├── Buttons
     │     |    ├── TogButton
     │     |    └── TogNormalButton
     │     ├── Terms
     │     |    └── TermsRequiredView
     │     ├── Auth
     │     |    └── LoginButton
     │     ├── Settings
     │     |    ├── SettingsTableViewCell
     │     |    └── SwitchTableViewCell
     │     ├── Side
     │     |    ├── SideUserTableViewCell
     │     |    ├── SideChatHistoryTableViewCell
     │     |    └── SideTableViewHeaderView
     │     ├── Chat
     │     |    ├── MyTableViewCell
     │     |    ├── TogTableViewCell
     │     |    └── ChatTextView
     ├── ViewModels
     │     ├── Base
     │     |    └── BaseViewModel
     │     ├── Terms
     │     |    └── TermsRequiredView
     │     ├── Auth
     │     |    └── SignInViewModel
     │     ├── Terms
     │     |    └── TermsViewModel
     │     ├── Settings
     │     |    └── SettingsViewModel
     │     ├── Side
     │     |    └── SideViewModel
     │     ├── Chat
     │     |    └── ChatViewModel
     ├── ViewControllers
     │     ├── Common
     │     |    ├── TogWebViewController
     │     |    └── TogAlertViewController
     │     ├── Base
     │     |    └── BaseViewController
     │     ├── Auth
     │     |    └── SignInViewController
     │     ├── Terms
     │     |    └── TermsViewController
     │     ├── Settings
     │     |    └── SettingsViewController
     │     ├── Side
     │     |    └── SideViewController
     │     ├── Chat
     │     |    └── ChatViewController
     └── LaunchScreen.storyboard
```
