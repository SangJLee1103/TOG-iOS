# TOG(기독교인을 위한 AI 채팅 서비스)
> <aside>
💡 TOG는 현대 기독교인들이 일상생활 속에서 신앙적인 질문이나 고민을 언제든지 해결할 수 있도록 돕기 위해 만들어진 인공지능 챗봇입니다.

TOG는 'Tool of GOD'와 'Tool of Grace'의 약자로, 하나님의 도구이자 은혜의 도구가 되고자 하는 뜻을 담고 있습니다.

## 1. 화면구성

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/SangJLee1103/TOG-iOS/assets/76645463/e2573c0e-b93a-4078-ba2a-a1d01b663a87" alt="Screenshot - 1" style="width: 30%;"/>
  <img src="[https://github.com/Team-TOG/TOG-iOS/assets/76645463/1ef05962-a0ab-4eb6-bd70-34dff204837f](https://github.com/SangJLee1103/TOG-iOS/assets/76645463/d9364aaa-55ce-466d-b84b-6cb88cc00b7b)" alt="Screenshot - 2" style="width: 30%;"/>
  <img src="[https://github.com/Team-TOG/TOG-iOS/assets/76645463/a44b7adb-a1d2-49a9-9fe3-a879e0c08506](https://github.com/SangJLee1103/TOG-iOS/assets/76645463/be99ff2b-6f84-4f3f-9984-9c22ca20aceb)" alt="Screenshot - 3" style="width: 30%;"/>
</div>

<div style="display: flex; justify-content: space-between;">
  <img src="[https://github.com/Team-TOG/TOG-iOS/assets/76645463/13dec060-69fe-47fc-a21c-5ded26083a84](https://github.com/SangJLee1103/TOG-iOS/assets/76645463/8bd3e1d0-b3e0-4c2e-bc9e-b0d5c559d220)" alt="Screenshot - 4" style="width: 30%;"/>
  <img src="[https://github.com/Team-TOG/TOG-iOS/assets/76645463/e089ef52-7c4e-4160-a99b-3597f1e3dc2b](https://github.com/SangJLee1103/TOG-iOS/assets/76645463/4b4051a4-a64e-42ff-8821-abea23baf739)" alt="Screenshot - 5" style="width: 30%;"/>
  <img src="[https://github.com/Team-TOG/TOG-iOS/assets/76645463/0e4fcf96-1847-46fb-88d2-3d1010cb1c5c](https://github.com/SangJLee1103/TOG-iOS/assets/76645463/dd91817b-77c4-4b55-a10b-af5edcc9ab28)" alt="Screenshot - 6" style="width: 30%;"/>
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
