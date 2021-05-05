//
//  TaskList.swift
//  ToDoTasks-UIKit
//
//  Created by 刘子豪 on 2021/3/25.
//

import UIKit

class TaskList: UITableView, UITableViewDataSource {
    var tasks: [Task] = []
    
    func render(tasks: [Task]) {
        self.tasks = tasks
        self.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskItem = tableView.dequeueReusableCell(withIdentifier: "TaskItem") as! TaskItem
        taskItem.render(task: tasks[indexPath.row],index: indexPath.row)
        return taskItem
    }
}
