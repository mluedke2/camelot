//
//  ViewController.swift
//  Camelot
//
//  Created by Matt Luedke on 5/1/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import AVFoundation
import ResearchKit

class ViewController: UIViewController, ORKTaskViewControllerDelegate {
    
  var audioPlayer: AVAudioPlayer?
  var soundFileURL: URL?
  
  @IBAction func consentTapped(_ sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
    taskViewController.delegate = self
    present(taskViewController, animated: true, completion: nil)
  }
  
  @IBAction func surveyTapped(_ sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: SurveyTask(), taskRun: nil)
    taskViewController.delegate = self
    present(taskViewController, animated: true, completion: nil)
  }
  
  @IBAction func microphoneTapped(_ sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: MicrophoneTask, taskRun: nil)
    taskViewController.delegate = self
    taskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
    present(taskViewController, animated: true, completion: nil)
  }
  
  @IBAction func playMostRecentSound(_ sender: AnyObject) {
    if let soundFileURL = soundFileURL {
      do {
        try audioPlayer = AVAudioPlayer(contentsOf: soundFileURL, fileTypeHint: AVFileTypeAppleM4A)
        audioPlayer?.play()
      } catch {}
    }
  }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        // check for a sound file
        soundFileURL = findSoundFile(taskViewController.result)
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    func findSoundFile(_ result: ORKTaskResult) -> URL? {
    
    if let results = result.results {
      if results.count > 3 {
        if let stepResult = results[3] as? ORKStepResult, let subResults = stepResult.results, let fileResult = subResults[0] as? ORKFileResult {
          
          return fileResult.fileURL
        }
      }
    }
    
    return nil
  }
}
