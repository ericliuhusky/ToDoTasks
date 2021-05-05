//
//  TaskList.swift
//  ToDoTasks-FrameWork
//
//  Created by 刘子豪 on 2021/3/30.
//

import UIKit

//  待办任务列表
class TaskList: TableView {
    
    override func initialize() {
        //  去除UITableView默认的分割线
        self.separatorStyle = .none
        
        //  注册重新利用
        self.register(TaskItem.self, forCellReuseIdentifier: "TaskItem")
        
        //  获取CoreData存储数据并Rx.Obserbable化
        let tasks = RxObservable.just(Persistence.shared.fetch())
        
        //  Rx的方式来设置UITableViewCell的数据源
        tasks.bind(to: self.rx.items) { (tableView, row, task) -> UITableViewCell in
            let taskItem = tableView.dequeueReusableCell(withIdentifier: "TaskItem") as! TaskItem
            //  设置TableViewCell的task数据
            taskItem.task = task
            return taskItem
        }.disposed(by: disposeBag)
    }
}
