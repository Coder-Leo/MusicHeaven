//
//  DataModal.h
//  MusicHeaven
//
//  Created by 梁 黄 on 12-12-20.
//  Copyright (c) 2012年 ABC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModal : NSObject

@property (nonatomic, strong) NSArray *allPacksArray;
@property (nonatomic, strong) NSArray *allColumnTrumbsArray;

+ (DataModal *)defaultModal;

@end
