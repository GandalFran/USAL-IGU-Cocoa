//
//  FunctionTableUIController.m
//  MacLab
//
//  Created by GandalFran on 13/11/2018.
//  Copyright © 2018 GandalFran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Model.h"
#import "Function.h"

#import "AddFunctionUIController.h"
#import "FunctionTableUIController.h"
#import "PlotRepresentationUIController.h"


@implementation FunctionTableUIController

/*----------------------Initializers--------------------*/

-(id) init
{
    if(nil == [super initWithWindowNibName:@"FunctionTableUI"])
        return nil;
    return self;
}

-(instancetype) initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if(nil == self)
        return nil;

    //Register handlers for the notifications
    NSNotificationCenter * notificationCenter = nil;

    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleSendModel:)
                               name:sendModelToFunctionTableUI
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(handleReloadData:)
                               name:functionAdded
                             object:nil];
    return self;
}

/**
 * @brief send a notification to the main controller to stop the application if the user closes the window
 */
-(BOOL) windowShouldClose:(NSWindow *)sender
{
    [NSApp terminate:self];
    return YES;
}

-(void) awakeFromNib{
    RepresentationParameters parameters = [model representationParameters];
    
    [xminTextField setFloatValue:parameters.xmin];
    [xmaxTextField setFloatValue:parameters.xmax];
    [yminTextField setFloatValue:parameters.ymin];
    [ymaxTextField setFloatValue:parameters.ymax];
    
    [nameTextField setStringValue:@""];
    [aValueTextField setStringValue:@""];
    [bValueTextField setStringValue:@""];
    [cValueTextField setStringValue:@""];
    [typeCombobox setStringValue:@""];
    [nameTextField setEnabled: NO];
    [aValueTextField setEnabled: NO];
    [bValueTextField setEnabled: NO];
    [cValueTextField setEnabled: NO];
    [typeCombobox setEnabled: NO];
    
    [cValueLabel setHidden: YES];
    [cValueTextField setHidden: YES];
    [editButton setEnabled: NO];
}

- (void) windowDidLoad {
    [super windowDidLoad];
}

/*----------------Notifications--------------*/

NSString * sendModelToAddFunctionUI = @"sendModelToAddFunctionUI";

NSString * sendNewRepresentation = @"sendNewRepresentation";

extern NSString * sendModelToFunctionTableUI;
extern NSString * functionAdded;

/**
 *  @brief handler for sendModelToFunctionTableUI notification:
 *              recives the model
 */
-(void) handleSendModel:(NSNotification *)aNotification{
    NSDictionary * aDictionary = nil;
    
    aDictionary = [aNotification userInfo];
    if(nil != aDictionary)
        model = [aDictionary objectForKey:@"model"];
}

/**
 *  @brief handler for functionAdded notification:
 *              reloads the view
 */
-(void) handleReloadData:(NSNotification *)aNotification{
    [tableView reloadData];
}

/*--------------Delegation-------------*/

/**
 *  @brief enables or disables the add button if the
 *         formulary is completed or not
 */
- (void) controlTextDidChange:(NSNotification *)obj{
    BOOL formularyCompleted = [self isEditFormCompleted];
    [editButton setEnabled: formularyCompleted];
    
    formularyCompleted = [self isSettingsFormCompleted];
    [saveSettingsButton setEnabled: formularyCompleted];
}


/**
 *  @brief hides or shows the cValue label and textbox
 *         according to the type comboBox.
 *         and enables or disables the add button if the
 *         formulary is completed or not
 */
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{
    BOOL selectedItem = (4 == [typeCombobox indexOfSelectedItem]);
    BOOL formularyCompleted = [self isEditFormCompleted];
    
    [cValueLabel setHidden: !selectedItem];
    [cValueTextField setHidden: !selectedItem];
    
    [editButton setEnabled: formularyCompleted];
}

