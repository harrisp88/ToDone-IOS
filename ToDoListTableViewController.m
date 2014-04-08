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

@interface ToDoListTableViewController ()

@property NSMutableArray *toDoItems;


@end

@implementation ToDoListTableViewController
/*- (void)loadInitialData {
    ToDoItem *task1 = [[ToDoItem alloc] init];
    task1.task = @"Doe de afwas";
    [self.toDoItems addObject:task1];
    ToDoItem *task2 = [[ToDoItem alloc] init];
    task2.task = @"Schoenen poetsen";
    [self.toDoItems addObject:task2];
    ToDoItem *task3 = [[ToDoItem alloc] init];
    task3.task = @"App maken";
    [self.toDoItems addObject:task3];
}testdata*/

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    ToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.task;
    cell.detailTextLabel.text = toDoItem.beschrijving;
    
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //TODO update item
}

@end
