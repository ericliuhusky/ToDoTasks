//
//  TaskItem.swift
//  ToDoTasks-UIKit
//
//  Created by 刘子豪 on 2021/3/25.
//

//  滑动删除没有做，感觉在这里实现起来很麻烦，就不做了
//  收藏没有做，仅仅做了展示没有交互

import UIKit

class TaskItem: UITableViewCell {
    var task: Task?
    var index: Int?

    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var taskContent: UITextField!
    @IBOutlet weak var star: UIImageView!
    
    func render(task: Task, index: Int) {
        self.task = task
        self.index = index
        
        checkBox.setImage(UIImage(systemName: task.isDone ? "checkmark" : "circle"), for: .normal)
        
        if task.isDone {
            taskContent.textColor = .gray
            taskContent.attributedText = NSAttributedString(string: task.content, attributes: [NSAttributedString.Key.strikethroughStyle: 1])
        } else {
            taskContent.textColor = .black
            taskContent.text = task.content
        }
        
        if !task.isStarred {
            star.isHidden = true
        }
    }
    
    @IBAction func toggleIsDone(_ sender: UIButton) {
        task?.isDone.toggle()
        
        guard let task = task else { return }
        checkBox.setImage(UIImage(systemName: task.isDone ? "checkmark" : "circle"), for: .normal)
        
        if task.isDone {
            taskContent.textColor = .gray
            taskContent.attributedText = NSAttributedString(string: task.content, attributes: [NSAttributedString.Key.strikethroughStyle: 1])
        } else {
            taskContent.textColor = .black
            taskContent.text = task.content
        }
        
        Persistence.shared.update(task)
    }
    
    @IBAction func edit(_ sender: UITextField) {
        task?.content = sender.text ?? ""
        
        guard let task = task else { return }
        if task.content != "" {
            Persistence.shared.update(task)
        }
    }
    @IBAction func remove(_ sender: UIButton) {
        guard let task = task else { return }
        Persistence.shared.delete(task.id)
    }
}
