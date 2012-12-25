//
//  DataModal.m
//  MusicHeaven
//
//  Created by 梁 黄 on 12-12-20.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import "DataModal.h"

static DataModal *defaultModal;

@implementation DataModal

@synthesize allPacksArray           = _allPacksArray;
@synthesize allColumnTrumbsArray    = _allColumnTrumbsArray;

+ (DataModal *)defaultModal
{
    if (!defaultModal) {
        defaultModal = [[super allocWithZone:NULL]init];
    }
    
    return defaultModal;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultModal];
}

- (id)init
{
    if (defaultModal) {
        return defaultModal;
    }
    
    if (self = [super init]) {
        //TO DO
        NSFileManager *fileManager = [NSFileManager defaultManager];    //创建应用的文件管理器
        
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];      //应用包路径
        NSString *htmlPath = [bundlePath stringByAppendingString:@"/html"]; //html文件夹的路径
        
//        NSLog(@"== %@",htmlPath);
        NSError *err;
        NSArray *subFolderInHtmlFolderArray = [fileManager contentsOfDirectoryAtPath:htmlPath error:&err];    //使用文件管理器的实例方法得到html文件夹的路径下的内容（这里是文件夹名称）
//       
        if (subFolderInHtmlFolderArray != nil) 
        {
//            NSLog(@"-=-= %@",subFolderInHtmlFolderArray);
            
            NSUInteger numberOfSubFolders = [subFolderInHtmlFolderArray count];
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < numberOfSubFolders; i++) 
            {
                NSString *path = [htmlPath stringByAppendingString:@"/"];
                NSString *fullFolderPath = [path stringByAppendingString:[subFolderInHtmlFolderArray objectAtIndex:i]];  //获得html文件夹下的子文件夹下的全路径
//                NSLog(@"== %@",fullFolderPath); 
                
                NSArray *pathNameArray = [fullFolderPath componentsSeparatedByString:@"/"];
                NSString *filePath = [NSString stringWithFormat:@"html/%@",[pathNameArray lastObject]];
                
                NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@"html" inDirectory:filePath]; //将每个子文件夹（栏目）下的html文件路径放入数组
//                NSLog(@"$$ %@",array);
                path = nil;
                fullFolderPath = nil;
                
                [tempArray addObject:array];    //将存储了每个子文件夹（栏目）下的文件路径的数组存入一个根数组
            }
            self.allPacksArray = [NSArray arrayWithArray:tempArray];
//            NSLog(@"$$ %@",self.allPacksArray);
        }
        else 
        {
            NSLog(@"empty array!");
        }
        
        self.allColumnTrumbsArray = [[NSBundle mainBundle]pathsForResourcesOfType:@"png" inDirectory:@"images/ColumnTrumbs"];
        
//        for (NSString *imageName in self.allColumnTrumbsArray)
//        {
//            NSArray *namePathArray = [imageName componentsSeparatedByString:@"/"];
//            NSLog(@"--==--== %@",[namePathArray lastObject]);
//        }
    }
    
    return self;
}


@end
