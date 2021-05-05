//
//  NavigationController.swift
//  ToDoTasks-FrameWork
//
//  Created by 刘子豪 on 2021/3/26.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pushViewController(TaskHome(), animated: false)
    }
}
