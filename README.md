# TOG(기독교인을 위한 AI 채팅 서비스)
> <aside>
💡 TOG는 현대 기독교인들이 일상생활 속에서 신앙적인 질문이나 고민을 언제든지 해결할 수 있도록 돕기 위해 만들어진 인공지능 챗봇입니다.

TOG는 'Tool of GOD'와 'Tool of Grace'의 약자로, 하나님의 도구이자 은혜의 도구가 되고자 하는 뜻을 담고 있습니다.



## 1. 화면구성
<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/Team-TOG/TOG-iOS/assets/76645463/464207ef-d178-4c4a-a165-ba54bb72c4fb" alt="Screenshot - 1" style="width: 30%;"/>
  <img src="https://github.com/Team-TOG/TOG-iOS/assets/76645463/1ef05962-a0ab-4eb6-bd70-34dff204837f" alt="Screenshot - 2" style="width: 30%;"/>
  <img src="https://github.com/Team-TOG/TOG-iOS/assets/76645463/a44b7adb-a1d2-49a9-9fe3-a879e0c08506" alt="Screenshot - 3" style="width: 30%;"/>
</div>

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/Team-TOG/TOG-iOS/assets/76645463/13dec060-69fe-47fc-a21c-5ded26083a84" alt="Screenshot - 4" style="width: 30%;"/>
  <img src="https://github.com/Team-TOG/TOG-iOS/assets/76645463/e089ef52-7c4e-4160-a99b-3597f1e3dc2b" alt="Screenshot - 5" style="width: 30%;"/>
  <img src="https://github.com/Team-TOG/TOG-iOS/assets/76645463/0e4fcf96-1847-46fb-88d2-3d1010cb1c5c" alt="Screenshot - 6" style="width: 30%;"/>
</div>

- 스플래쉬 화면
- 로그인 화면
- 서비스 이용 필수동의
- 채팅화면
- 사이드 메뉴
- 옵션 화면

-> 앱 실행 영상
https://github.com/SangJLee1103/FLO-RX/assets/76645463/8048dbd1-35d8-4bb4-b499-c6d382125411


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