/*
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    Function * f = nil;
    NSString * columnIdentifier = nil;
    
    columnIdentifier = [aTableColumn identifier];
    f = [[model allFunctions] objectAtIndex:rowIndex];
    
    if([columnIdentifier isEqualToString:@"NameColumn"]){
        [f setName:anObject];
    }else if([columnIdentifier isEqualToString:@"typeColumn"]){
        if([anObject isEqualToString:@"a*cos(b*x)"]){
            [f setType:COSINE];
        }else if([anObject isEqualToString:@"a*sin(b*x)"]){
            [f setType:SINE];
        }else if([anObject isEqualToString:@"a*x^b)"]){
            [f setType:EXPONENTIAL];
        }else if([anObject isEqualToString:@"a + b*x"]){
            [f setType:LINE];
        }else if([anObject isEqualToString:@"a*x^2 + b*x + c"]){
            [f setType:PARABOLA];
        }else if([anObject isEqualToString:@"a/(b*x)"]){
            [f setType:HIPERBOLA];
        }
    }else if([columnIdentifier isEqualToString:@"aValueColumn"]){
        [f setAValue:[anObject doubleValue]];
    }else if([columnIdentifier isEqualToString:@"bValueColumn"]){
        [f setBValue:[anObject doubleValue]];
    }else if([columnIdentifier isEqualToString:@"cValueColumn"] && ([f type] == PARABOLA)){
        [f setCValue:[anObject doubleValue]];
    }else if([columnIdentifier isEqualToString:@"ColorColumn"]){
        //TODO
    }else if([columnIdentifier isEqualToString:@"vissibleColumn"]){
        //TODO
    }
    
    [model updateFunction:f];
    [tableView reloadData];
}*/

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Function * f = nil;
    NSString * columnIdentifier = nil;
    
    columnIdentifier = [tableColumn identifier];
    f = [[model allFunctions] objectAtIndex:row];
    
    if([columnIdentifier isEqualToString:@"NameColumn"]){
        return [f name];
    }else if([columnIdentifier isEqualToString:@"ExpressionColumn"]){
        return [f expressionStringValue];
    }else{
        return nil;
    }
}
/*
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    Function * f = nil;
    NSString * columnIdentifier = nil;
    
    columnIdentifier = [aTableColumn identifier];
    f = [[model allFunctions] objectAtIndex:rowIndex];
    
    if([columnIdentifier isEqualToString:@"NameColumn"]){
        [f setName:anObject];
    }else if([columnIdentifier isEqualToString:@"typeColumn"]){
        if([anObject isEqualToString:@"a*cos(b*x)"]){
            [f setType:COSINE];
        }else if([anObject isEqualToString:@"a*sin(b*x)"]){
            [f setType:SINE];
        }else if([anObject isEqualToString:@"a*x^b)"]){
            [f setType:EXPONENTIAL];
        }else if([anObject isEqualToString:@"a + b*x"]){
            [f setType:LINE];
        }else if([anObject isEqualToString:@"a*x^2 + b*x + c"]){
            [f setType:PARABOLA];
        }else if([anObject isEqualToString:@"a/(b*x)"]){
            [f setType:HIPERBOLA];
        }
    }else if([columnIdentifier isEqualToString:@"aValueColumn"]){
        [f setAValue:[anObject doubleValue]];
    }else if([columnIdentifier isEqualToString:@"bValueColumn"]){
        [f setBValue:[anObject doubleValue]];
    }else if([columnIdentifier isEqualToString:@"cValueColumn"] && ([f type] == PARABOLA)){
        [f setCValue:[anObject doubleValue]];
    }else if([columnIdentifier isEqualToString:@"ColorColumn"]){
        //TODO
    }else if([columnIdentifier isEqualToString:@"vissibleColumn"]){
        //TODO
    }
    
    [model updateFunction:f];
    [tableView reloadData];
}*/

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger row;
    Function * function = nil;
    
    row = [tableView selectedRow];
    
    if(row == -1){
        [nameTextField setStringValue:@""];
        [aValueTextField setStringValue:@""];
        [bValueTextField setStringValue:@""];
        [cValueTextField setStringValue:@""];
        [typeCombobox setStringValue:@""];
        [nameTextField setEnabled: NO];
        [aValueTextField setEnabled: NO];
        [bValueTextField setEnabled: NO];
        [cValueTextField setEnabled: NO];
        [typeCombobox setEnabled: NO];
        
        [cValueLabel setHidden: YES];
        [cValueTextField setHidden: YES];
        [editButton setEnabled: NO];
    }else{
        function = [[model allFunctions] objectAtIndex:row];
        
        [nameTextField setStringValue: [function name]];
        [aValueTextField setFloatValue:[function aValue]];
        [bValueTextField setFloatValue:[function bValue]];
        [cValueTextField setFloatValue:[function cValue]];
        [typeCombobox setStringValue:@"POR IMPLEMENTAR"];
        [nameTextField setEnabled: YES];
        [aValueTextField setEnabled: YES];
        [bValueTextField setEnabled: YES];
        [cValueTextField setEnabled: YES];
        [typeCombobox setEnabled: YES];
        
        if([function type] == PARABOLA){
            [cValueLabel setHidden: NO];
            [cValueTextField setHidden: NO];
        }else{
            [cValueLabel setHidden: YES];
            [cValueTextField setHidden: YES];
        }
        
        [editButton setEnabled: YES];
    }
    
}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [model count];
}

/*--------------Bussines logic-------------*/

/*
 * @brief take the representation parameters and set it on the model
 */
-(IBAction)setNewRepresentationParameters:(id)sender{
    RepresentationParameters new;
    
    new.xmin = [xminTextField doubleValue];
    new.xmax = [xmaxTextField doubleValue];
    new.ymin = [yminTextField doubleValue];
    new.ymax = [ymaxTextField doubleValue];
    
    [model setRepresentationParameters:new];
}

/**
 *  @brief displays the addFunction formulary when the addFunction button is pushed
 */
-(IBAction)addFunction:(id)sender{
    NSDictionary * notificationInfo = nil;
    NSNotificationCenter * notificationCenter = nil;
    
    if(nil == addFunctionUIController){
        addFunctionUIController = [[AddFunctionUIController alloc] init];
        notificationCenter = [NSNotificationCenter defaultCenter];
        notificationInfo = [NSDictionary dictionaryWithObject:model forKey:@"model"];
        [notificationCenter postNotificationName:sendModelToAddFunctionUI object:self userInfo:notificationInfo];
    }
    
    [addFunctionUIController showWindow:self];
}


