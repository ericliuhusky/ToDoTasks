//
//  ToDoTasksApp.swift
//  ToDoTasks
//
//  Created by 刘子豪 on 2021/3/23.
//

import SwiftUI

//  程序入口
@main
struct ToDoTasksApp: App {
    var body: some Scene {
        WindowGroup {
            //  待办任务首页
            TaskHome()
                //  新建一个ViewModel的实例并赋值为环境对象，使其子组件可以获取环境对象
                .environmentObject(ToDo())
        }
    }
}
