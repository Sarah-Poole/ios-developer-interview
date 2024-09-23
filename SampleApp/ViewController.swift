//
//  ViewController.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var dataSource = TableViewDataSource(state: .empty)
    var audioURL = URL(string: "")
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func didTapButton() {
        guard let text = textField.text else {
            return
        }
        
        API.shared.fetchWord(query: text) { response in
            switch response {
            case .success(let data):
                guard let r = WordResponse.parseData(data) else {
                    return
                }
                
                self.dataSource.updateState(.word(r.word)) {
                    self.tableView.reloadData()
                }
                
                //Get Pronunciation Audio Clip URL
                guard let audio = r.hwi.prs?.first!.sound.audio else {
                    return
                }
                let subdirectory = audio.first!
                let audioURLString = "https://media.merriam-webster.com/audio/prons/en/us/mp3/\(subdirectory)/\(audio).mp3"
                self.audioURL = URL(string: audioURLString)
                
            case .failure(let error):
                self.dataSource.updateState(.empty) {
                    self.tableView.reloadData()
                }
                print("NETWORK ERROR: ", error.localizedDescription)
            }
        }
    }
    
    //If Audio Example button is pressed, play pronunciation clip
    @IBAction func didPlayAudio(_ sender: UIButton) {
        let item = AVPlayerItem(url: audioURL!)
        let player = AVPlayer(playerItem: item)
        player.playImmediately(atRate: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
    }


}

extension ViewController: UITableViewDelegate {
    
}
