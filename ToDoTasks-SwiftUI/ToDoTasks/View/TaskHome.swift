//
//  TaskHome.swift
//  ToDoTasks
//
//  Created by 刘子豪 on 2021/3/23.
//

import SwiftUI

//  待办任务的首页
struct TaskHome: View {
    //  ViewModel视图模型
    @EnvironmentObject var todo: ToDo
    //  未完成的待办任务数量
    @State var todoTaskNumber: Int = 0
    
    var body: some View {
        NavigationView {
            //  待办任务列表
            TaskList()
                //  导航栏标题
                .navigationTitle("待办(\(todoTaskNumber))")
                //  导航栏左右按钮
                .navigationBarItems(leading: MoreOption(), trailing: CreateTask())
        }
        //  接收ViewModel.Publisher的数据之后，更新未完成的待办任务数量
        .onReceive(todo.$tasks, perform: { _ in
            //  过滤未完成任务并计数
            todoTaskNumber = todo.tasks.filter { task -> Bool in
                !task.isDone
            }.count
        })
    }
    
    //  创建新的待办任务按钮
    struct CreateTask: View {
        @EnvironmentObject var todo: ToDo
        
        var body: some View {
            Image(systemName: "plus")
                .onTapGesture {
                    //  创建新的任务
                    todo.create()
                }
        }
    }
    
    //  更多操作按钮
    struct MoreOption: View {
        @EnvironmentObject var todo: ToDo
        //  操作列表是否展示
        @State var isPresented: Bool = false
        
        var body: some View {
            Image(systemName: "ellipsis")
                .actionSheet(isPresented: $isPresented, content: {
                    ActionSheet(title: Text("更多操作"),
                                message: Text("如何对待已完成任务？"),
                                buttons: [.default(Text(todo.isDoneTaskPresented ? "隐藏" : "展示"),
                                                   action: {
                                                    //  切换已完成任务的展示状态
                                                    todo.toggleIsDoneTaskPresented()}),
                                          .destructive(Text("清空"), action: {
                                                        //  删除所有已完成任务
                                                        todo.deleteAllDoneTasks()}),
                                          .cancel(Text("取消"))])
                })
                .onTapGesture {
                    //  点击展示操作列表
                    isPresented = true
                }
        }
    }
}

struct TaskHome_Previews: PreviewProvider {
    static var previews: some View {
        TaskHome().environmentObject(ToDo())
    }
}
