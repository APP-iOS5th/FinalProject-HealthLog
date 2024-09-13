/// Project.swift
import ProjectDescription

let infoPlist: InfoPlist = .extendingDefault(with: [
    "UILaunchStoryboardName": .string("LaunchScreen.storyboard"), // 안쓰면 없어도 됨
    "UIApplicationSceneManifest": .dictionary([
        "UIApplicationSupportsMultipleScenes": .boolean(false),
        "UISceneConfigurations": .dictionary([
            "UIWindowSceneSessionRoleApplication": .array([
                .dictionary([
                    "UISceneConfigurationName": .string(
                        "Default Configuration"
                    ),
                    "UISceneDelegateClassName": .string(
                        "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ), // UIKit은 SceneDelegate 설정 필수, 안되면 검은화면인채 동작 없음
                ])
            ])
        ])
    ]),
//    "UISupportedDevices": .array([
//        .string("iPhone"),
//    ]), // 적용이 안되는 것 같음
    "UISupportedInterfaceOrientations": .array([
        .string("UIInterfaceOrientationPortrait")
    ])
//    ,
//    "UISupportedInterfaceOrientations~ipad": .array([
//        .string("UIInterfaceOrientationPortrait"),
//        .string("UIInterfaceOrientationLandscapeLeft"),
//    ])
])

let project = Project(
    name: "HealthLog",
    packages: [
        .remote(
            url: "https://github.com/realm/realm-swift",
            requirement: .branch("master")
        ),
        .remote(
            url: "https://github.com/WenchaoD/FSCalendar",
            requirement: .upToNextMajor(from: "2.8.4")
        ),
    ],
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "59FP2PXRXK", // Team 멤버쉽 아이디 - Codegrove Inc.
            "CODE_SIGN_STYLE": "Automatic",
        ],
        configurations: [
//            .debug(name: "Debug", xcconfig: "./xcconfigs/HealthLog-Project.xcconfig"),
//            .release(name: "Release", xcconfig: "./xcconfigs/HealthLog-Project.xcconfig"),
        ]// tuist migration settings-to-xcconfig -p .../project.xcodeproj -x .../output.xcconfig 명령 후 필요한 설정
        // || -p 뒤는 원본 프로젝트 경로 || -x 뒤는 생성할 경로이며 .xcconfig로 쓸 파일 이름 맞춰주기 ||
    ),
    targets: [
        .target(
            name: "HealthLog",
            destinations: [.iPhone],
            product: .app,
            bundleId: "kr.co.wnyl.HealthLog",
            deploymentTargets: .iOS("16.0"),
            infoPlist: infoPlist,
            sources: ["HealthLog/Sources/**"],
            resources: ["HealthLog/Resources/**"],
            dependencies: [
                .package(product: "RealmSwift"),
                .package(product: "FSCalendar"),
            ] // Package.swift로 라이브러리 관리하는 경우 .external로 써야할지도
        ),
    ]
)

/*
 0. tuist init --platform ios (직접 폴더 구조 및 Project.swift 파일 세팅할 시, 명령 실행 안해도 됨)
 1. 폴더 구조에 맞춰 Resources,Sources 폴더에 폴더 및 파일 옮기기
 2. Project.swift 수정
 3. tuist migration settings-to-xcconfig ... 실행 (필수는 아님, 안하면 Project.swift의 configurations 지워주세요)
 4. tuist generate 로 xcode용 파일 생성
 5. tuist build (xcode로 build, run 해도 됨)
 6. 에셋 사용 코드, 라이브러리 연결, SceneDelegate 연결 등 오류 수정
 7. 앱 실행
 8. gitignore 설정 (자동 생성되는건 넣어야 할지도)
 9. 새 브랜치로 push해서 시험해보기
 */

/* 폴더 구조
 HealthLog
 │
 ├── HealthLog
 │   ├── Resources
 │   │   ├── Base.lproj
 │   │   │   └── LaunchScreen.storyboard
 │   │   ├── Assets.xcassets
 │   │       ├── ...
 │   │       └── Contents.json
 │   │   ├── font
 │   │       └── ...
 │   │   └── ...
 │   ├── Sources
 │   │   ├── AppDelegate.swift
 │   │   ├── SceneDelegate.swift
 │   │   ├── ViewModel
 │   │       └── ...
 │   │   ├── Model
 │   │       └── ...
 │   │   ├── View
 │   │       └── ...
 │   │   └── Extensions
 │   │       ├── UIFont+Extensions.swift
 │   │       └── ...
 │   └── Tests : 안쓰면 지워도 됨, 테스트 코드가 없음
 ├── xcconfigs
 │   └── HealthLog-Project.xcconfig : tuist migration settings-to-xcconfig 명령어로 생성
 ├── Tuist : 지워도 됨
 │   ├── Config.swift : 안쓰면 지워도 됨, 특수한 코드 설정파일(?).
 │   └── Package.swift : 안쓰면 지어도 됨, 라이브러리 설정파일. Project.swift의 packages에서 .remote로 관리하므로 안씀
 ├── .git
 ├── .gitignore
 ├── .package.resolved : generate, build시 자동 생성
 ├── Derived : generate, build시 자동 생성
 ├── HealthLog.xcodeproj : generate, build시 자동 생성
 ├── HealthLog.xcworkspace : generate, build시 자동 생성
 └── Project.swift : Tuist 설정 파일 (중요)
 */

/*
 트러블 슈팅 1 - 에셋/폰트
 - 에셋 : TuistAssets+HealthLog.swift
 - 폰트 : TuistFonts+HealthLog.swift
 // UIFont(name: "Pretendard-Semibold", size: 16) 처럼 에셋이나 폰트를 name: ""로 사용하지 않고,
    .colorXXXXXX 처럼 enum으로 쓰는 중이였다면 에러가 있을 수 있음
 // Extesnion으로 tuist에서 만들어준 enum들과 연결해줄 필요가 있을 수도 있음 (gpt한테 코드 부탁)
 */
