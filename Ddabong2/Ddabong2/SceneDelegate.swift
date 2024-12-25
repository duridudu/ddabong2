//
//  SceneDelegate.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/19/24.
//

import UIKit
import StreamChat
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let config = ChatClientConfig(apiKey: .init("y57jr4rgfvea"))

        /// user id and token for the user
        let userId = "maria"
        let token: Token =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFyaWEifQ.lkisfdCvygaCgmhE6NA_kYAMHfNhiQza1sNhABG_Zqo"

        /// Step 1: create an instance of ChatClient and share it using the singleton
        ChatClient.shared = ChatClient(config: config)
        print("STEP 1")
        
        /// Step 2: connect to chat
        ChatClient.shared.connectUser(
            userInfo: UserInfo(
                id: userId,
                name: "maria"
               // imageURL: URL(string: "https://bit.ly/2TIt8NR")
            ), token: token
        )
        // 채널 만들기
        
        do {
            let controller = try ChatClient.shared.channelController(
                createChannelWithId: ChannelId(type: .messaging, id: "test_channel"),
                name: "Jonh, Maria",
                members: ["john", "maria"]
            )

            controller.synchronize { error in
                if let error = error {
                    print("Failed to create channel: \(error)")
                } else {
                    print("Channel created successfully!")
                }
            }
        } catch {
            print("Error creating channel: \(error)")
        }
        
        print("STEP 2")
        
        /// Step 3: create the ChannelList view controller
        let channelList = DemoChannelList()
        let query = ChannelListQuery(filter: .containMembers(userIds: [userId]))
        channelList.controller = ChatClient.shared.channelListController(query: query)

        /// Step 4: similar to embedding with a navigation controller using Storyboard
//        if let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DemoChannelList") as? ChannelListViewController {
//        window?.rootViewController = UINavigationController(rootViewController: storyboard)
//        window?.makeKeyAndVisible()
//    }
       // window?.rootViewController = UINavigationController(rootViewController: channelList)
      //  window?.
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

