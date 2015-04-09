//
//  AppDictionary.m
//  gzprma
//
//  Created by apple on 14-1-16.
//  Copyright (c) 2014年 tension. All rights reserved.
//

#import "AppDictionary.h"

@implementation AppDictionary

+(NSMutableDictionary *) getMapString{
    //创建词典对象，初始化长度为18
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:18];
    
    //向词典中动态添加数据
    [dic setObject:@"发起流程" forKey:@"luanchflow"];//发起流程
    [dic setObject:@"待办" forKey:@"joblist"];//待办
    [dic setObject:@"待阅" forKey:@"readlist"];//待阅
    [dic setObject:@"待阅信息" forKey:@"readform"];
    [dic setObject:@"行为轨迹" forKey:@"behaviortrace"];
    [dic setObject:@"获取经纬度" forKey:@"behaviorTraceQDSearch"];
    [dic setObject:@"渠道信息" forKey:@"behaviorTraceQDList"];
    [dic setObject:@"行为轨迹查询" forKey:@"behaviorTraceSearch"];
    [dic setObject:@"渠道查询" forKey:@"behaviorTraceQDSearchResult"];
    [dic setObject:@"指定被访人员" forKey:@"behaviorTraceQDPersonList"];
    [dic setObject:@"查看行为轨迹" forKey:@"behaviorTraceMap"];
    [dic setObject:@"公告" forKey:@"announcement"];
    [dic setObject:@"走访日志查询" forKey:@"searchvistinglog"];
    [dic setObject:@"走访日志信息" forKey:@"logResult"];
    [dic setObject:@"渠道需求反馈" forKey:@"feedback"];
    [dic setObject:@"渠道经理需求反馈" forKey:@"managerfeedback"];
    [dic setObject:@"更新渠道需求反馈" forKey:@"updatefeedback"];
    [dic setObject:@"新增渠道需求反馈" forKey:@"addfeedback"];
    [dic setObject:@"更新渠道经理需求反馈" forKey:@"updatemanagerfeedback"];
    [dic setObject:@"新增渠道经理需求反馈" forKey:@"addmanagerfeedback"];
    [dic setObject:@"人员查询" forKey:@"searchperson"];
    [dic setObject:@"渠道需求反馈查询" forKey:@"searchfeedback"];
    [dic setObject:@"渠道经理需求反馈查询" forKey:@"searchmanagerfeedback"];
    [dic setObject:@"渠道需求反馈待办查询" forKey:@"searchfeedbackJob"];
    [dic setObject:@"渠道经理需求反馈待办查询" forKey:@"searchmanagerfeedbackJob"];
    [dic setObject:@"渠道预约" forKey:@"appointment"];
    [dic setObject:@"渠道经理预约" forKey:@"managerappointment"];
    [dic setObject:@"更新渠道预约" forKey:@"updateappointment"];
    [dic setObject:@"更新渠道经理预约" forKey:@"updatemanagerappointment"];
    [dic setObject:@"渠道预约查询" forKey:@"searchappointment"];
    [dic setObject:@"渠道经理预约查询" forKey:@"searchmanagerappointment"];
    [dic setObject:@"渠道预约待办查询" forKey:@"searchappointmentJob"];
    [dic setObject:@"渠道经理预约待办查询" forKey:@"searchmanagerappointmentJob"];
    [dic setObject:@"新增渠道预约" forKey:@"addappointment"];
    [dic setObject:@"新增渠道经理预约" forKey:@"addmanagerappointment"];
    
    [dic setObject:@"渠道预约查询" forKey:@"appointmentsearch"];
    [dic setObject:@"渠道经理预约查询" forKey:@"managerappointmentsearch"];
    [dic setObject:@"渠道预约待办查询" forKey:@"appointmentJobsearch"];
    [dic setObject:@"渠道经理预约待办查询" forKey:@"managerappointmentJobsearch"];

    [dic setObject:@"消息设置" forKey:@"pushMsg"];
    [dic setObject:@"关于我们" forKey:@"about"];
    [dic setObject:@"重置密码" forKey:@"resetpwd"];
    
    return dic;
}

+(NSMutableDictionary *) getZxjjUrlMap{
    //创建词典对象，初始化长度为7
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:8];
    
    //向词典中动态添加数据
    [dic setObject:@"zxjj/zxjs_content.html" forKey:@"中心简介"];//中心简介
    [dic setObject:@"zxjj/jgsz.html" forKey:@"机构设置"];//机构设置
    [dic setObject:@"zxjj/cdss.html" forKey:@"场地设施"];//场地设施
    [dic setObject:@"zxjj/hhlc.html?title=scrollfzlc" forKey:@"发展历程"];//发展历程
    [dic setObject:@"zxjj/zdgc/zdgc1.html?title=scrollzdgc" forKey:@"重点工程"];//重点工程
    [dic setObject:@"zxjj/lxwm.html" forKey:@"联系我们"];//联系我们人
    [dic setObject:@"zxjj/zxwz.html" forKey:@"中心位置"];//中心位置
    
    [dic setObject:@"showDetail.html" forKey:@"zbgg"];//招标公告
    return dic;
}

