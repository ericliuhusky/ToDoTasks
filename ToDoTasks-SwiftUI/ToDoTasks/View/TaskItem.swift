//
//  TaskItem.swift
//  ToDoTasks
//
//  Created by 刘子豪 on 2021/3/23.
//

import SwiftUI

//  任务项
struct TaskItem: View {
    let task: Task
    @EnvironmentObject var todo: ToDo
    
    //  根据传入的task计算索引
    var index: Int? {
        todo.tasks.firstIndex(where: { $0.id == task.id })
    }
    
    var body: some View {
        //  如果不是(设置不展示已完成任务且任务已经完成)，那么就渲染该任务项
        if !(!todo.isDoneTaskPresented && task.isDone) {
            //  滑动删除
            SwipeDelete(index: index) {
                //  横向Stack，子组件间距10
                HStack(spacing: 10) {
                    //  勾选框
                    CheckBox(isDone: task.isDone, index: index)
                    
                    //  任务内容
                    TaskContent(text: task.content, isDone: task.isDone, index: index)
                    
                    //  收藏星星
                    Star(index: index)
                }
                //  间隔
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
        }
    }
    
    //  勾选框
    struct CheckBox: View {
        //  是否已完成
        @State var isDone: Bool
        let index: Int?
        @EnvironmentObject var todo: ToDo
        
        var body: some View {
            //  已完成显示对号，未完成显示圆圈
            Image(systemName: isDone ? "checkmark" : "circle")
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                .onTapGesture {
                    //  切换组建内部State的状态
                    isDone.toggle()
                
                    guard let index = index else { return }
                    //  ViewModel切换完成状态
                    todo.toggleIsDone(index)
                    
                    //  震动反馈
                    if isDone {
                        UIImpactFeedbackGenerator().impactOccurred()
                    }
                }
        }
    }
    
    //  文本内容
    struct TaskContent: View {
        @State var text: String
        let isDone: Bool
        let index: Int?
        @EnvironmentObject var todo: ToDo
        
        var body: some View {
            //  如果未完成显示正常
            if !isDone {
                //  文本输入框
                TextField("", text: $text, onEditingChanged: { editing in
                    if editing {
                        
                    }
                }, onCommit: {
                    guard let index = index else { return }
                    //  ViewModel编辑内容
                    todo.edit(index, content: text)
                })
            } else {
                //  已完成以灰色划线显示
                HStack {
                    Text(text)
                        //  字符中间划线
                        .strikethrough()
                        //  前景色灰色
                        .foregroundColor(.gray)
                    //  空占位
                    Spacer()
                }
            }
        }
    }
    
    //  收藏星星
    struct Star: View {
        let index: Int?
        @EnvironmentObject var todo: ToDo
        
        var body: some View {
            if let index = index, todo.tasks[index].isStarred {
                Image(systemName: "star.fill")
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    //  前景色黄色
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        //  ViewModel收藏
                        todo.star(index, isStarred: false)
                    }
            }
        }
    }
    
    //  滑动删除
    struct SwipeDelete<Content: View>: View {
        //  相对正常情况的横向位移值
        @State private var translationX: CGFloat = 0
        let index: Int?
        @EnvironmentObject var todo: ToDo
        let content: () -> Content
        
        var body: some View {
            //  使用GeometryReader自定义建议以使得content()占据整个屏幕宽度
            GeometryReader { geometryProxy in
                HStack {
                    //  设置宽度为整个屏幕宽度
                    content().frame(width: geometryProxy.size.width)
                    
                    //  收藏按钮
                    Image(systemName: "star")
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        .onTapGesture {
                            guard let index = index else { return }
                            //  ViewModel收藏
                            todo.star(index, isStarred: true)
                        }
                    
                    //  删除按钮
                    Image(systemName: "trash.slash")
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        .onTapGesture {
                            guard let index = index else { return }
                            //  ViewModel删除待办的任务
                            todo.delete(index)
                        }
                }
                //  偏移量
                .offset(x: translationX, y: 0)
                //  匿名动画效果
                .animation(.easeInOut(duration: 0.5))
                .gesture(DragGesture().onChanged { value in
                    //  向左滑动整体向左偏移
                    if value.translation.width < 0 {
                        translationX = geometryProxy.size.width * -0.26
                    } else if value.translation.width > 0 {
                        //  向右滑动回归原位
                        translationX = 0
                    }
                })
            }
        }
    }
}

struct TaskItem_Previews: PreviewProvider {
    static var previews: some View {
        TaskItem(task: Task(content: "1", isDone: true, isStarred: true, creationTime: Date())).environmentObject(ToDo())
    }
}
