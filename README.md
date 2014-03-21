KIST-SmartBooklet
=================

# SmartBooklet
## Database

ID | 지역 
---|------- 
0 | 광화문 
1 | 시청 
2 | 청계천, 종로
3 | 인사동
4 | 삼청동, 북촌
5 | 명동, 을지로(표시 - 명동성당)
6 | 남대문 시장(표시 - 숭례문)
7 | 홍대, 상수역 주변
8 | 신촌, 이대
9 | 동대문 시장
10 | 이태원
11 | 잠실
12 | 압구정, 청담동
13 | 삼성역
14 | 강남역
15 | 신사동, 가로수길


## Usage

### Declaration
`ViewController.h`에 `SmartBooklet` 객체 선언
```Objective-C
#import <SmartBooklet/SmartBooklet.h>   // KIST SmartBooklet Frameworks header
#include <SmartBooklet/ARResult.h>

@interface ViewController : UIViewController<CvVideoCameraDelegate>{
   ...
   SmartBooklet * msl;
   ARResult ret;
   ...
}
```

### Initialize
`ViewController.mm`의 `viewDidLoad` 함수에서 초기화
```Objective-C
- (void)viewDidLoad
{
   ...
   msl = [SmartBooklet alloc];
   ...
}
```

### AR Result
모든 처리 후에 결과는 `ARResult` 구조체에 저장됨(구조체 정의는 Framework에 `ARResult.h` 참조)
```Objective-C
typedef struct {
    int ID;
    cv::Point2f* point;
    CvMat rotation;
    CvMat translation;
    Mat homography;
}ARResult;
```
이름 | 설명
-----|----------
 ID | 인식된 지도 Index 
 point | 인식된 지도의 4 코너점 
 rotation | Extrinsic Parameter - 회전 행렬(CV_32FC1행, 3x1) 
 translation | Extrinsic Parameter - 회전 행렬(CV_32FC1행, 3x1) 
 homography | 인식된 지도의 Homography 행렬(CV_32FC1행, 3x3) 



### Process
1. `ViewController.mm`의 `processImage` 함수에서 newImage 함수 호출
1. 인식 결과 리턴 (`ret = [msl getARResult]`)
1. 인식 성공하면(`[msl isMatched] == true`) 정보 증강

Processing 함수 예제
```Objective-C
- (void)processImage:(cv::Mat&)image;
{
   [msl newImage: image];
   ret = [msl getARResult];

    if([msl isMatched])
    {
        if(ret.ID == 5)    // 명동 지도 인식
        {
            // Landmark(ex. 명동성당) 출력
            vector<cv::Point2f> landmark_obj_corners1(4);
            landmark_obj_corners1[0] = cvPoint( 300, 30);
            landmark_obj_corners1[1] = cvPoint( 390, 30 );
            landmark_obj_corners1[2] = cvPoint( 390, 80);
            landmark_obj_corners1[3] = cvPoint( 300, 80 );
            
            perspectiveTransform( landmark_obj_corners1, landmark_dst_matching_corners, ret.homography);
            
            drawRect(landmark_dst_matching_corners);
        }
        
        ...
    }
    ...
}
```



# Distribution
## Meaning
- 성능 테스트 등의 목적으로 최종 형태의 데모 Application 설치

## Howto
- jonghoon.seo@gmail.com 으로 메일 주시면 [TestFlight](https://www.testflightapp.com/) 통해 배포