-(IBAction)removeFunction:(id)sender{
    NSInteger row;
    Function * f = nil;
    
    row = [tableView selectedRow];
    if(-1 == row) return;
    
    f = [[model allFunctions] objectAtIndex:row];
    [model removeFunctionWithID:[f ID]];
    [tableView reloadData];
    //When a function is removed is neccesary to disable the edit button
    [self tableViewSelectionDidChange:nil];
}

/**
 *  @brief removes all elements from model
 */
-(IBAction)removeAllModelElements:(id)sender{
    [model removeAllFunctions];
    [tableView reloadData];
    //When a function is removed is neccesary to disable the edit button
    [self tableViewSelectionDidChange:nil];
}

/**
 *  @brief take the selected items and send them to the main window
 *          to be represented
 */
-(IBAction)representSelectedFunctions:(id)sender{
    NSArray * aFunctionArray = nil;
    NSDictionary * aDictionary = nil;
    NSNotificationCenter * aNotificationCenter = nil;
    
    //TODO retrieve selected functions in table
    
    aNotificationCenter = [NSNotificationCenter defaultCenter];
    
    aDictionary = [NSDictionary dictionaryWithObject: aFunctionArray
                                              forKey:@"representationArray"];
    [aNotificationCenter postNotificationName:sendNewRepresentation
                                       object:self
                                     userInfo:aDictionary];
}

- (BOOL) isSettingsFormCompleted{
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    
    BOOL areAllFilled = ([[xminTextField stringValue] length] != 0
                         && [[xmaxTextField stringValue] length] != 0
                         && [[yminTextField stringValue] length] != 0
                         && [[ymaxTextField stringValue] length] != 0);
    
    //TODO improve the validation of numbers
    BOOL areNumberTextFieldsCorrectlyFilled = (
                            [numberFormatter numberFromString:[xminTextField stringValue]] != nil
                            && [numberFormatter numberFromString:[xmaxTextField stringValue]] != nil
                            && [numberFormatter numberFromString:[yminTextField stringValue]] != nil
                            && [numberFormatter numberFromString:[ymaxTextField stringValue]] != nil);
    
    return (areAllFilled && areNumberTextFieldsCorrectlyFilled);
}


-(IBAction)editFunction:(id)sender{
    NSInteger row;
    FunctionType aType;
    Function * function = nil;
    
    row = [tableView selectedRow];
    function = [[model allFunctions] objectAtIndex:row];
    
    switch((int)[typeCombobox indexOfSelectedItem]){
        case 0: aType = COSINE; break;
        case 1: aType = SINE; break;
        case 2: aType = EXPONENTIAL; break;
        case 3: aType = LINE; break;
        case 4: aType = PARABOLA; break;
        case 5: aType = HIPERBOLA; break;
        default: aType = NONE_TYPE;
    }
    
    [function setName: [nameTextField stringValue]];
    [function setAValue:[aValueTextField doubleValue]];
    [function setBValue:[bValueTextField doubleValue]];
    [function setCValue:[cValueTextField doubleValue]];
    [function setColor:[colorColorWell color]];
    [function setType: aType];
    
    [tableView reloadData];
}

- (BOOL) isEditFormCompleted{
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    
    BOOL areAllFilled = ([[nameTextField stringValue] length] != 0
                         && [[aValueTextField stringValue] length] != 0
                         && [[bValueTextField stringValue] length] != 0
                         && ([[cValueTextField stringValue] length] != 0 || [cValueTextField isHidden] == YES)
                         && [typeCombobox selectedTag] != -1);
    
    //TODO improve the validation of numbers
    BOOL areNumberTextFieldsCorrectlyFilled = (
                                               [numberFormatter numberFromString:[aValueTextField stringValue]] != nil
                                               && [numberFormatter numberFromString:[bValueTextField stringValue]] != nil
                                               && ([numberFormatter numberFromString:[cValueTextField stringValue]] || [cValueTextField isHidden] == YES)
                                               );
    
    return (areAllFilled && areNumberTextFieldsCorrectlyFilled);
}

-(IBAction)TEST:(id)sender{
    Function * f = nil;
    NSString * name = nil;
    NSColor * color = nil;
    FunctionType type;
    float a,b,c;
    
    int i;
    for(i=0; i<20; i++){
        name = [[NSString alloc] initWithFormat: @"FunctionNumber%d",i];
        type = arc4random_uniform(6);
        color = [NSColor colorWithRed: ((float)arc4random_uniform(100))/100 green:((float)arc4random_uniform(100))/100 blue:((float)arc4random_uniform(100))/100 alpha:1.0];
        a = ((float)arc4random_uniform(10000))/100;
        b = ((float)arc4random_uniform(10000))/100;
        c = ((float)arc4random_uniform(10000))/100;
        
        f = [[Function alloc] initWithName:name color:color ExpressionType:type ExpressionAValue:a ExpressionBValue:b ExpressionCValue:c];
        [model addFunction: f];
    }
    
    [tableView reloadData];
}

@end
