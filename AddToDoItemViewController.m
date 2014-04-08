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
        
        [self postTask];
    }
}

//http://blog.strikeiron.com/bid/63338/Integrate-a-REST-API-into-an-iPhone-App-in-less-than-15-minutes
//opbouwen posturl
//NSString *restCallString = [NSString stringWithFormat:@"http://frankwammes.nl/tasks/%@" ,
                      //      self.textField.text ];
- (void)postTask
{

    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] init];
    [mutableRequest setURL:[NSURL URLWithString:@"http://frankwammes.nl:8080/tasks"]];
    
    NSString* taskName = [self percentEscapeString:self.toDoItem.task];
    NSString* taskDesc = [self percentEscapeString:self.toDoItem.beschrijving];
    
    NSString* postString = [NSString stringWithFormat:@"taskName=%@&taskDesc=%@&taskStatus=false", taskName, taskDesc];
    
    NSData* postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];

    [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:postBody];
    [mutableRequest setHTTPMethod:@"POST"];
    
    
    [NSURLConnection sendAsynchronousRequest:mutableRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSLog(@"POST data ontvangen");
             NSError *e = nil;
             NSArray *taskData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &e];
             if(!taskData){
                 NSLog(@"Error met het parsen van POST JSON: %@", e);
             }else{
                 NSLog(@"Parsen van POST JSON gelukt");
                 for (NSDictionary *task in taskData)
                 {
                     self.toDoItem.taskId = [[task objectForKey:@"ID"] intValue];
                     NSLog(@"Got ID for posted task");
                 }
                 
             }
             
         }else{
             NSLog(@"alles is kut POST");
         }
     }];

    NSLog(@"Posted task");

}



- (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
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
