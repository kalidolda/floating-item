//
//  SecondView.swift
//  floating-item
//
//  Created by Nazerke Kalidolda on 15.09.2023.
//

import UIKit

final class MyTableView: UITableView {}

extension MyTableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

protocol MyViewDelegate: AnyObject {
    func dismissView()
    func expandView()
}

final class SecondView: UIView {
    
    weak var delegate: MyViewDelegate?
    
    private lazy var tableView: MyTableView = {
        let view = MyTableView()
        view.register(TableViewCell.self, forCellReuseIdentifier: "reuseId")
        //    view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        view.dataSource = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(tableView)
        
        tableView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handler)))
        tableView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
        tableView.frame = bounds
    }
    
    var startPos: CGFloat = 0.0;
    var offset: CGFloat = 0.0;
    let maxOffset: CGFloat = 100.0;
    
    @objc private func handler(gesture: UIPanGestureRecognizer){
        //    print(gesture.location(in: self))
        
        switch gesture.state {
        case .began:
            startPos = gesture.location(in: self.superview).y
        case .changed:
            offset = gesture.location(in: self.superview).y - startPos
            
            let norm = (1.0 - min(1.0, offset / maxOffset)) / 2.0
            //      print(norm)
            
            if tableView.contentOffset.y <= 0.0 {
                let transform = CGAffineTransformConcat(
                    CGAffineTransform(translationX: 0, y: offset),
                    CGAffineTransform(scaleX: 0.5 + norm, y: 0.5 + norm)
                )
                self.transform = transform
            }
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            
            if offset > 100 && tableView.contentOffset.y <= 0{
                // dismiss
                delegate?.dismissView()
                tableView.isScrollEnabled = false
            }
            if offset < -80 {
                delegate?.expandView()
                tableView.isScrollEnabled = true
            }
        default:
            break
        }
        print(offset)
        print(tableView.contentOffset.y)
    }
    
}

extension SecondView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath) as! TableViewCell
        cell.text = "Audio \(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //    print("scroll")
        //    print(scrollView.contentOffset)
    }
}
