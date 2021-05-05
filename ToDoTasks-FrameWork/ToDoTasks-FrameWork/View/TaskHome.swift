//
//  TaskHome.swift
//  ToDoTasks-FrameWork
//
//  Created by 刘子豪 on 2021/3/30.
//

import UIKit

//  待办任务首页
class TaskHome: ViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  任务列表
        let taskList = TaskList()
        //  添加视图
        self.view.add(taskList)
        //  布局约束
        taskList.snp.makeConstraints { (maker) in
            maker.width.equalTo(375)
            maker.height.equalTo(660)
            maker.center.equalTo(self.view)
        }
        
        //  设置未完成的任务数量为标题
        self.navigationItem.title = "待办(\(Persistence.shared.fetch().filter({ !$0.isDone }).count))"
        //  更多操作按钮
        let moreOption = UIBarButtonItem(image: UIImage(systemName: "ellipsis"))
        //  默认是蓝色，更改为黑色
        moreOption.tintColor = .black
        moreOption.rx.tap.subscribe { (event) in
            //  TODO:更多操作，清空已完成和显示/隐藏已完成
        }.disposed(by: disposeBag)
        //  创建新任务按钮
        let createTask = UIBarButtonItem(image: UIImage(systemName: "plus"))
        createTask.tintColor = .black
        createTask.rx.tap.subscribe { (event) in
            if !Persistence.shared.fetch().contains(where: { $0.content == "" }) {
                Persistence.shared.update(Task(content: "", isDone: false, isStarred: false, creationTime: Date()))
                //  TODO:添加新的待办事项后，reloadData刷新列表不管用，可能是使用了Rx的原因
            }
        }.disposed(by: disposeBag)
        self.navigationItem.leftBarButtonItem = moreOption
        self.navigationItem.rightBarButtonItem = createTask
    }
}
