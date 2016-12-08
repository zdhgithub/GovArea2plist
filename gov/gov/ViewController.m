//
//  ViewController.m
//  gov
//
//  Created by 黑漂研发 on 2016/12/8.
//  Copyright © 2016年 dh. All rights reserved.
//

#import "ViewController.h"


/**
   思路
   先转换一个省的 然后for循环
   开头2位 决定省  中间2位决定市  后2位决定区域
 */


@interface ViewController ()
//获取所有省的开头2位
@property (nonatomic,strong) NSArray *preArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gov.txt" ofType:nil];
    
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\n"]];
    [arr removeObject:@""];
    
    
    //获取所有省的开头2位
//    NSMutableDictionary *preDic = [NSMutableDictionary dictionary];
//    for (NSString *str in arr) {
//        NSString *pre2 = [str substringToIndex:2];
//        [preDic setObject:pre2 forKey:pre2];
//    }
//    NSMutableArray *preArr = [NSMutableArray arrayWithArray:[preDic allValues]];
//    [preArr sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
//        return obj1.integerValue > obj2.integerValue;
//    }];
//    NSLog(@"%@,%ld",preArr,preArr.count);
    
    
    NSMutableArray *lastArr = [NSMutableArray array];
    for (NSString *str in self.preArr) {
        NSDictionary *dic = [self optionWithArr:arr str:str];
        [lastArr addObject:dic];
    }

    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"gov.plist"];
    
    [lastArr writeToFile:filePath atomically:YES];

    

    NSLog(@"%@",NSHomeDirectory());
    
}
-(NSDictionary *)optionWithArr:(NSMutableArray *)arr str:(NSString *)strxxx{
    
    //截取11开头  一个省
    NSMutableArray *proArr = [NSMutableArray array];
    for (NSString *str in arr) {
        if ([str hasPrefix:strxxx]) {
            [proArr addObject:str];
        }
    }
    
    //省名
    NSString *pro = proArr[0];
    //移除省
    [proArr removeObject:pro];
    
    //市数组
    NSMutableArray *cityArr = [NSMutableArray array];
    for (NSString *str in proArr) {
        if ([[str substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"00"]) {
            [cityArr addObject:str];
        }
    }
    
    //移除市
    [proArr removeObjectsInArray:cityArr];
    
    //区数组
    NSMutableArray *areaArr = [NSMutableArray array];
    for (NSString *city in cityArr) {
        //求city中间2位
        NSString *cityMid = [city substringWithRange:NSMakeRange(2, 2)];
        NSMutableArray *areaSmallArr = [NSMutableArray array];
        
        for (NSString *str in proArr) {
            
            //求所有中间2位
            NSString *allMid = [str substringWithRange:NSMakeRange(2, 2)];
            
            if ([allMid isEqualToString:cityMid]) {
                NSString *format = [self formatStr:str];
                [areaSmallArr addObject:format];
            }
        }
        
        [areaArr addObject:areaSmallArr];
    }
    
    
    
    //生成plist文件
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *filePath = [doc stringByAppendingPathComponent:@"gov.plist"];
    
//    NSMutableArray *resultArr = [NSMutableArray array];
    NSMutableArray *resultCityArr = [NSMutableArray array];
    
    for (NSInteger i=0; i<cityArr.count; i++) {
        NSMutableDictionary *cityDic = [NSMutableDictionary dictionary];
        
        
        cityArr[i] = [self formatStr:cityArr[i]];
        
        [cityDic setObject:areaArr[i] forKey:@"areas"];
        [cityDic setObject:cityArr[i] forKey:@"city"];
        
        [resultCityArr addObject:cityDic];
    }
    
//    int i;
//    for (NSString *city in cityArr) {
//        
//        NSMutableDictionary *cityDic = [NSMutableDictionary dictionary];
//        [cityDic setObject:areaArr[i] forKey:@"areas"];
//        [cityDic setObject:city forKey:@"city"];
//        
//        [resultCityArr addObject:cityDic];
//        
//        i += 1;
//    }
    
    NSMutableDictionary *proDic = [NSMutableDictionary dictionary];
    [proDic setObject:resultCityArr forKey:@"cities"];
    
    
    pro = [self formatStr:pro];
    [proDic setObject:pro forKey:@"state"];
    
//    [resultArr addObject:proDic];
    
    return proDic;
    
    //写入文件
//    [resultArr writeToFile:filePath atomically:YES];
}
/**
 *  转换格式
 */
-(NSString *)formatStr:(NSString *)str {
    
    NSMutableArray *aaa = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@" "]];
    [aaa removeObject:@""];
    NSString *str0 = [aaa[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *str1 = [aaa[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [NSString stringWithFormat:@"%@(%@)",str1,str0];
}
-(NSArray *)preArr {
    if (_preArr == nil) {
        
        NSString *s = @"11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82";
        _preArr = [s componentsSeparatedByString:@","];

    }
    return _preArr;
}
@end
