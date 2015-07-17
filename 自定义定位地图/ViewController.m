//
//  ViewController.m
//  自定义定位地图
//
//  Created by admin on 15/7/1.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import "ViewController.h"
#import "LQMapView.h"
#import "LQLocationView.h"
#import "LQAnnotationButton.h"
#import <BaiduMapAPI/BMapKit.h>
#import "MJExtension.h"
#import "LQCoordinate.h"
#import "LQPopView.h"
#import "LQViewControllerOne.h"
#import <AVFoundation/AVFoundation.h>

@class LatitudeAndLongitude;


#define annotationBtnLatLongJson @{@"latitudeAndLongitudeArray":@[@{@"latitude":@31.642133,@"longitude":@120.372033,@"soundName":@"你是我的眼"},@{@"latitude":@31.640753,@"longitude":@120.373404,@"soundName":@"父亲"}]}

@interface ViewController ()<BMKLocationServiceDelegate,AVAudioPlayerDelegate,LQMapViewDelegate,LQPopViewDelegate>

@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, weak)   LQLocationView     *locationview;
@property (nonatomic, weak)   LQMapView          *mapView;
@property (nonatomic, weak)   LQAnnotationButton *annotationBtn;
@property (nonatomic, weak)   LQPopView          *popView;
@property (nonatomic, assign) CGFloat             newLongitude;
@property (nonatomic, assign) CGFloat             newlatitude;
@property (nonatomic, assign) CGFloat             oldMapViewScale;
@property (nonatomic, strong) NSMutableArray     *annotationBtnArray;
@property (nonatomic, strong) AVAudioPlayer      *avAudio;
@property (nonatomic, assign) int annotationBtnNum;

@end

@implementation ViewController

- (NSMutableArray *)annotationBtnArray
{
    if (_annotationBtnArray == nil) {
        _annotationBtnArray = [NSMutableArray array];
    }
    
    return _annotationBtnArray;
}

- (LQMapView *)mapView
{
    if (_mapView == nil) {
        LQMapView *mapView = [LQMapView mapView];
        [self.view addSubview:mapView];
        _mapView = mapView;
        _mapView.delegate = self;
    }
    
    return _mapView;
}

- (LQLocationView *)locationview
{
    if (_locationview == nil) {
        LQLocationView *locationview = [LQLocationView locationViewWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.mapView.scrollView addSubview:locationview];
        _locationview = locationview;
    }
    
    return _locationview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
    {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.oldMapViewScale = self.mapView.scrollView.zoomScale;

    //添加标注位置
    [self addAnnotationBtn];
    
    //定位
    BMKLocationService* locService = [[BMKLocationService alloc] init];
    self.locService = locService;
    self.locService.delegate = self;
    [self.locService startUserLocationService];
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService  setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:10.f];
}

#pragma mark - 添加标注位置
/**
 *  添加标注位置
 */
