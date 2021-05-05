//
//  TaskItem.swift
//  ToDoTasks-FrameWork
//
//  Created by 刘子豪 on 2021/3/29.
//

import UIKit
import ReSwift

//  待办任务项
class TaskItem: TableViewCell {
    var checkBox = CheckBox()
    var taskContent = TaskContent()
    var star = Star()
    var swipeDelete = SwipeDelete()
    
    var task: Task {
        get {
            Task(content: "", isDone: false, isStarred: false, creationTime: Date())
        }
        
        set {
            //  由于在数据源中TableViewCell自动新建实例tableView.dequeueReusableCell(withIdentifier: "TaskItem")
            //  只好使用taskItem.task = task的方式，使用计算属性来赋值，本应该使用convenience构造函数
            checkBox.removeFromSuperview()
            taskContent.removeFromSuperview()
            star.removeFromSuperview()
            checkBox = CheckBox(isDone: newValue.isDone, id: newValue.id)
            taskContent = TaskContent(text: newValue.content, id: newValue.id)
            star = Star()
            //  从父视图删除
            swipeDelete.removeFromSuperview()
            //  新建实例
            swipeDelete = SwipeDelete(id: newValue.id)
            //  再次调用initialize
            self.initialize()
        }
    }
    
    override func initialize() {
        //  TODO:是否显示已完成的任务
        swipeDelete.content.add(checkBox, taskContent, star)
        self.add(swipeDelete)
        //  布局约束
        checkBox.snp.makeConstraints { (maker) in
            maker.leading.equalTo(20)
            maker.centerY.equalToSuperview()
        }
        taskContent.snp.makeConstraints { (maker) in
            maker.leading.equalTo(55)
            maker.centerY.equalToSuperview()
        }
        star.snp.makeConstraints { (maker) in
            maker.leading.equalTo(340)
            maker.centerY.equalToSuperview()
        }
        
        //  取消TableViewCell默认的选中变阴影样式
        self.selectionStyle = .none
        
        //  把TableViewCell的内容视图的手势代理全部设置成自己，防止手势冲突导致默认的TableViewCell事件阻挡自定义的内部事件
        self.contentView.gestureRecognizers?.forEach({ $0.delegate = self })
    }
    
    //  勾选框
    class CheckBox: View, StoreSubscriber {
        //  ReSwift状态管理
        struct State: StateType {
            //  是否完成任务
            var isDone: Bool = false
        }
        struct ToggleIsDone: Action {}
        
        class func reducer(action: Action, state: State?) -> State {
            var state = state ?? State()
            switch action {
            case _ as ToggleIsDone:
                state.isDone.toggle()
                
                //  震动
                if state.isDone {
                    UIImpactFeedbackGenerator().impactOccurred()
                }
            default:
                break
            }
            return state
        }
        
        //  ReSwift存储
        var store: Store<State> = Store<State>(reducer: CheckBox.reducer, state: nil)
        
        //  ReSwift状态更新后自动调用的函数
        func newState(state: State) {
            imageView.image = UIImage(systemName: state.isDone ? "checkmark" : "circle")
        }
        
        var imageView = UIImageView()
        var id: UUID?
        
        convenience init(isDone: Bool, id: UUID) {
            self.init()
            self.store = Store<State>(reducer: CheckBox.reducer, state: State(isDone: isDone))
            store.subscribe(self)
            
            self.id = id
        }
        
        override func initialize() {
            store.subscribe(self)
            
            let tapGesture = UITapGestureRecognizer()
            //  添加tap手势
            imageView.addGestureRecognizer(tapGesture)
            //  默认图像视图不能用户交互因此要更改
            imageView.isUserInteractionEnabled = true
            //  点击手势的响应
            tapGesture.rx.event.subscribe { (event) in
                //  ReSwift触发切换Action，调用reducer函数更改状态并调用newState更新View
                self.store.dispatch(ToggleIsDone())
                //  根据id得到CoreData存储中的task，并对Option?解绑
                if var task = Persistence.shared.fetch().first(where: { $0.id == self.id }) {
                    //  更改task
                    task.isDone.toggle()
                    //  持久化更新task
                    Persistence.shared.update(task)
                }
            }.disposed(by: disposeBag)
            
            //  默认颜色为蓝色更改为黑色
            imageView.tintColor = .black
                            
            self.add(imageView)
            //  布局约束
            self.snp.makeConstraints { (maker) in
                maker.size.equalTo(22)
            }
            
            imageView.snp.makeConstraints { (maker) in
                maker.size.equalTo(22)
            }
        }
        
        deinit {
            store.unsubscribe(self)
        }
    }
    
    //  任务内容
    class TaskContent: View {
        let textField = UITextField()
        var id: UUID?
        
        convenience init(text: String, id: UUID) {
            self.init()
            
            textField.text = text
            
            self.id = id
        }
        
