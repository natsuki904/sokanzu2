//
//  fourthViewController.swift
//  sokanzu
//
//  Created by USER on 2016/02/15.
//  Copyright © 2016年 Natsuki Teruya. All rights reserved.
//

import UIKit
import Social
import Photos
import iAd

class fourthViewController: UIViewController {

    @IBOutlet weak var textField1: UILabel!
    @IBOutlet weak var textField2: UILabel!
    @IBOutlet weak var comment1: UITextView!
    @IBOutlet weak var comment2: UITextView!
    @IBOutlet weak var relationshipUp: UILabel!
    @IBOutlet weak var relationshipDown: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var yajirushi1: UIImageView!
    @IBOutlet weak var myiAd: ADBannerView!

    
    var memberNumber:Int = 0
    
    @IBAction func tapImage1(sender: AnyObject) {
        (sender as! UITapGestureRecognizer).enabled = false
        delay(0, task: {self.image1.boom()})

    }
    
    typealias Task = (cancel : Bool) -> ()

    
    func delay(time:NSTimeInterval, task:()->()) ->  Task? {
        
        func dispatch_later(block:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(time * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                block)
        }
        
        var closure: dispatch_block_t? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    dispatch_async(dispatch_get_main_queue(), internalClosure);
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(cancel: false)
            }
        }
        
        return result;
    }

    
    
    @IBAction func tapImage2(sender: AnyObject) {
        (sender as! UITapGestureRecognizer).enabled = false
        delay(0, task: {self.image2.boom()})

    }
    
    

    func snapShot() -> UIImage {
        // キャプチャする範囲を取得.
        let rect = self.view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        self.view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @IBAction func tapShare(sender: UIButton) {
        //ユーザーデフォルトの読み込み
        var myDefault = NSUserDefaults.standardUserDefaults()
        var myStr:NSArray = myDefault.arrayForKey("myString2")!
        var member1 = myStr[0]["name"]
        var member2 = myStr[1]["name"]
        var member1Str = member1 as! String
        var member2Str = member2 as! String
        
        var twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        twitterVC.setInitialText("\(member1Str)と\(member2Str)の相関図")
        twitterVC.addImage(self.snapShot())
        //message表示
        presentViewController(twitterVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ユーザーデフォルトの読み込み
        var myDefault = NSUserDefaults.standardUserDefaults()
        var myStr:NSArray = myDefault.arrayForKey("myString2")!
        var member1 = myStr[0]["name"]
        var member2 = myStr[1]["name"]
        var imageStr1 = myStr[0]["image"]
        var imageStr2 = myStr[1]["image"]
        
        //一人目の名前
        textField1.text = member1 as! String
        //二人目の名前
        textField2.text = member2 as! String
        
        
//      assetURLの読み込み
        var imageURL1 = NSURL(string: imageStr1 as! String)!
        var imageURL2 = NSURL(string: imageStr2 as! String)!
//      一人目の写真
        let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([imageURL1], options: nil)
        let asset: PHAsset = fetchResult.firstObject as! PHAsset
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(asset,
            targetSize: CGSizeMake(100, 100),
            contentMode: .AspectFill,
            options: nil) { (image, info) -> Void in
                
                self.image1.image = image
        }
//       二人目の写真
        let fetchResult2: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([imageURL2], options: nil)
        let asset2: PHAsset = fetchResult2.firstObject as! PHAsset
        let manager2: PHImageManager = PHImageManager()
        manager2.requestImageForAsset(asset2,
            targetSize: CGSizeMake(100, 100),
            contentMode: .AspectFill,
            options: nil) { (image, info) -> Void in
                
                self.image2.image = image
        }
        
        yajirushi1.image = UIImage(named: "yajirushi1.png")
        
        //広告
        self.myiAd.hidden = true

    }
    
    
    override func viewWillAppear(animated: Bool){
        //-- json.txtファイルを読み込んで
        let path = NSBundle.mainBundle().pathForResource("json", ofType: "txt")
        let jsondata = NSData(contentsOfFile: path!)
        //-- 辞書データに変換して
        let jsonArray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
        
        var n = arc4random_uniform(7)
        var t = arc4random_uniform(10)
        var ransu1:Int = Int(n)
        print(ransu1)
        var ransu2:Int = Int(t)
        print(ransu2)
        
        let dic1 = jsonArray[ransu1]
        let dic2 = jsonArray[ransu2]
        comment1.text = dic1["comment"] as! String
        comment2.text = dic2["comment"] as! String
        relationshipUp.text = dic1["relationship"] as! String
        relationshipDown.text = dic2["relationship"] as! String
    
    }
    
    
    @IBAction func tapTop(sender: UIButton) {
        let fourVC:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "top" )
        self.presentViewController( fourVC as! UIViewController, animated: true, completion: nil)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
