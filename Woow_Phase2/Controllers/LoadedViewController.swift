//
//  LoadedViewController.swift
//  Woow_Phase2
//
//  Created by Vikas MacBook on 29/12/22.
//

import UIKit
import Lottie

class LoadedViewController: UIViewController {
    
    @IBOutlet weak var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()

        animationView = .init(name: "loading")
         
         animationView!.frame = view.bounds
         
         // 3. Set animation content mode
         
         animationView!.contentMode = .scaleAspectFit
         
         // 4. Set animation loop mode
         
         animationView!.loopMode = .loop
         
         // 5. Adjust animation speed
         
         animationView!.animationSpeed = 0.5
         
         view.addSubview(animationView!)
         
         // 6. Play animation
         
         animationView!.play()
             }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
