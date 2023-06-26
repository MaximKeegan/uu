//
//  ViewController.swift
//  uu
//
//  Created by Maxim Keegan on 27.05.2023.
//

import UIKit
import PhotosUI
import MediaPlayer

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentCameraController()
        self.listenVolumeButton()
    }

    var outputVolumeObserve: NSKeyValueObservation?
    let audioSession = AVAudioSession.sharedInstance()
    
    
    

    func listenVolumeButton() {
        do {
            try audioSession.setActive(true)
        } catch {}

        outputVolumeObserve = audioSession.observe(\.outputVolume) { (audioSession, changes) in
            print("\(changes)")
            MPVolumeView.setVolume(0.5)
        }
    }
    
    func presentCameraController() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
//        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
        presentCameraController()
    }
}

extension MPVolumeView {
  static func setVolume(_ volume: Float) {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
      slider?.value = volume
    }
  }
}
