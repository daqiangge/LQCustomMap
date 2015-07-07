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

@interface ViewController ()<BMKLocationServiceDelegate,LQMapViewDelegate>

@property (nonatomic, strong) BMKLocationService* locService;
@property (nonatomic, strong) LQLocationView *locationview;
@property (nonatomic, strong) LQMapView *mapView;
@property (nonatomic, weak)   LQAnnotationButton *annotationBtn;
@property (nonatomic, assign) CGFloat newLongitude;
@property (nonatomic, assign) CGFloat newlatitude;
@property (nonatomic, assign) CGFloat oldMapViewScale;

@end

typedef  enum {
    mapScopeaa = 1
}mapScope;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LQMapView *mapView = [LQMapView mapView];
    [self.view addSubview:mapView];
    self.oldMapViewScale = self.mapView.scrollView.zoomScale;
    self.mapView = mapView;
    self.mapView.delegate = self;

    //添加标注位置
    NSMutableArray *coordinateArray = [self didCalculatePointCoordinateWithPointArray:@[@{@"latitude":@31.642133,@"longitude":@120.372033}]];
    for (NSArray *array in coordinateArray) {
        float x = [array[0] floatValue];
        float y = [array[1] floatValue];
        
        LQAnnotationButton *annotationBtn = [LQAnnotationButton annotationButton];
        annotationBtn.center = CGPointMake(x, y);
        [mapView.scrollView addSubview:annotationBtn];
        self.annotationBtn = annotationBtn;
    }
    
    //我的位置标识符
    LQLocationView *locationview = [LQLocationView locationViewWithFrame:CGRectMake(0, 0, 20, 20)];
    [mapView.scrollView addSubview:locationview];
    self.locationview = locationview;
    
    //定位
    BMKLocationService* locService = [[BMKLocationService alloc]init];
    self.locService = locService;
    self.locService.delegate = self;
    [self.locService startUserLocationService];
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService  setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:10.f];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    double x = userLocation.location.coordinate.longitude;//纬度
    double y = userLocation.location.coordinate.latitude;//经度
    
    self.newLongitude = x;
    self.newlatitude = y;
    
    [self updateLocation];
}

//计算坐标
- (NSArray *)didCalculateCoordinateWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    double xx = ((longitude-120.368523) * (self.mapView.scrollView.contentSize.width))/(120.382698-120.368523);
    double yy = ((31.64577-latitude) * (self.mapView.scrollView.contentSize.height))/(31.64577-31.639129);
    NSArray *array = @[[NSNumber numberWithFloat:xx],[NSNumber numberWithFloat:yy]];
    return array;
}

//更新我的定位坐标
- (void)updateLocation
{
    NSArray *array = [self didCalculateCoordinateWithLatitude:self.newlatitude Longitude:self.newLongitude];
    float x = [array[0] floatValue];
    float y = [array[1] floatValue];
    self.locationview.center = CGPointMake(x, y);
    self.locationview.geoPointCompass.latitudeOfTargetedPoint = self.newlatitude;
    self.locationview.geoPointCompass.longitudeOfTargetedPoint = self.newLongitude;
}

//更新标注点
- (void)updateAnnotationBtnWithScale:(CGFloat)scale
{
    NSArray *array = [self didCalculateCoordinateWithLatitude:31.642133 Longitude:120.372033];
    float x = [array[0] floatValue];
    float y = [array[1] floatValue];
    self.annotationBtn.center = CGPointMake(x, y);
}

//批量计算点坐标
- (NSMutableArray *)didCalculatePointCoordinateWithPointArray:(NSArray *)pointArray
{
    NSMutableArray *coordinateArray = [NSMutableArray array];
    
    for (NSDictionary *dic in pointArray) {
        float latitude = [dic[@"latitude"] floatValue];
        float longitude = [dic[@"longitude"] floatValue];
        
        NSArray *array = [self didCalculateCoordinateWithLatitude:latitude Longitude:longitude];
        [coordinateArray addObject:array];
    }
    
    return coordinateArray;
}

//画路径线
- (void)drawLineWithImageView:(UIImageView *)imageView
{
    NSArray *pointArray = @[@{@"latitude":@31.641064,@"longitude":@120.370777},
                            @{@"latitude":@31.640753,@"longitude":@120.37273},
                            @{@"latitude":@31.641641,@"longitude":@120.372721},
                            @{@"latitude":@31.642052,@"longitude":@120.373404}];
    NSMutableArray *coordinateArray = [self didCalculatePointCoordinateWithPointArray:pointArray];

    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    for (int i = 0; i < coordinateArray.count; i++) {
        float x = [coordinateArray[i][0] floatValue];
        float y = [coordinateArray[i][1] floatValue];
        
        if (i == 0) {
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x, y);  //起点坐标
        }else {
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x, y);   //终点坐标
        }
    }
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark -
//地图放大缩小回掉方法
- (void)mapViewDidZoomingWithView:(LQMapView *)view zoomScale:(CGFloat)scale
{
    [self updateLocation];
    [self updateAnnotationBtnWithScale:scale];
}

- (void)mapViewDidEndZoomingWithView:(LQMapView *)view zoomScale:(CGFloat)scale
{
    [self drawLineWithImageView:self.mapView.mapImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
