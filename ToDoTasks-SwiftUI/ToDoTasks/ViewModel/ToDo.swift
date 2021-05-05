//
//  ToDo.swift
//  ToDoTasks
//
//  Created by 刘子豪 on 2021/3/23.
//

import Foundation

//  待办任务的视图模型
class ToDo: ObservableObject {
    //  任务数组
    @Published var tasks: [Task]
    //  是否展示已完成任务
    @Published var isDoneTaskPresented: Bool
    
    init() {
        //  获取持久化的本地数据以初始化任务数组
        self.tasks = Persistence.shared.fetch()
        //  获取持久化的本地数据以初始化是否展示已完成任务
        self.isDoneTaskPresented = Persistence.shared.getIsDoneTaskPresented()
    }
    
    //  创建新的任务
    func create() {
        //  如果没有内容为空的任务那么可以创建任务，用于防止创建多个内容为空的任务
        if !tasks.contains(where: { (task) -> Bool in
            task.content == ""
        }) {
            //  在内存中创建，并未持久化存储
            tasks.append(Task(content: "", isDone: false, isStarred: false, creationTime: Date()))
        }
    }
    
    //  删除任务
    func delete(_ index: Int) {
        //  首先持久化删除任务，如果先删内存，则要删除的任务的id已经消失无法删除持久化数据了
        Persistence.shared.delete(tasks[index].id)
        //  在内存中删除任务
        tasks.remove(at: index)
    }
    
    //  切换已完成状态
    func toggleIsDone(_ index: Int) {
        //  在内存中切换
        tasks[index].isDone.toggle()
        //  持久化切换
        Persistence.shared.update(tasks[index])
    }
    
    //  收藏
    func star(_ index: Int, isStarred: Bool) {
        //  在内存中收藏
        tasks[index].isStarred = isStarred
        //  持久化收藏
        Persistence.shared.update(tasks[index])
    }
    
    //  编辑任务内容
    func edit(_ index: Int, content: String) {
        //  如果内容不为空，那就保存
        if content != "" {
            //  改变内存中的内容
            tasks[index].content = content
            //  持久化改变
            Persistence.shared.update(tasks[index])
        } else {
            //  否则，就是仅仅在内存中创建了新任务，但是该任务内容为空，在内存中删除即可
            tasks.remove(at: index)
        }
    }
    
    //  删除所有的已完成任务
    func deleteAllDoneTasks() {
        //  循环持久化删除已完成任务
        tasks.forEach { task in
            if task.isDone {
                Persistence.shared.delete(task.id)
            }
        }
        //  在内存中删除所有已完成任务
        tasks.removeAll { task -> Bool in
            task.isDone
        }
    }
    
    //  切换是否展示已完成任务的状态
    func toggleIsDoneTaskPresented() {
        //  在内存中切换
        isDoneTaskPresented.toggle()
        //  持久化切换
        Persistence.shared.set(isDoneTaskPresented: isDoneTaskPresented)
    }
}
