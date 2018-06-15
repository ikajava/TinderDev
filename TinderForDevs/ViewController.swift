//
//  ViewController.swift
//  TinderForDevs
//
//  Created by Ika Javakhishvili on 05/1/18.
//  Copyright © 2018 Ika Javakhishvili. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var devArray = [Developer]()
    var viewArray = [UIView]()
    
    var likedDevArray = [Developer]()

    func fetchDevelopers(completion: @escaping (Developers) -> ()) {
        guard let url = Bundle.main.url(forResource: "Developers", withExtension: "JSON") else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else { return }
            do {
                let developer = try JSONDecoder().decode(Developers.self, from: data)
                completion(developer)
            } catch let error {
                print("Fail \(error)")
            }
        }.resume()
        
    }
    
    func generateDevelopers(competion: @escaping ([Developer]) -> ()) {
        fetchDevelopers { (developer) in
            developer.dev.forEach({
              self.devArray.append($0)
            })
            competion(self.devArray)
        }
    }
    
    fileprivate func addViewFromArray() {
        let cardView = self.viewArray.last!
        self.view.addSubview(cardView)
        cardView.center = self.view.center
        cardView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            cardView.alpha = 1
        }
    }
    
    func generateViews() {
        generateDevelopers { (devArray) in
            devArray.forEach({ (developer) in
                DispatchQueue.main.async {
                    
                    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.swipe(sender:)))
                    
                    
                    guard let devView = Bundle.main.loadNibNamed("DevView", owner: self, options: nil)?.first as? DevView else {
                        return
                    }
                    
                    devView.nameLabel.text = "\(developer.name)"
                    devView.skillLabel.text = "\(developer.skill)"
                    devView.devImageView.image = UIImage.init(named: developer.gender)
                    devView.addGestureRecognizer(gestureRecognizer)
                    devView.developer = developer
            
                    self.viewArray.append(devView)
                    
                }
            })
            DispatchQueue.main.async {
                self.addViewFromArray()
                
            
            }
        }
    }
    
    @objc func swipe(sender: UIPanGestureRecognizer) {
        let card = sender.view! as! DevView
        let center = card.center
        
        let point = sender.translation(in: self.view)
        card.center.x = center.x + point.x
        card.center.y = center.y + point.y
        
        let pan = card.center.x - view.center.x
        
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if pan > 0 {
            card.signImageView.image = #imageLiteral(resourceName: "Ok")
            card.signImageView.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            card.signImageView.image = #imageLiteral(resourceName: "Cancel")
            card.signImageView.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        
        card.signImageView.alpha = abs(pan) / view.center.x + 0.1
        
        
        print(pan)
        
        if sender.state == UIGestureRecognizerState.ended {
            let half = view.frame.width / 2
            if pan < -1 * half {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 300, y: card.center.y)
                }
                
                dismiss(like: true, developer: card.developer)
                return
            } else if pan > half {
                
                UIView.animate(withDuration: 0.3) {
                      card.center = CGPoint(x: card.center.x + 300, y: card.center.y)
                }
                
              
                dismiss(like: false, developer: nil)
                return
            }
            

            
            
            UIView.animate(withDuration: 0.3) {
                card.center = self.view.center
                card.signImageView.alpha = 0
                
            }
        }
        
    }
    
    
    func dismiss(like: Bool, developer: Developer?) {
        if like {
            if let developer = developer {
                
                
                // Liked Developers added to the array
                
                likedDevArray.append(developer)
            }
        }
        if viewArray.count > 1 {
            viewArray.removeLast()
            addViewFromArray()
        } else {
            let label = UILabel()
            label.font = UIFont.init(name: "Avenir Next", size: 19.0)
            label.contentMode = .center
            label.text = "There are no Devs in the pool"
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        }
        
        
    }
    
    
    override func viewDidLoad() {
        generateViews()
        
        super.viewDidLoad()
        
        
        
    
    }

}

