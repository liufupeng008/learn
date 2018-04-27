//
//  ViewController.m
//  learn
//
//  Created by 刘阜澎 on 2018/4/26.
//  Copyright © 2018年 LiuFuPeng. All rights reserved.
//

#import "ViewController.h"
#import "Person/Person.h"
#import "Person/TestPerson.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person * p1 = [Person new];
    p1.name = @"test1";
    p1.age = @15;
    p1.nick = @"nick1";
    NSString * path = [NSString stringWithFormat:@"%@/person.plist",NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject:p1 toFile:path];
    
    Person * p2 = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@,%@",p2.name,p2.nick);
    
    NSDictionary * dict = [p2 modelToDict];
    NSLog(@"%@",dict);

    
    TestPerson * testPerson = [TestPerson new];
    testPerson.test = @"啦啦啦";
    
    NSDictionary * dict1 = [testPerson modelToDict];
    NSLog(@"%@",dict1);

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
