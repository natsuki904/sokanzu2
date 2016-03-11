//
//  ViewController.swift
//  sokanzu
//
//  Created by USER on 2016/02/15.
//  Copyright © 2016年 Natsuki Teruya. All rights reserved.
//

import UIKit
import iAd


class ViewController: UIViewController,UIViewControllerTransitioningDelegate {



    @IBOutlet weak var myTitle: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var myiAd: ADBannerView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      保存データを全削除
        let userDefault = NSUserDefaults.standardUserDefaults()
        var appDomain:String = NSBundle.mainBundle().bundleIdentifier!; NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        myTitle.image = UIImage(named: "半沢風.jpg")
        
        self.startBtn.layer.cornerRadius = 5
        
        
        //AppDelegateにアクセスするための準備をして
        var myAp = UIApplication.sharedApplication().delegate as! AppDelegate
        //プロパティの値を書き換える
        myAp.myCount = 0

        self.canDisplayBannerAds = true
        

        //広告
        self.myiAd.hidden = true

    }
    
    @IBAction func boomAction(sender: AnyObject) {

        let secondVC:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "one" )
        self.presentViewController( secondVC as! UIViewController, animated: true, completion: nil)

    }

    let transition = BubbleTransition()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = startBtn.center
        transition.bubbleColor = startBtn.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = startBtn.center
        transition.bubbleColor = startBtn.backgroundColor!
        return transition
    }
    
    
    // バナーに広告が表示された時
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.myiAd.hidden = false
    }
    
    //バナーがクリックされた時
    func bannerViewActionShouldBegin(banner: ADBannerView!,willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    //広告表示にエラーが発生した場合
    func bannerView(banner:ADBannerView!,didFailToReceiveAdWithError:NSError!) {
        self.myiAd.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}

