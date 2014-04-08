//
//  AddToDoItemViewController.m
//  IOS_ToDo
//
//  Created by Joey on 20-03-14.
//  Copyright (c) 2014 Frank & Joey. All rights reserved.
//

#import "AddToDoItemViewController.h"

@interface AddToDoItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation AddToDoItemViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton) return;
    
    if (self.textField.text.length > 0) {
        
        self.toDoItem = [[ToDoItem alloc] init];
        self.toDoItem.task = self.textField.text;
        self.toDoItem.beschrijving =self.textField2.text;
        self.toDoItem.completed = NO;
    }
}

//http://blog.strikeiron.com/bid/63338/Integrate-a-REST-API-into-an-iPhone-App-in-less-than-15-minutes
//opbouwen posturl
//NSString *restCallString = [NSString stringWithFormat:@"http://frankwammes.nl/tasks/%@" ,
                      //      self.textField.text ];
- (IBAction)postTask {

NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] init];
[mutableRequest setURL:[NSURL URLWithString:[NSString
                                             stringWithFormat:@"http://frankwammes.nl/task/%@",TaskID]]];
[mutableRequest setHTTPMethod:@"Post"];
[mutableRequest setHTTPBody/*hier komt de data*/]

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
