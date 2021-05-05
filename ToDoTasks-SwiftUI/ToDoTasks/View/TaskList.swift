//
//  TaskList.swift
//  ToDoTasks
//
//  Created by 刘子豪 on 2021/3/23.
//

import SwiftUI

//  任务列表
struct TaskList: View {
    @EnvironmentObject var todo: ToDo
    
    var body: some View {
        //  滚动视图
        ScrollView {
            //  循环渲染
            ForEach(todo.tasks) { task in
                //  任务项
                TaskItem(task: task).frame(width: 375, height: 40, alignment: .center)
            }
        }
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList().environmentObject(ToDo())
    }
}