- (void)addAnnotationBtn
{
    NSDictionary *dic = annotationBtnLatLongJson;
    LQCoordinate *coordinates = [LQCoordinate objectWithKeyValues:dic];
    
    NSMutableArray *coordinateArray = [self didCalculatePointCoordinateWithPointArray:coordinates.latitudeAndLongitudeArray];
    for (NSDictionary *coordinateDic in coordinateArray)
    {
        double x = [coordinateDic[@"x"] doubleValue];
        double y = [coordinateDic[@"y"] doubleValue];
        
        LQAnnotationButton *annotationBtn = [LQAnnotationButton annotationButton];
        annotationBtn.center = CGPointMake(x, y);
        [self.mapView.scrollView addSubview:annotationBtn];
        [annotationBtn addTarget:self action:@selector(showPopView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.annotationBtnArray addObject:annotationBtn];
    }
}

#pragma mark - 播放语音
/**
 *  播放语音
 */
- (void)playSongWithSoundName:(NSString *)soundName
{
    if (self.avAudio == nil)
    {
        NSString *str = [[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:str];
        
        self.avAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];//使用本地URL创建
        self.avAudio.volume = 0.8;
        self.avAudio.numberOfLoops = 3;//默认只播放一次
        self.avAudio.delegate = self;
        [self.avAudio prepareToPlay];//分配播放所需的资源，并将其加入内部播放队列
    }
    
    [self.avAudio play];//播放
}

#pragma mark - 展示景点popView
/**
 *  展示景点popView
 */
- (void)showPopView:(LQAnnotationButton *)button
{
    for (int i = 0; i < self.annotationBtnArray.count; i++)
    {
        LQAnnotationButton *btn = self.annotationBtnArray[i];
        if (button == btn)
        {
            self.annotationBtnNum = i;
        }
    }
    
    self.annotationBtn = button;
    [self addPopViewWithAnnotationBtnFrame:self.annotationBtn.frame];
}

#pragma mark - 添加标注弹出视图
/**
 *  添加标注弹出视图
 */
- (void)addPopViewWithAnnotationBtnFrame:(CGRect)annotationBtnFrame
{
    CGFloat popViewW = 150;
    CGFloat popViewH = 100;
    CGFloat popViewX = CGRectGetMidX(annotationBtnFrame) - popViewW * 0.5;
    CGFloat popViewY = CGRectGetMinY(annotationBtnFrame) - popViewH;
    CGRect frame = CGRectMake(popViewX, popViewY, popViewW, popViewH);
    
    //删除上一个景点popView
    [self.popView removeFromSuperview];
    self.popView = nil;
    
    LQPopView *popView = [LQPopView popViewWithFrame:frame];
    popView.delegate = self;
    [self.mapView.scrollView addSubview:popView];
    self.popView = popView;
    self.popView.hidden = NO;
    
    //关闭上一个景点的语音
    self.avAudio = nil;
}

#pragma mark - 处理位置坐标更新
/**
 *  处理位置坐标更新
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    double x = userLocation.location.coordinate.longitude;//纬度
    double y = userLocation.location.coordinate.latitude;//经度
    
    self.newLongitude = x;
    self.newlatitude = y;
    
    [self updateLocation];
}

#pragma mark - 计算坐标
/**
 *  计算坐标
 */
- (NSDictionary *)didCalculateCoordinateWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    double xx = ((longitude-120.368523) * (self.mapView.scrollView.contentSize.width))/(120.382698-120.368523);
    double yy = ((31.64577-latitude) * (self.mapView.scrollView.contentSize.height))/(31.64577-31.639129);
    
    NSDictionary *coordinateDic = @{@"x":[NSNumber numberWithDouble:xx],@"y":[NSNumber numberWithDouble:yy]};
    
    return coordinateDic;
}

#pragma mark - 更新我的定位坐标
/**
 *  更新我的定位坐标
 */
- (void)updateLocation
{
    NSDictionary *coordinateDic = [self didCalculateCoordinateWithLatitude:self.newlatitude Longitude:self.newLongitude];
    double x = [coordinateDic[@"x"] doubleValue];
    double y = [coordinateDic[@"y"] doubleValue];
    self.locationview.center = CGPointMake(x, y);
    self.locationview.geoPointCompass.latitudeOfTargetedPoint = self.newlatitude;
    self.locationview.geoPointCompass.longitudeOfTargetedPoint = self.newLongitude;
}

#pragma mark - 更新标注点位置
/**
 *  更新标注点位置
 */
- (void)updateAnnotationBtn
{
    NSDictionary *dic = annotationBtnLatLongJson;
    LQCoordinate *coordinates = [LQCoordinate objectWithKeyValues:dic];
    
    for (int i = 0; i < coordinates.latitudeAndLongitudeArray.count; i++)
    {
        LatitudeAndLongitude *latLong = coordinates.latitudeAndLongitudeArray[i];
        
        NSDictionary *coordinateDic = [self didCalculateCoordinateWithLatitude:latLong.latitude Longitude:latLong.longitude];
        double x = [coordinateDic[@"x"] doubleValue];
        double y = [coordinateDic[@"y"] doubleValue];
        
        UIButton *btn = self.annotationBtnArray[i];
        btn.center = CGPointMake(x, y);
    }
}

#pragma mark - 更新标注弹出视图位置
/**
 *  更新标注弹出视图位置
 */
- (void)updatePopView
{
    CGFloat popViewCenterX = self.annotationBtn.center.x;
    CGFloat popViewCenterY = self.annotationBtn.center.y - CGRectGetHeight(self.popView.frame) * 0.5 - CGRectGetHeight(self.annotationBtn.frame) * 0.5;
    
    self.popView.center = CGPointMake(popViewCenterX, popViewCenterY);
}

