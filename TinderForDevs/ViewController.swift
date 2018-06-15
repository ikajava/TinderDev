//
//  ViewController.swift
//  TinderForDevs
//
//  Created by Ika Javakhishvili on 05/1/18.
//  Copyright © 2018 Ika Javakhishvili. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    
    var devArray = [Developer]()
    var viewArray = [UIView]()

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
        
//        self.mainView.addSubview(self.viewArray.last!)
        
        
    }
    
    func generateViews(completion: @escaping ([UIView]) -> ()) {
        var returnView = [UIView]()
        generateDevelopers { (devArray) in
            devArray.forEach({ (developer) in
                if let devView = Bundle.main.loadNibNamed("DevView", owner: self, options: nil)?.first as? DevView {
                    devView.nameLabel.text = "\(developer.name)"
                    devView.skillLabel.text = "\(developer.skill)"
                    devView.imageLabel.image = UIImage.init(named: developer.gender)
                    returnView.append(devView)
                }
                DispatchQueue.main.async {
                    
                }
                
            })
        }
        self.viewArray = returnView
        completion(returnView)
    }
    
    
    override func viewDidLoad() {
        generateViews { (v) in
            print(v)
        }
        
        super.viewDidLoad()
        
        
        
    
    }

}

