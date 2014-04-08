//
//  ToDoItem.h
//  IOS_ToDo
//
//  Created by Joey on 06-04-14.
//  Copyright (c) 2014 Frank & Joey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *task;
@property BOOL completed;
@property NSString *beschrijving;
@property (readonly) NSDate *creationDate;


@end
