//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Richard Reed on 12/22/15.
//  Copyright © 2015 Richard Reed. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        
        audioPlayer = try! AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayer.enableRate = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playbackRecording(_ sender: UIButton) {
        resetPlayer()
        audioPlayer.currentTime = 0
        stopButton.isHidden = false
        slowButton.isEnabled = false
        fastButton.isEnabled = false
        chipmunkButton.isEnabled = false
        darthVaderButton.isEnabled = false
        
        if let playback = Playback(rawValue: sender.tag) {
            switch (playback) {
                case .slow: playAudioWithVariableSpeed(0.5)
                case .fast: playAudioWithVariableSpeed(1.5)
                case .chipmunk: playAudioWithVariablePitch(1000)
                case .darthVader: playAudioWithVariablePitch(-500)

            }
        }
        
    }

    @IBAction func stopPlayback(_ sender: UIButton) {
        
        resetPlayer()
        
        stopButton.isHidden = true
        slowButton.isEnabled = true
        fastButton.isEnabled = true
        chipmunkButton.isEnabled = true
        darthVaderButton.isEnabled = true
    }
    
    func playAudioWithVariableSpeed(_ speed: Float){
        resetPlayer()
        audioPlayer.rate = speed
        audioPlayer.play()
        
    }
    
    func playAudioWithVariablePitch(_ pitch: Float){
        
        resetPlayer()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func resetPlayer() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
}
