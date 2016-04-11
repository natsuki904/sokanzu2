//
//  thirdViewController.swift
//  sokanzu
//
//  Created by USER on 2016/02/15.
//  Copyright © 2016年 Natsuki Teruya. All rights reserved.
//

import UIKit
import iAd
import AssetsLibrary

class  thirdViewController_copy: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var thirdView: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var memberName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var myiAd: ADBannerView!
    
    var memberNumber:Int = 0
    var str:String = ""
    var str2:String = ""
    var inputFlg = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextBtn.layer.cornerRadius = 10
        self.createBtn.layer.cornerRadius = 10
    
        imageView.image = UIImage(named: "noImage.png")!
        str = String(memberNumber)
        print(str)
        var myAp = UIApplication.sharedApplication().delegate as! AppDelegate
        var myAp2 = myAp.myCount+1
        var myAp3:String = String(myAp2)
        number.text = myAp3
        str2 = memberName.text!
        
        //広告
        self.myiAd.hidden = true
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var textFieldString = textField.text! as NSString
        textFieldString = textFieldString.stringByReplacingCharactersInRange(range, withString: string)
        
        // ↓trueを返すことで入力が確定する
        return true
    }
    
    @IBAction func tapField(sender: UITextField) {
//         テキストフィールドと写真を登録すると次へ進める
        if memberName.text != "" && imageView.image != UIImage(named: "noImage.png"){
            nextBtn.enabled = true
            createBtn.enabled = true
        }

    }

    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        
        //アラートをつくる
        var alertController = UIAlertController(
            title: "メッセージ",
            message: "写真を選択する方法を選んで下さい",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        //アルバムボタンを追加
        alertController.addAction(UIAlertAction(
            title: "アルバムから選択",
            style: .Default,
            handler: {action in self.Album() }))
        //カメラボタンを追加
        alertController.addAction(UIAlertAction(
            title: "カメラから選択",
            style: .Default,
            handler: {action in self.Camera() }))
        //キャンセルボタンを追加
        alertController.addAction(UIAlertAction(
            title: "キャンセル",
            style: .Cancel,
            handler: { action in print("キャンセル")}))
        //アラートを表示する
        presentViewController(alertController,
            animated: true,
            completion: nil)
    }
    
    func Album() {
        // フォトライブラリを使用できるか確認
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            // フォトライブラリの画像・写真選択画面を表示
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    func Camera() {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.presentViewController(cameraPicker, animated: true, completion: nil)
            
        }
    }
    
    // 撮影が完了時した時・ライブラリを選択した後に呼ばれる
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if  info[UIImagePickerControllerReferenceURL] == nil {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageView.contentMode = .ScaleAspectFit
                imageView.image = pickedImage
//                let image:UIImage! = imageView.image
//                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            }
            
            
            //メタデータを保存するためにはAssetsLibraryを使用する
            var library : ALAssetsLibrary = ALAssetsLibrary()
            library.writeImageToSavedPhotosAlbum(imageView.image!.CGImage,metadata: info[UIImagePickerControllerMediaMetadata] as! [NSObject : AnyObject], completionBlock:{
                (assetURL: NSURL!, error: NSError!) -> Void in

                let url = NSURL(string: assetURL.description)
                
                //ユーザーデフォルトを用意する
                var myDefault = NSUserDefaults.standardUserDefaults()
                
                var peopleList:[NSDictionary] = []
                
                if myDefault.arrayForKey("myString2") != nil {
                    var myStr:Array = myDefault.arrayForKey("myString2")!
                    
                    if myStr.count > 0 {
                        peopleList = myStr as! NSArray as! [NSDictionary]
                    }
                }
                
                var data:NSDictionary = ["name":self.memberName.text!, "image":assetURL.description]
                peopleList.append(data)
                
                
                //データを書き込んで
                myDefault.setObject(peopleList, forKey: "myString2")
                //即反映させる
                myDefault.synchronize()
            })
            
            //閉じる処理
            imagePicker.dismissViewControllerAnimated(true, completion: nil)

        } else {
            let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]!
            let url = NSURL(string: assetURL.description)
            
            //ユーザーデフォルトを用意する
            var myDefault = NSUserDefaults.standardUserDefaults()
            
            var peopleList:[NSDictionary] = []
            
            if myDefault.arrayForKey("myString2") != nil {
                var myStr:Array = myDefault.arrayForKey("myString2")!
                
                if myStr.count > 0 {
                    peopleList = myStr as! NSArray as! [NSDictionary]
                }
                
            }
            
            var data:NSDictionary = ["name":memberName.text!, "image":assetURL.description]
            peopleList.append(data)
            
            
            //データを書き込んで
            myDefault.setObject(peopleList, forKey: "myString2")
            //即反映させる
            myDefault.synchronize()
            
            //閉じる処理
            imagePicker.dismissViewControllerAnimated(true, completion: nil)
            
                    // テキストフィールドと写真を登録すると次へ進める
                    if memberName.text != "" && imageView.image != "noImage.png" {
                        nextBtn.enabled = true
                        createBtn.enabled = true
                    }

            
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageView.contentMode = .ScaleAspectFit
                imageView.image = pickedImage
            }

        }
       
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        
//        // 選択した画像・写真を取得し、imageViewに表示
//        if let info = editingInfo, let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
//            imageView.image = editedImage
//        }else{
//            imageView.image = image
//        }
//        
//        // フォトライブラリの画像・写真選択画面を閉じる
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        
//        
//        let assetURL:AnyObject = editingInfo![UIImagePickerControllerReferenceURL]!
//        let url = NSURL(string: assetURL.description)
//        
//      
//        //ユーザーデフォルトを用意する
//        var myDefault = NSUserDefaults.standardUserDefaults()
//        
//        var peopleList:[NSDictionary] = []
//        
//        if myDefault.arrayForKey("myString2") != nil {
//            var myStr:Array = myDefault.arrayForKey("myString2")!
//            
//            if myStr.count > 0 {
//                peopleList = myStr as! NSArray as! [NSDictionary]
//            }
//        
//        }
//        
//        var data:NSDictionary = ["name":memberName.text!, "image":assetURL.description]
//        peopleList.append(data)
//        print(peopleList)
//        
//        
//        //データを書き込んで
//        myDefault.setObject(peopleList, forKey: "myString2")
//        //即反映させる
//        myDefault.synchronize()
//
//    }
//    
    
    override func viewWillAppear(animated: Bool) {
        
        self.inputFlg = false
        var myAp = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if str == "3" {
            if myAp.myCount == 2{
                // 非表示
                self.nextBtn.hidden = true
                self.createBtn.hidden = false
            }else{
                // 表示
                self.nextBtn.hidden = false
                self.createBtn.hidden = true
                
            }
        }
        if str == "2" {
            if myAp.myCount == 1{
                // 非表示
                self.nextBtn.hidden = true
                self.createBtn.hidden = false
            }else{
                // 表示
                self.nextBtn.hidden = false
                self.createBtn.hidden = true
                
            }
        }
        
    }
    
    
    @IBAction func tapCreate(sender: UIButton) {
        
        self.inputFlg = false
            if str == "2" {
                let fourVC:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "two" )
                self.presentViewController( fourVC as! UIViewController, animated: true, completion: nil)
            } else if str == "3" {
                let fiveVC:AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "three" )
                self.presentViewController( fiveVC as! UIViewController, animated: true, completion: nil)
                
            } else {

            var alertController = UIAlertController(
                title: "エラー",
                message: "もう一度やり直して下さい",
                preferredStyle: .Alert)
            //OKボタンを追加
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: {action in print("OK") }))
            //アラートを表示する
            presentViewController(alertController,
                animated: true,
                completion: nil)

        }
        
    }
    
    // Segueで画面遷移する時
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showThirdView" {
            var thirdVC = segue.destinationViewController as! thirdViewController_copy
            
            //AppDelegateにアクセスするための準備をして
            var myAp = UIApplication.sharedApplication().delegate as! AppDelegate
            //プロパティの値を書き換える
            myAp.myCount++
            print(myAp.myCount)
        
            //何人目か
            var memberNumberInt:Int = memberNumber
            thirdVC.memberNumber = memberNumberInt
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
