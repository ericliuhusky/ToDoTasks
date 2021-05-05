//
//  Task.swift
//  ToDoTasks-UIKit
//
//  Created by 刘子豪 on 2021/3/24.
//

import Foundation

//  待办任务模型
struct Task: Identifiable {
    //  唯一的id用于SwiftUI的ForEach循环
    var id = UUID()
    //  文本内容
    var content: String
    //  是否完成
    var isDone: Bool
    //  是否收藏喜欢
    var isStarred: Bool
    //  创建时间
    let creationTime: Date
}
