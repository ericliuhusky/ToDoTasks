//
//  TaskHome.swift
//  ToDoTasks-UIKit
//
//  Created by 刘子豪 on 2021/3/24.
//

//  由用户偏好存储的是否展示已完成任务懒得做了

import UIKit

class TaskHome: UIViewController {
    var taskList: TaskList!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var moreOptionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskList = self.view.subviews[0] as? TaskList
        taskList.render(tasks: Persistence.shared.fetch())
        
        moreOptionView.isHidden = true
        
        navigationBar.topItem?.title = "待办(\(Persistence.shared.fetch().count))"
    }

    @IBAction func create(_ sender: UIBarButtonItem) {
        if !taskList.tasks.contains(where: { (task) -> Bool in
            task.content == ""
        }) {
            taskList.tasks.append(Task(content: "", isDone: false, isStarred: false, creationTime: Date()))
            
            taskList.reloadData()
        }
    }
    
    @IBAction func moreOption(_ sender: UIBarButtonItem) {
        moreOptionView.isHidden.toggle()
    }
    
    @IBAction func deleteAllDoneTasks(_ sender: UIButton) {
        //  按道理应该根据内存来删，但是TaskItem在这种方式下并不容易来改变父控件TaskList内存储的tasks
        //  只好根据持久化的数据来删
        Persistence.shared.fetch().forEach { (task) in
            if task.isDone {
                Persistence.shared.delete(task.id)
            }
        }
        taskList.render(tasks: Persistence.shared.fetch())
        
        taskList.reloadData()
    }
}

