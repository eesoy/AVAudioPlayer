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
    @IBOutlet weak var btn_record: UIButton!
    
    @IBOutlet weak var slider_volume: UISlider!
    
    @IBOutlet weak var btn_playPause: UIButton!
    
    //오디오 재생 관련
    var audioPlayer: AVAudioPlayer!
    var playTimer: Timer!
    
    //녹음 관련
    var audioRecorder: AVAudioRecorder!
    var isRecordMode = false
    var recordTimer: Timer!

    
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
    
    func initRecorder() {
        let documentDic = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let recordFileUrl = documentDic.appendingPathComponent("record.m4a")
        
        let settings: [String:Any] = [
                AVFormatIDKey: kAudioFormatAppleLossless,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey: 320000,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100.0
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: recordFileUrl, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            lbl_record.text = "00:00"
        } catch let error {
            print("AVAudioRecorder error\(error)")
        }
    }
    
    func updatePlayTime() {
        lbl_currentTime.text = timeIntervalToString(time: audioPlayer.currentTime)
        progress_audio.progress = Float(audioPlayer.currentTime/self.audioPlayer.duration)
    }
    
    func timeIntervalToString(time: TimeInterval) -> String{
        let min = Int(time/60)
        let sec = Int(time) % 60 // Int(time.truncatingRemainder(dividingBy: 60)
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
    
    func playPlayer() {
        if audioPlayer.isPlaying{
            return
        }
        playTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.updatePlayTime()
        })
        audioPlayer.play()
        setButtons(play: false, pause: true, stop: true)
        btn_playPause.setImage(UIImage(named: "pause"), for: .normal)
    }
    
    func pausePlayer() {
        audioPlayer.pause()
        setButtons(play: true, pause: false, stop: true)
        btn_playPause.setImage(UIImage(named: "play"), for: .normal)
    }
    
    func stopRecorder() {
        audioRecorder.stop()
        lbl_record.text = "00:00"
        if recordTimer != nil { recordTimer.invalidate()}
        
    }
    
    func updateRecordInfo() {
        lbl_record.text = timeIntervalToString(time: audioRecorder.currentTime)
    }

    @IBAction func playClicked(_ sender: UIButton) {
        playPlayer()
    }
    @IBAction func pauseClicked(_ sender: UIButton) {
        pausePlayer()
    }
    @IBAction func stopClicked(_ sender: UIButton) {
        stopPlayer()
    }
    @IBAction func volumeChanged(_ sender: UISlider) {
        audioPlayer.volume = sender.value
    }
    @IBAction func switchRecord(_ sender: UISwitch) {
        if sender.isOn {
            stopPlayer()
            initRecorder()
        } else {
            stopRecorder()
            initPlay()
        }
    }
    @IBAction func recordClicked(_ sender: UIButton) {
        if audioRecorder.isRecording {
            stopRecorder()
        } else {
            audioRecorder.record()
            
            if recordTimer == nil {
                recordTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                    self.updateRecordInfo()
                })
            }
        }
    }
    
    @IBAction func playPauseClicked(_ sender: UIButton) {
        if sender.isHighlighted {
            
        }
        if audioPlayer.isPlaying {
            pausePlayer()
        }else {
            playPlayer()
        }
    }
}