#pragma mark - 批量计算点坐标
/**
 *  批量计算点坐标
 */
- (NSMutableArray *)didCalculatePointCoordinateWithPointArray:(NSArray *)pointArray
{
    NSMutableArray *coordinateArray = [NSMutableArray array];
    
    for (LatitudeAndLongitude *latLong in pointArray)
    {
        NSDictionary *coordinateDic = [self didCalculateCoordinateWithLatitude:latLong.latitude Longitude:latLong.longitude];
        [coordinateArray addObject:coordinateDic];
    }
    return coordinateArray;
}

#pragma mark - 画路径线
/**
 *  画路径线
 */
- (void)drawLineWithImageView:(UIImageView *)imageView
{
    NSDictionary *scenicsDic = @{@"latitudeAndLongitudeArray":@[
                                            @{@"latitude":@31.641064,@"longitude":@120.370777},
                                            @{@"latitude":@31.640753,@"longitude":@120.37273},
                                            @{@"latitude":@31.641641,@"longitude":@120.372721},
                                            @{@"latitude":@31.642052,@"longitude":@120.373404}
                                            ]};
    LQCoordinate *coordinates = [LQCoordinate objectWithKeyValues:scenicsDic];
    NSMutableArray *coordinateArray = [self didCalculatePointCoordinateWithPointArray:coordinates.latitudeAndLongitudeArray];

    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    for (int i = 0; i < coordinateArray.count; i++)
    {
        double x = [coordinateArray[i][@"x"] doubleValue];
        double y = [coordinateArray[i][@"y"] doubleValue];
        
        if (i == 0)
        {
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);  //起点坐标
        }else
        {
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x, y);   //终点坐标
        }
    }
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - AVAudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    //播放结束时执行的动作
    NSLog(@"播放结束时执行的动作");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error
{
    //解码错误执行的动作
    NSLog(@"解码错误执行的动作");
}

- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player
{
    //处理中断的代码
    NSLog(@"处理中断的代码");
}

- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player
{
    //处理中断结束的代码
    NSLog(@"处理中断结束的代码");
}

#pragma mark - mapViewDelegate
/**
 *  地图放大缩小回掉方法
 */
- (void)mapViewDidZoomingWithView:(LQMapView *)view zoomScale:(CGFloat)scale
{
    [self updateLocation];
    [self updateAnnotationBtn];
    [self updatePopView];
}

- (void)mapViewDidEndZoomingWithView:(LQMapView *)view zoomScale:(CGFloat)scale
{
    [self drawLineWithImageView:self.mapView.mapImageView];
}

- (void)mapViewDidTapMapImageViewWithView:(LQMapView *)view
{
    [self.popView removeFromSuperview];
    self.popView = nil;
    self.avAudio = nil;
}

#pragma mark - LQPopViewDelegate
/**
 *  播放语音
 */
- (void)popViewDidClickSoundBtnWithView:(LQPopView *)popView soundButton:(LQSoundButton *)soundButton
{
    NSDictionary *dic = annotationBtnLatLongJson;
    LQCoordinate *coordinates = [LQCoordinate objectWithKeyValues:dic];
    
    if (self.avAudio.isPlaying)
    {
        [self.avAudio stop];
    }else
    {
        NSString *soundName = [coordinates.latitudeAndLongitudeArray[self.annotationBtnNum] soundName];
        [self playSongWithSoundName:soundName];
    }
}

/**
 *  跳转到景点详情
 */
- (void)popViewDidTouchDetailsBtnWithView:(LQPopView *)popView
{
    NSLog(@"点击了详情按钮");
    
    NSDictionary *dic = annotationBtnLatLongJson;
    LQCoordinate *coordinates = [LQCoordinate objectWithKeyValues:dic];
    LatitudeAndLongitude *latLong = coordinates.latitudeAndLongitudeArray[self.annotationBtnNum];
            
    LQViewControllerOne *viewOne = [[LQViewControllerOne alloc] init];
    viewOne.title = [NSString stringWithFormat:@"%f,%f",latLong.latitude,latLong.longitude];
    UINavigationController *navOne = [[UINavigationController alloc] initWithRootViewController:viewOne];
    [self presentViewController:navOne animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
