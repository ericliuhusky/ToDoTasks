//
//  FrameWork.swift
//  ToDoTasks-FrameWork
//
//  Created by 刘子豪 on 2021/3/30.
//

import UIKit
//  extension，整个项目只要引入一次包就可以了UIVIew().rx
//  响应式框架
import RxSwift
import RxCocoa
//  extension，整个项目只要引入一次包就可以了UIView().snp
//  布局框架
import SnapKit

class View: UIView {
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initialize() {
        
    }
}

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
}

class TableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initialize() {
        
    }
}

class TableView: UITableView {
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initialize() {
        
    }
}

extension UIView {
    //  一次添加多个子视图
    func add(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}

//  别名，这样别的地方不用引入RxSwift
typealias RxObservable = Observable
