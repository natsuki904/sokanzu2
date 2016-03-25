//
//  fiveViewController.swift
//  sokanzu
//
//  Created by USER on 2016/02/22.
//  Copyright © 2016年 Natsuki Teruya. All rights reserved.
//

import UIKit
import Social
import Photos
import iAd

class fiveViewController: UIViewController {


    @IBOutlet weak var textField1: UILabel!
    @IBOutlet weak var textField2: UILabel!
    @IBOutlet weak var textField3: UILabel!
    @IBOutlet weak var comment1: UITextView!
    @IBOutlet weak var comment2: UITextView!
    @IBOutlet weak var comment3: UITextView!
    @IBOutlet weak var relationshipRight: UILabel!
    @IBOutlet weak var relationshipRight2: UILabel!
    @IBOutlet weak var relationshipMiddle: UILabel!
    @IBOutlet weak var relationshipMiddle2: UILabel!
    @IBOutlet weak var relationshipLeft: UILabel!
    @IBOutlet weak var relationshipLeft2: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var yajirushi1: UIImageView!
    @IBOutlet weak var yajirushi2: UIImageView!
    @IBOutlet weak var yajirushi3: UIImageView!
    @IBOutlet weak var myiAd: ADBannerView!
    
    var memberNumber:Int = 0
    
    @IBAction func tapImage(sender: AnyObject) {
        (sender as! UITapGestureRecognizer).enabled = false
        delay(0, task: {self.image1.boom()})

    }
    
    @IBAction func tapImage2(sender: AnyObject) {
        (sender as! UITapGestureRecognizer).enabled = false
        delay(0, task: {self.image2.boom()})

    }
    
    @IBAction func tapImage3(sender: AnyObject) {
        (sender as! UITapGestureRecognizer).enabled = false
        delay(0, task: {self.image3.boom()})

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
        var member3 = myStr[2]["name"]
        var member1Str = member1 as! String
        var member2Str = member2 as! String
        var member3Str = member3 as! String

        var twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twitterVC.setInitialText("\(member1Str)と\(member2Str)と\(member3Str)の関係")
        twitterVC.addImage(self.snapShot())
        //message表示
        presentViewController(twitterVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画像の読み込み
        yajirushi1.image = UIImage(named: "yajirushi1.png")!
        yajirushi2.image = UIImage(named: "yajirushi1.png")!
        yajirushi3.image = UIImage(named: "yajirushi1.png")!
        
        // 角度指定？
        var angle1:CGFloat = CGFloat((120 * M_PI) / 180.0)
        var angle2:CGFloat = CGFloat((240 * M_PI) / 180.0)
        
        // 回転用のアフィン行列を生成
        yajirushi1.transform = CGAffineTransformMakeRotation(angle1)
        yajirushi2.transform = CGAffineTransformMakeRotation(angle2)
        
        //ユーザーデフォルトの読み込み
        var myDefault = NSUserDefaults.standardUserDefaults()
        var myStr:NSArray = myDefault.arrayForKey("myString2")!
        var member1 = myStr[0]["name"]
        var member2 = myStr[1]["name"]
        var member3 = myStr[2]["name"]
        var imageStr1 = myStr[0]["image"]
        var imageStr2 = myStr[1]["image"]
        var imageStr3 = myStr[2]["image"]
        
        //一人目の名前
        textField1.text = member1 as! String
        //二人目の名前
        textField2.text = member2 as! String
        //三人目の名前
        textField3.text = member3 as! String
        
        
        //      assetURLの読み込み
        var imageURL1 = NSURL(string: imageStr1 as! String)!
        var imageURL2 = NSURL(string: imageStr2 as! String)!
        var imageURL3 = NSURL(string: imageStr3 as! String)!
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
        //       三人目の写真
        let fetchResult3: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([imageURL3], options: nil)
        let asset3: PHAsset = fetchResult3.firstObject as! PHAsset
        let manager3: PHImageManager = PHImageManager()
        manager3.requestImageForAsset(asset3,
            targetSize: CGSizeMake(100, 100),
            contentMode: .AspectFill,
            options: nil) { (image, info) -> Void in
                
                self.image3.image = image
        }
        
        //広告
        self.myiAd.hidden = true
    }
    
    
    override func viewWillAppear(animated: Bool){
        //-- json.txtファイルを読み込んで
        let path = NSBundle.mainBundle().pathForResource("json", ofType: "txt")
        let jsondata = NSData(contentsOfFile: path!)
        //-- 辞書データに変換して
        let jsonArray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
        
        var a = arc4random_uniform(10)
        var b = arc4random_uniform(10)
        var c = arc4random_uniform(10)
        var d = arc4random_uniform(10)
        var e = arc4random_uniform(10)
        var f = arc4random_uniform(10)
        var ransu1:Int = Int(a)
        var ransu2:Int = Int(b)
        var ransu3:Int = Int(c)
        var ransu4:Int = Int(d)
        var ransu5:Int = Int(e)
        var ransu6:Int = Int(f)

        
        let dic1 = jsonArray[ransu1]
        let dic2 = jsonArray[ransu2]
        let dic3 = jsonArray[ransu3]
        let dic4 = jsonArray[ransu4]
        let dic5 = jsonArray[ransu5]
        let dic6 = jsonArray[ransu6]
        comment1.text = dic1["comment"] as! String
        comment2.text = dic2["comment"] as! String
        comment3.text = dic3["comment"] as! String
        relationshipRight.text = dic1["relationship"] as! String
        relationshipRight2.text = dic5["relationship"] as! String
        relationshipMiddle.text = dic2["relationship"] as!String
        relationshipMiddle2.text = dic6["relationship"] as!String
        relationshipLeft.text = dic3["relationship"] as! String
        relationshipLeft2.text = dic4["relationship"] as! String
    }

    
    @IBAction func tapTop(sender: UIButton) {
        let fourVC:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "top" )
        self.presentViewController( fourVC as! UIViewController, animated: true, completion: nil)
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
