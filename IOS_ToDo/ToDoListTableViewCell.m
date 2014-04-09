//
//  ToDoListTableViewCell.m
//  IOS_ToDo
//
//  Created by User on 4/9/14.
//  Copyright (c) 2014 Frank & Joey. All rights reserved.
//

#import "ToDoListTableViewCell.h"

@implementation ToDoListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
