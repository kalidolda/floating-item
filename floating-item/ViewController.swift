//
//  ViewController.swift
//  floating-item
//
//  Created by Nazerke Kalidolda on 15.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private var isExpanded = false;
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 80, width: view.bounds.width - 40, height: 44)
        label.text = "Musée du Louvre"
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .center
        label.textColor = UIColor.blue
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 130, width: view.bounds.width - 50, height: 300)
        label.text = "Le musée du Louvre est un musée situé dans le 1er arrondissement de Paris, en France. Une préfiguration en est imaginée en 1775-1776 par le comte d'Angiviller, directeur général des Bâtiments du roi, comme lieu de présentation des chefs-d'œuvre de la collection de la Couronne. Ce musée n'a été inauguré qu'en 1793 sous l'appellation de Muséum central des arts de la République dans le palais du Louvre, ancienne résidence royale située au centre de Paris, et il est aujourd'hui l'un des trois plus grands musées d'art du monde aux côtés du Musée de l'Ermitage et du Musée national de Chine. Sa surface d'exposition est de 72 735 m29."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 200, width: 50, height: 50))
        button.backgroundColor = .blue.withAlphaComponent(0.7)
        button.layer.cornerRadius = 25.0
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handler)))
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var secondView: SecondView = {
        let view = SecondView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.isHidden = false
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        
        self.view.bringSubviewToFront(button)
    }
    
    private func setupViews() {
        [titleLabel, textLabel, button, secondView].forEach {
            view.addSubview($0)
        }
    }
    
    @objc private func handler(gesture: UIPanGestureRecognizer){
        print(gesture.location(in: self.view))
        switch gesture.state {
        case .changed:
            button.center = gesture.location(in: view)
        case .ended:
            animateToEdge()
        default:
            break
        }
        
    }
    
    private func animateToEdge() {
        var newX: CGFloat = 0.0
        if button.frame.midX < view.frame.midX {
            newX = 16
        } else {
            newX = view.frame.width - 66
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, animations: {
            self.button.frame = CGRect(x: newX,
                                       y: self.button.frame.minY,
                                       width: self.button.frame.width,
                                       height: self.button.frame.height)
        })
        
    }
    
    @objc private func didTapButton() {
        print("tap button")
        isExpanded.toggle()
        animateExpand(expand: isExpanded)
        
    }
    
    private func animateExpand(expand: Bool) {
        if expand {
            // Show animation
            secondView.frame = button.frame
            secondView.layer.cornerRadius = button.frame.width / 2
            secondView.isHidden = false
            secondView.alpha = 1.0
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, animations: {
                self.secondView.frame = CGRect(x: self.view.center.x-100,
                                               y: self.view.center.y-150,
                                               width: 200,
                                               height: 300)
                self.secondView.layer.cornerRadius = 10
                
            }) { _ in
                print("done")
            }
        } else {
            // Hide animation
            UIView.animate(withDuration: 0.1) {
                self.secondView.alpha = 0.5
            }
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, animations: {
                self.secondView.frame = self.button.frame
                self.secondView.layer.cornerRadius = self.button.frame.width / 2
            }) { _ in
                self.secondView.isHidden = true
            }
        }
    }
    
    private func expand() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, animations: {
            self.secondView.frame = self.view.frame
        })
    }
    
}

extension ViewController: MyViewDelegate {
    func dismissView() {
        isExpanded = false
        animateExpand(expand: isExpanded)
    }
    
    func expandView() {
        expand()
    }
}

