//
//  ViewController.h
//  KIST
//
//  Created by MSL on 2013. 12. 17..
//  Copyright (c) 2013년 MSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/highgui/cap_ios.h>
#import <opencv2/core/core_c.h>
#import <SmartBooklet/SmartBooklet.h>   // KIST SmartBooklet Frameworks header
#include <SmartBooklet/ARResult.h>

@interface ViewController : UIViewController<CvVideoCameraDelegate>{
    IBOutlet UIImageView * cameraView;
    CvVideoCamera * camera;
    SmartBooklet * msl;
    
    CvPoint	landmark_roi[4];
    ARResult ret;
}
@property (nonatomic, strong) CvVideoCamera *camera;
@end
