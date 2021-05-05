//
//  Persistence.swift
//  ToDoTasks
//
//  Created by 刘子豪 on 2021/3/23.
//

import CoreData

//  CoreData持久化
class CDPersistence {
    //  单例
    static let shared = CDPersistence()

    //  容器
    lazy private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoTasks")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print(error, error.userInfo)
            }
        }
        return container
    }()
    
    //  上下文
    lazy private var context: NSManagedObjectContext = {
        container.viewContext
    }()
    
    //  保存上下文
    private func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
    
    //  获取请求
    private let request = NSFetchRequest<CDTask>(entityName: "CDTask")
    
    //  查
    func fetch() -> [Task] {
        do {
            //  条件为空，查找所有
            request.predicate = nil
            let cdTasks: [CDTask] = try context.fetch(request)
            //  把CDTask映射为Task
            return cdTasks.map { cdTask -> Task in
                return Task(cdTask: cdTask)
            }
        } catch {
            print(error)
        }
        return []
    }
    
    //  删
    func delete(_ id: UUID) {
        do {
            //  条件为id相等
            request.predicate = NSPredicate(format: "%K == %@", "id", NSUUID(uuidString: id.uuidString) ?? NSUUID())
            let cdTasks: [CDTask] = try context.fetch(request)
            //  确保有id相等的结果
            guard !cdTasks.isEmpty else { return }
            //  删除结果数组中的第一个结果
            context.delete(cdTasks[0])
            
            //  保存
            save()
        } catch {
            print(error)
        }
    }
    
    //  改
    func update(_ task: Task) -> Bool {
        do {
            //  条件为id相等
            request.predicate = NSPredicate(format: "%K == %@", "id", NSUUID(uuidString: task.id.uuidString) ?? NSUUID())
            let cdTasks: [CDTask] = try context.fetch(request)
            if cdTasks.isEmpty {
                //  如果没有id相等的结果，那么更改失败，返回false
                return false
            }
            //  task反向赋值cdTasks[0]
            task.assign(cdTask: cdTasks[0])
            
            //  保存
            save()
        } catch {
            print(error)
        }
        return true
    }
    
    //  增
    func create(_ task: Task) {
        //  在上下文中创建CDTask实例
        let cdTask = CDTask(context: context)
        //  task反向赋值cdTask
        task.assign(cdTask: cdTask)
        
        //  保存
        save()
    }
    
    //  DEBUG未使用
    func deleteAll() {
        do {
            request.predicate = nil
            let cdTasks: [CDTask] = try context.fetch(request)
            cdTasks.forEach(context.delete)
            
            save()
        } catch {
            print(error)
        }
    }
}

//  CoreData无需手动编写模型代码，在xcdatamodeld文件里即可手动编辑模型
//  可是这样不具有普适性，如果不想使用CoreData，突然想用SQLite怎么办
//  于是仍然正常创建模型，并扩展其使得能和CoreData的模型相互转化
extension Task {
    //  使用CDTask来构造Task
    init(cdTask: CDTask) {
        self.id = cdTask.id ?? UUID()
        self.content = cdTask.content ?? ""
        self.isDone = cdTask.isDone
        self.isStarred = cdTask.isStarred
        self.creationTime = cdTask.creationTime ?? Date()
    }
    
    //  使用task给cdTask反向赋值，这里其实是inout值传递，由于CDTask是Class无需声明inout默认值传递
    func assign(cdTask: CDTask) {
        cdTask.id = self.id
        cdTask.content = self.content
        cdTask.isDone = self.isDone
        cdTask.isStarred = self.isStarred
        cdTask.creationTime = self.creationTime
    }
}

//  封装持久化，想要换SQLite等持久化方式会相对方便
class Persistence {
    static let shared = Persistence()
    
    func fetch() -> [Task] {
        CDPersistence.shared.fetch()
    }
    
    func delete(_ id: UUID) {
        CDPersistence.shared.delete(id)
    }
    
    //  合增改为一
    func update(_ task: Task) {
        //  如果能改就改，改失败了说明没有此任务
        if !CDPersistence.shared.update(task) {
            //  那就增加此任务
            CDPersistence.shared.create(task)
        }
    }
    
    //  获取用户偏好
    func getIsDoneTaskPresented() -> Bool {
        return UserDefaults.standard.bool(forKey: "isDoneTaskPresented")
    }
    
    //  设置用户偏好
    func set(isDoneTaskPresented: Bool) {
        UserDefaults.standard.set(isDoneTaskPresented, forKey: "isDoneTaskPresented")
    }
}