+(NSMutableDictionary *) getSetupUrlMap{
    //创建词典对象，初始化长度为2
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    //向词典中动态添加数据
    [dic setObject:@"about.html?title=gy" forKey:@"关于"];//关于
    [dic setObject:@"login.html?title=zx" forKey:@"注销"];//注销
    return dic;
}

+(NSMutableDictionary *) isScrollListPage{
    //创建词典对象，初始化长度为2
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:5];
    
    //向词典中动态添加数据
    [dic setObject:@"招标进展情况" forKey:@"zbjzqk"];//招标进展情况
    [dic setObject:@"中标候选人" forKey:@"zbhxrgs"];//中标候选人
    [dic setObject:@"项目业绩公示" forKey:@"xmyjgs"];//项目业绩
    /* 内部用户*/
    [dic setObject:@"内部通知" forKey:@"nbtz"];//内部通知
    [dic setObject:@"待办工作" forKey:@"gzdb"];//待办工作
    return dic;
}

+(NSMutableDictionary *) isNoScrollListPage{
    //创建词典对象，初始化长度为2
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:5];
    
    //向词典中动态添加数据
    [dic setObject:@"招标进展情况" forKey:@"zbjzqk"];//招标进展情况
    [dic setObject:@"中标候选人" forKey:@"zbhxrgs"];//中标候选人
    [dic setObject:@"项目业绩公示" forKey:@"xmyjgs"];//项目业绩
    /* 内部用户*/
    [dic setObject:@"内部通知" forKey:@"nbtz"];//内部通知
    [dic setObject:@"待办工作" forKey:@"gzdb"];//待办工作
    [dic setObject:@"空余场地" forKey:@"kycd"];//待办工作
    [dic setObject:@"预约号查询" forKey:@"yyhcx"];//预约号查询
    [dic setObject:@"现场号查询" forKey:@"xcqhcx"];//现场号查询
    [dic setObject:@"取消预约" forKey:@"qxyy"];//现场号查询
    return dic;
}

+(NSMutableDictionary *) getAlertMsg{
    //创建词典对象，初始化长度为2
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
    [dic setObject:@"密码过于简单，请先修改密码再登陆" forKey:@"loginSimple"];//登陆错误
    [dic setObject:@"用户名或密码不正确！" forKey:@"loginError"];//登陆错误
    [dic setObject:@"请输入用户名或密码！" forKey:@"loginNull"];//登陆错误
    [dic setObject:@"暂无数据" forKey:@"nullList"];//招标进展情况
    [dic setObject:@"当前时间已预约满！" forKey:@"wsyysjym"];//网上预约已满
    [dic setObject:@"手机号码输入不正确！" forKey:@"sjhmsrbzq"];//手机号码输入错误
    [dic setObject:@"手机号码为必填项" forKey:@"sjhmwbtx"];//手机号码输入错误
    [dic setObject:@"身份证号为必填项！" forKey:@"sfzhmwbtx"];//手机号码输入错误
    [dic setObject:@"IC卡号为必填项！" forKey:@"ickhwbtx"];//手机号码输入错误
    [dic setObject:@"抱歉，没有查询到数据！" forKey:@"bqmycxdsj"];//抱歉，没有查询到数据！
    [dic setObject:@"请输入预约号或身份证号！" forKey:@"qsryyhhsfzh"];//抱歉，没有查询到数据！
    [dic setObject:@"请输入查询条件！" forKey:@"qsrcxtj"];//抱歉，没有查询到数据！
    [dic setObject:@"网络异常！" forKey:@"wlyc"];//网络异常！
    [dic setObject:@"网络恢复正常！" forKey:@"wlhfzc"];//网络恢复正常！
    return dic;
}

+(float) minSmallStyleListHeight{
    return 135.0f;
}

+(float) minBigStyleListHeight{
    return 285.0f;
}

+(float) maxSmallStyleListHeight{
    return 570.0f;
}

+(float) maxBigStyleListHeight{
    return 720.0f;
}

+(float) iphoneFourDifferenceFiveHeight{
    return 88.0f;
}

+(NSString *) bigStyleName{
    NSString *bigStyle = @"";
    bigStyle = [bigStyle stringByAppendingFormat:@"%@,%@", @"xmyjgs", @"gzdb"];
    return bigStyle;
}

+(NSString *) noScrollListPageKycd{
    return @"kycd";
}

@end
