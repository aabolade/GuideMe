//
//  ViewController.swift
//  GuideMe
//
//  Created by Leke Abolade on 31/01/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//


import UIKit
import Speech
import CoreLocation
import AudioToolbox

class ViewController: UIViewController, CLLocationManagerDelegate, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var dictatebutton: UIButton!
    
    @IBOutlet weak var textview: UITextView!
    
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    let audioEngine = AVAudioEngine()
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    var usingBeacons = UsingBeacons()
    
    var locationManager: CLLocationManager!
    var message: String = ""

    var lastMessage = "Welcome to Guide Me"
    var apiService = APIService()
    var speech = Speech()

    var vibrate = Vibrate()
    
    @IBOutlet weak var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dictatebutton.isEnabled = false
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = UIColor.black
    
        
        self.distanceReading.text = lastMessage
        self.textToSpeech(string: lastMessage)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        whenInUse(status: status)
    }

    
    func whenInUse(status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            montoringAvailable()
        }
    }
    
    func montoringAvailable() {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            rangingAvailable()
        }
    }
    
    func rangingAvailable() {
        if CLLocationManager.isRangingAvailable() {
            startScanning()
        }
    }

    func startScanning() {
        guard let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") else {
            print("UUID is nil")
            return
        }
    
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "Region")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
    }
    
        
    @IBOutlet weak var textView: UILabel!

    
    func setTextLabelAndSpeak(text: String) {
        self.distanceReading.text = text
        onlySpeakOnce()
        self.lastMessage = self.distanceReading.text!
    }
    
    func onlySpeakOnce() {
        if (self.lastMessage != self.distanceReading.text) {
            speech.playSound()
            usingBeacons.textToSpeech(string: self.distanceReading.text!)
        }
    }
    
    
    func increaseFontSize () {
        let text = self.distanceReading
        text?.font = UIFont(name: (text?.font.fontName)!, size: (text?.font.pointSize)! + 10)
    }
    
    func decreaseFontSize () {
        let text = self.distanceReading
        
        if (Int((text?.font.pointSize)!) > 20) {
           text?.font = UIFont(name: (text?.font.fontName)!, size: (text?.font.pointSize)! - 10)
        }
    }
    
    func getPlatformMessage() -> String {
        
        apiService.getLiveDepartures() { (departure) in
            
            guard let depart = departure else  {
                print("The departures are nil")
                return
            }
            
            guard let arrivalTime = depart.arrivalTime else {
                print("")
                return
            }
            
            guard let platformName = depart.platformName else {
                print("")
                return
            }
            
            guard let lineName = depart.lineName else {
                print("")
                return
            }
            
            guard let destination = depart.destinationName else {
                print("")
                return
            }
            
            let trainTime = TrainTime()
            
            self.message = "The next train to arrive will be the \(lineName) service to \(destination). This train arrives in \(trainTime.formatArrivalTime(trainTime: arrivalTime))"

        }
        
        return self.message
        
        
    }
    
    @IBAction func IncreaseFontSize(_ sender: UIButton) {
        increaseFontSize()
    }
    
    @IBAction func DecreaseFontSize(_ sender: UIButton) {
        decreaseFontSize()
    }
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
        
            OperationQueue.main.addOperation {
            
                switch authStatus {
                case .authorized:
                   
                    self.dictatebutton.isEnabled = true
                    
                case .denied:
                    self.dictatebutton.isEnabled = false
                    self.dictatebutton.setTitle("User denied access to speech recognition.", for: .disabled)
                   
                    
                case .restricted:
                    self.dictatebutton.isEnabled = false
                    self.dictatebutton.setTitle("Speech recognition restricted on device.", for: .disabled)
                    
                    
                case .notDetermined:
                    self.dictatebutton.isEnabled = false
                    self.dictatebutton.setTitle("Speech recognition not yet authorized.", for: .disabled)
                    
                }
            }
            
        }
        
    }
    
    
    func StartRecording() throws {
       
        
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
           

        }
       
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
      
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
      
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SfSpeechAudioBufferRecognitionRequest object")}
      
        recognitionRequest.shouldReportPartialResults = true
    
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in var isFinal = false
           
            if let result = result {
                self.textview.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.dictatebutton.isEnabled = true
                self.dictatebutton.setTitle("Start Speaking", for: [])
            }
           
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textview.text = "I'm listening."
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
         
            dictatebutton.isEnabled = true
            dictatebutton.setTitle("Start Recording", for: [])
        } else {
            dictatebutton.isEnabled = false
            dictatebutton.setTitle("Recognition not available.", for: .disabled)
        }
        
    }
    
    @IBAction func dictateaction(_ sender: UIButton) {
      
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            dictatebutton.isEnabled = false
            dictatebutton.setTitle("Ending...", for: .disabled)
            
        } else {
        
            try! StartRecording()
            dictatebutton.setTitle("Stop Recording", for: [])

        }
    }
}

