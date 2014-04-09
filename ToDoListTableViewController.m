//
//  ToDoListTableViewController.m
//  IOS_ToDo
//
//  Created by Joey on 20-03-14.
//  Copyright (c) 2014 Frank & Joey. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "ToDoItem.h"
#import "AddToDoItemViewController.h"
#import "ToDoListTableViewCell.h"

@interface ToDoListTableViewController ()

@property NSMutableArray *toDoItems;



@end

@implementation ToDoListTableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    AddToDoItemViewController *source = [segue sourceViewController];
    ToDoItem *item = source.toDoItem;
    if (item != nil) {
        [self.toDoItems addObject:item];
        [self.tableView reloadData];
    }
}

//De hele get actie
- (IBAction)fetchTasks;
{
    [self.toDoItems removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:@"http://frankwammes.nl:8080/tasks"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSLog(@"data ontvangen");
             NSError *e = nil;
             NSArray *taskData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &e];
             if(!taskData){
                 NSLog(@"Error met het parsen van JSON: %@", e);
             }else{
                 NSLog(@"Parsen van JSON gelukt");
             for (NSDictionary *task in taskData) {
                 
                 ToDoItem *task1 = [[ToDoItem alloc] init];
                 
                 task1.taskId = [[task objectForKey:@"ID"] intValue];
                 task1.task = [task objectForKey:@"task"];
                 task1.completed =[[task objectForKey:@"status"] boolValue];
                 task1.beschrijving =[task objectForKey:@"description"];
                 
                 [self.toDoItems addObject:task1];
             }
                 [self.tableView reloadData];

             }
            
         }else{
             NSLog(@"alles is kut");
         }
     }];
}
//einde get


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setUserName {
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_name"];
    self.navigationItem.title = [NSString stringWithFormat:@"Welkom %@", userName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.toDoItems = [[NSMutableArray alloc] init];
   // [self loadInitialData];
    [self fetchTasks];
    //set the edit button
    //alles om die o zo lastige edit button te tonen (:
    //in een van de comments van: //http://stackoverflow.com/questions/7921579/iphone-storyboard-editing-a-table-view
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_name"];
    //self.navigationItem.title = [NSString stringWithFormat:@"Welkom %@", userName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.toDoItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToDoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    ToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.task;
    cell.detailTextLabel.text = toDoItem.beschrijving;
    cell.taskId = toDoItem.taskId;
    
    if (toDoItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        ToDoListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSString *urlString = [NSString stringWithFormat:@"http://frankwammes.nl:8080/tasks/%ld", (long)cell.taskId ];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"DELETE"];

        [NSURLConnection sendAsynchronousRequest: request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSLog(@"Deleted task");
         }];
        
        
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    
    NSString *urlString = [NSString stringWithFormat:@"http://frankwammes.nl:8080/tasks/%ld", (long)tappedItem.taskId ];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
    
    NSString* taskName = [self percentEscapeString:tappedItem.task];
    NSString* taskDesc = [self percentEscapeString:tappedItem.beschrijving];
    
    NSString* postString = [NSString stringWithFormat:@"taskName=%@&taskDesc=%@&taskStatus=%s", taskName, taskDesc, tappedItem.completed ? "true" : "false"];
    
    NSData* postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"Updated task");
     }];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //TODO update item
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


@end