        override func initialize() {
            //  TODO:已完成内容划线灰色文本显示
            //  Rx文本输入框内容更改的响应
            textField.rx.text.orEmpty.changed.subscribe(onNext: { (text) in
                //  根据id得到CoreData存储中的task，并对Option?解绑
                if var task = Persistence.shared.fetch().first(where: { $0.id == self.id }) {
                    //  更改task
                    task.content = text
                    //  持久化更新task
                    Persistence.shared.update(task)
                }
            }).disposed(by: disposeBag)
            self.add(textField)
            
            //  布局约束
            self.snp.makeConstraints { (maker) in
                maker.width.equalTo(280)
                maker.height.equalTo(50)
            }
            textField.snp.makeConstraints { (maker) in
                maker.width.equalTo(280)
                maker.height.equalTo(50)
            }
        }
    }
    
    //  收藏星星
    class Star: View {
        override func initialize() {
            let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
            imageView.tintColor = .yellow
            let tapGesture = UITapGestureRecognizer()
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = true
            tapGesture.rx.event.subscribe { (event) in
                //  TODO:点击取消显示
            }.disposed(by: disposeBag)
            self.add(imageView)
            self.snp.makeConstraints { (maker) in
                maker.size.equalTo(22)
            }
        }
    }
    
    //  滑动删除
    class SwipeDelete: View, StoreSubscriber {
        //  ReSwift状态
        struct State: StateType {
            //  和正常状态相对的横向偏移
            var translationx: CGFloat = 0
        }
        //  向左滑动Action
        struct LeftTransLation: Action {}
        //  向右滑动Action
        struct RightTransLation: Action {}
        
        class func reducer(action: Action, state: State?) -> State {
            var state = state ?? State()
            switch action {
            case _ as LeftTransLation:
                state.translationx = -105
            case _ as RightTransLation:
                state.translationx = 0
            default:
                break
            }
            return state
        }
        
        var store: Store<State> = Store<State>(reducer: SwipeDelete.reducer, state: nil)
        
        func newState(state: State) {
            //  使用CGATransform平移视图
            self.transform = CGAffineTransform(translationX: state.translationx, y: 0)
        }
                
        let content = UIView()
        var id: UUID?
        
        convenience init(id: UUID) {
            self.init()
            
            self.id = id
        }
        
        override func initialize() {
            store.subscribe(self)
            
            //  收藏按钮
            let imageView1 = UIImageView(image: UIImage(systemName: "star"))
            //  更改为黑色
            imageView1.tintColor = .black
            let tapGesture1 = UITapGestureRecognizer()
            //  添加手势
            imageView1.addGestureRecognizer(tapGesture1)
            //  更给默认UIImageView不可交互
            imageView1.isUserInteractionEnabled = true
            tapGesture1.rx.event.subscribe { (event) in
                //  TODO:收藏
            }.disposed(by: disposeBag)
            
            //  删除按钮
            let imageView2 = UIImageView(image: UIImage(systemName: "trash.slash"))
            imageView2.tintColor = .black
            let tapGesture2 = UITapGestureRecognizer()
            imageView2.addGestureRecognizer(tapGesture2)
            imageView2.isUserInteractionEnabled = true
            tapGesture2.rx.event.subscribe { (event) in
                //  TODO:点击删除没有反应
            }.disposed(by: disposeBag)
            
            self.add(content, imageView1, imageView2)
            
            //  向左滑动手势
            let dragGesture1 = UISwipeGestureRecognizer()
            //  默认是向右的，更改为向左
            dragGesture1.direction = .left
            self.addGestureRecognizer(dragGesture1)
            dragGesture1.rx.event.subscribe { (event) in
                //  动画效果0.5秒
                Self.animate(withDuration: 0.5) {
                    self.store.dispatch(LeftTransLation())
                }
            }.disposed(by: disposeBag)
            //  向右滑动手势
            let dragGesture2 = UISwipeGestureRecognizer()
            self.addGestureRecognizer(dragGesture2)
            dragGesture2.rx.event.subscribe { (event) in
                //  动画效果0.5秒
                Self.animate(withDuration: 0.5) {
                    self.store.dispatch(RightTransLation())
                }
            }.disposed(by: disposeBag)
            //  点击手势也回归原位
            let tapGesture = UITapGestureRecognizer()
            self.addGestureRecognizer(tapGesture)
            tapGesture.rx.event.subscribe { (event) in
                //  动画效果0.5秒
                Self.animate(withDuration: 0.5) {
                    self.store.dispatch(RightTransLation())
                }
            }.disposed(by: disposeBag)
            
            //  布局约束
            self.snp.makeConstraints { (maker) in
                maker.width.equalTo(375)
                maker.height.equalTo(50)
            }
            content.snp.makeConstraints { (maker) in
                maker.width.equalTo(375)
                maker.height.equalTo(50)
            }
            imageView1.snp.makeConstraints { (maker) in
                maker.leading.equalTo(395)
                maker.centerY.equalToSuperview()
            }
            imageView2.snp.makeConstraints { (maker) in
                maker.leading.equalTo(435)
                maker.centerY.equalToSuperview()
            }
        }
        
        deinit {
            store.unsubscribe(self)
        }
    }
}
