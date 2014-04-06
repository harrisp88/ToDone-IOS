//
//  ToDoItem.h
//  IOS_ToDo
//
//  Created by Joey on 06-04-14.
//  Copyright (c) 2014 Frank & Joey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;


@end
