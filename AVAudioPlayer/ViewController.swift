//
//  ViewController.swift
//  AVAudioPlayer
//
//  Created by SO YOUNG on 2017. 12. 30..
//  Copyright © 2017년 SO YOUNG. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var progress_audio: UIProgressView!
    @IBOutlet weak var lbl_currentTime: UILabel!
    @IBOutlet weak var lbl_totalTIme: UILabel!
    @IBOutlet weak var lbl_record: UILabel!
    
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var btn_pause: UIButton!
    @IBOutlet weak var btn_stop: UIButton!
    
    @IBOutlet weak var slider_volume: UISlider!
    
    var audioPlayer: AVAudioPlayer!
    var playTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        initPlay()
    }
    func initPlay() {
        do {
            if let path = Bundle.main.path(forResource: "Sicilian_Breeze", ofType: "mp3"),
                let url = URL(string: path)
            {
                try audioPlayer = AVAudioPlayer(contentsOf: url)
                //try 문 안에다가 넣어주기
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
                lbl_totalTIme.text = timeIntervalToString(time: audioPlayer.duration)
                lbl_currentTime.text = timeIntervalToString(time: 0)
            }
            
        } catch let error {
            print("AVPlayer error: \(error)")
        }
        setButtons(play: true, pause: false, stop: false)
    }
    
    func updatePlayTime() {
        lbl_currentTime.text = timeIntervalToString(time: audioPlayer.currentTime)
        progress_audio.progress = Float(audioPlayer.currentTime/self.audioPlayer.duration)
    }
    
    func timeIntervalToString(time: TimeInterval) -> String{
        let min = Int(time/60)
        let sec = Int(time) % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    func setButtons(play:Bool, pause:Bool, stop:Bool){
        btn_play.isEnabled = play
        btn_pause.isEnabled = pause
        btn_stop.isEnabled = stop
    }
    
    func stopPlayer() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        progress_audio.progress = 0
        playTimer.invalidate()
        setButtons(play: true, pause: false, stop: false)
    }

    @IBAction func playClicked(_ sender: UIButton) {
        if audioPlayer.isPlaying{
            return
        }
        playTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.updatePlayTime()
        })
        audioPlayer.play()
        setButtons(play: false, pause: true, stop: true)
    }
    @IBAction func pauseClicked(_ sender: UIButton) {
        audioPlayer.pause()
        setButtons(play: true, pause: false, stop: true)
    }
    @IBAction func stopClicked(_ sender: UIButton) {
        stopPlayer()
        setButtons(play: true, pause: false, stop: false)
    }
    @IBAction func volumeChanged(_ sender: UISlider) {
        audioPlayer.volume = sender.value
    }
    @IBAction func switchRecord(_ sender: UISwitch) {
    }
    @IBAction func recordClicked(_ sender: UIButton) {
    }
}

