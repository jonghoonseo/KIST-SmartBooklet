//
//  ViewController.m
//  KIST
//
//  Created by MSL on 2013. 12. 17..
//  Copyright (c) 2013년 MSL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize camera;

- (void)viewDidLoad
{
    [super viewDidLoad];
    camera = [[CvVideoCamera alloc] initWithParentView:cameraView];
    camera.delegate = self;
    
    
    NSArray *devices = [AVCaptureDevice devices];
    NSError *error;
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            [device lockForConfiguration:&error];
            if ([device isFocusModeSupported:AVCaptureFocusModeLocked]) {
                device.focusMode = AVCaptureFocusModeLocked;
            }
            
            [device unlockForConfiguration];
        }
    }
    
    camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack; //장치 설정
    camera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720; //사이즈 설정
    camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight; //방향 설정
    camera.defaultFPS = 30; // 프레임률
    
    [camera start];
    NSLog(@"%f", 1.0);
    msl = [SmartBooklet alloc];

}


- (void)processImage:(cv::Mat&)image;
{
    [msl newImage: image];
    ARResult ret = [msl getARResult];
    
    if([msl isMatched])
    {
        vector<cv::Point2f>	 landmark_dst_matching_corners(4);
        bool drawRect = false;
        float ratio = 0.7;
        
        
        
//        ret.homography.at<float>(0,0) /= IMAGE_SIZE;
//        ret.homography.at<float>(1,1) /= IMAGE_SIZE;
        if(ret.ID == 5)
        {
            vector<cv::Point2f> landmark_obj_corners1(4);
            landmark_obj_corners1[0] = cvPoint( 300, 30);
            landmark_obj_corners1[1] = cvPoint( 390, 30 );
            landmark_obj_corners1[2] = cvPoint( 390, 80);
            landmark_obj_corners1[3] = cvPoint( 300, 80 );
            
//            landmark_obj_corners1[0] = cvPoint( 0, 0);
//            landmark_obj_corners1[1] = cvPoint( 100, 0 );
//            landmark_obj_corners1[2] = cvPoint( 100, 100);
//            landmark_obj_corners1[3] = cvPoint( 0, 100 );
            
            perspectiveTransform( landmark_obj_corners1, landmark_dst_matching_corners, ret.homography);
            
            for(int i=0; i<4; ++i)
            {
                landmark_roi[i].x = landmark_dst_matching_corners[i].x * ratio + landmark_roi[i].x * (1-ratio);
                landmark_roi[i].y = landmark_dst_matching_corners[i].y * ratio + landmark_roi[i].y * (1-ratio);
            }
            
            drawRect = true;
        }
        else if(ret.ID == 6)
        {
            vector<cv::Point2f> landmark_obj_corners1(4);
            landmark_obj_corners1[0] = cvPoint( 200, 400);
            landmark_obj_corners1[1] = cvPoint( 250, 400 );
            landmark_obj_corners1[2] = cvPoint( 250, 330);
            landmark_obj_corners1[3] = cvPoint( 200, 330 );
            
            perspectiveTransform( landmark_obj_corners1, landmark_dst_matching_corners, ret.homography);

            for(int i=0; i<4; ++i)
            {
                landmark_roi[i].x = landmark_dst_matching_corners[i].x * ratio + landmark_roi[i].x * (1-ratio);
                landmark_roi[i].y = landmark_dst_matching_corners[i].y * ratio + landmark_roi[i].y * (1-ratio);
            }
            
            drawRect = true;
        }else
            drawRect = false;
        
        for(int j=0; j<4; ++j)
        {
            cv::line(image, cvPoint(ret.point[j].x/IMAGE_SIZE,ret.point[j].y/IMAGE_SIZE), cvPoint(ret.point[(j+1)%4].x/IMAGE_SIZE,ret.point[(j+1)%4].y/IMAGE_SIZE), cv::Scalar(255, 0, 0, 255), 15);
            if(drawRect)
            cv::line(image, cvPoint(landmark_roi[j].x/IMAGE_SIZE,landmark_roi[j].y/IMAGE_SIZE), cvPoint(landmark_roi[(j+1)%4].x/IMAGE_SIZE,landmark_roi[(j+1)%4].y/IMAGE_SIZE), cv::Scalar(0, 0, 255, 255), 10);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    camera.delegate = nil;
}


//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//
//}
@end
