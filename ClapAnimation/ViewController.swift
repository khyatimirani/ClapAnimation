//
//  ViewController.swift
//  ClapAnimation
//
//  Created by Khyati Mirani on 20/11/19.
//  Copyright © 2019 Khyati Mirani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var networkStatusLabel: UILabel!
    
    
    let networkManager = NetworkCallManager.shared
    var successCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpClapsView()
        networkStatusLabel.text = networkManager.isConnected ?? false ? Constants.trueConditionLabelValue : Constants.falseConditionLabelValue
    }
        
    
    
    func setUpClapsView() {
        let claps = ClapsView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 100.0, height: 100.0)))
        claps.delegate = self
        claps.emoji = Constants.clapEmoji
        claps.totalClaps = 1
        // claps.maxClaps = 1000
        claps.showClapsAbbreviated = true
        self.view.addSubview(claps)
        claps.center = self.view.center
    }
    

}

extension ViewController: ClapsViewDelegate {
    func clapsViewStateChanged(clapsView: ClapsView, state: ClapsViewStates, totalClaps: Int, currentClaps: Int) {
        
        clapsView.totalClaps = clapsView.totalClaps + 1
        makeNetworkCall()
        print(Constants.totalClaps + "\(clapsView.totalClaps)")
    }
    
    func makeNetworkCall(){
        networkManager.makeNetworkRequest { [weak self] (error) in
            if error == nil {
                self?.successCount += 1
                guard let clapCountPosted = self?.successCount else {
                    return
                }
                updateResultLabel(result: Constants.connected + Constants.clapResult + "\(clapCountPosted)")
            }
            else {
                updateResultLabel(result:  Constants.falseConditionLabelValue)
            }
            
        }
        
        func updateResultLabel(result: String){
            DispatchQueue.main.async {
                self.networkStatusLabel.text = result
            }
        }
        
    }
}
