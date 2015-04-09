//
//  AppDictionary.h
//  gzprma
//
//  Created by apple on 14-1-16.
//  Copyright (c) 2014年 tension. All rights reserved.
//


@interface AppDictionary : NSObject
+(NSMutableDictionary *) getMapString;
+(NSMutableDictionary *) getZxjjUrlMap;
+(NSMutableDictionary *) getSetupUrlMap;
+(NSMutableDictionary *) isScrollListPage;
+(NSMutableDictionary *) isNoScrollListPage;
+(NSMutableDictionary *) getAlertMsg;

+(float) minSmallStyleListHeight;

+(float) minBigStyleListHeight;

+(float) maxSmallStyleListHeight;

+(float) maxBigStyleListHeight;

+(float) iphoneFourDifferenceFiveHeight;

+(NSString *) bigStyleName;

+(NSString *) noScrollListPageKycd;
@end
