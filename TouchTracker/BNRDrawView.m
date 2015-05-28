//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by Dennis Nguyen on 5/24/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView () <UIGestureRecognizerDelegate> // Delegate needed to recognize two gestures at once

@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer; // Need pan + move to be recognized at the same time

@property (nonatomic, strong) NSMutableDictionary *linesInProgress; // Dict of currently drawn lines
@property (nonatomic, strong) NSMutableArray *finishedLines; // Array of finished lines
@property (nonatomic, weak) BNRLine *selectedLine;


@end

@implementation BNRDrawView

#pragma mark Controller life cycle


// Designated init - allocates array, sets background color
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES; // Enable multitouch
        
        // Tap gesture recognizer, when double tap occurs, doubleTap: is sent
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        // To prevent touchesBegan from firing off when gesture can still be recognized
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        // Single tap gesture recognizer
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.delaysTouchesBegan = YES;
        // Wait for double tap to fail before assuming single tap
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        // Long tap gesture recognizer
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        // Pan gesture recognizer, needs a delegate to send message when multiple gestures are found
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
        
    }
    
    return self;
}

#pragma mark View life cycle

// Allows this view to become first responder
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark Gestures

// tap: - On single tap, selects a line
- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized tap");
    CGPoint location = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:location];
    
    // UIMenuController implementation
    if (self.selectedLine)
    {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        // Make menu items, menuitem sends first responder action message
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        // Add menu items to menu
        menu.menuItems =  @[deleteItem];
        // Tell menu the location of where to display
        [menu setTargetRect:CGRectMake(location.x, location.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    else // Hide menu if no menu is selected
    {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        
    }
    
    [self setNeedsDisplay];
    
}
// doubleTap: Sent when gesture recognizer sees double tap, clears all lines
- (void)doubleTap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized double tap");
    // Clear array and dictionary
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    // redraw
    [self setNeedsDisplay];
}

#pragma mark Actions

// Beginning of a touch
- (void)touchesBegan:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    // Draw
    [self setNeedsDisplay];
}

// Moving of touch
- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches)
    {
        CGPoint location = [t locationInView:self];
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];

        line.end = location;
    }
    [self setNeedsDisplay];
}

// Ending of touch
- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        // clear dictionary
        [self.linesInProgress removeObjectForKey:key];
    }
}

// Interruption of touch
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // if cancelled, remove all current touches
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [[self linesInProgress] removeObjectForKey:key];
    }
}


// UILongPressGestureRecognizer - Long press
- (void)longPress:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        // Get touch point from UIGestureREcognizer
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        // If a long press is found at the long press point
        if (self.selectedLine)
        {
            [self.linesInProgress removeAllObjects];
        }
        else if (gr.state == UIGestureRecognizerStateEnded)
        {
            self.selectedLine = nil;
        }
        [self setNeedsDisplay];
    }
}

#pragma mark Drawing

- (void)moveLine:(UIPanGestureRecognizer *)gr
{
    // Do nothing if no line is selected
    if (!self.selectedLine)
    {
        return;
    }
    
    // When pan recognizer changes its position
    if (gr.state == UIGestureRecognizerStateChanged)
    {
        // Cancel touch drawing
        self.moveRecognizer.cancelsTouchesInView = YES;
        
        // How far
        CGPoint translation = [gr translationInView:self];
        
        // Starting positions, beginning and end point of line
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        // move both points
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        // Set new positions
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        [self setNeedsDisplay];
        
        // Set translation back to zero everytime it reports a change
        // will be continuous increase in movement if not set
        [gr setTranslation:CGPointZero inView:self];
    }
    
    if (gr.state == UIGestureRecognizerStateEnded)
    {
        self.moveRecognizer.cancelsTouchesInView = NO;
    }
}

- (void)deleteLine:(id)sender
{
    // remove selected line
    [self.finishedLines removeObject:self.selectedLine];
    [self setNeedsDisplay];
}
// Takes a line with two points and draws it on screen, needs to be in drawRect
- (void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    // Configure drawing line - set stroke size, and round caps for drawing
    bp.lineWidth = 5;
    bp.lineCapStyle = kCGLineCapRound;
    
    // Set beginning point and draw a line to the next point
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    // Stroke
    [bp stroke];
}

// Draws on view within a rect
- (void)drawRect:(CGRect)rect
{

    
    // Set color of stroke
    [[UIColor blackColor] setStroke];
    // FOR all finished lines, stroke each line
    for (BNRLine *line in self.finishedLines)
    {
        // Stroke each line
        [self strokeLine:line];
    }
    
    // IF there is current line is being drawn, set it to red then stroke
    [[UIColor redColor] setStroke];
    
    for (NSValue *key in self.linesInProgress)
    {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    // Selected lines
    if (self.selectedLine)
    {
        [[UIColor greenColor] setStroke];
        [self strokeLine:self.selectedLine];
    }
    
                    
}

// Takes a point and returns a line at that point
- (BNRLine *)lineAtPoint:(CGPoint)p
{
    // Find a line close to p
    for (BNRLine *l in self.finishedLines)
    {
        // Get beginning and ending points
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        // Check a few points on the line
        for (float t = 0.0; t <= 1.0; t += 0.05)
        {
            // imcrement through x and y values from start point to end point
            // walks along the line
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            // if current point on line is within 20 points of point p, return line
            if (hypot(x - p.x, y - p.y) < 20.0)
            {
                return l;
            }
        }
    }
    // return nothing if nothing is close
    return nil;
    
}

#pragma mark Protocols
// This message is sent to its delegate when it recognizes a testure but another gesture has recognized it too
// When user begins a long press, UIPanGestureRecognizer will be allowed to keep track of finger too
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // Return YES when _moveRecognizer sends the message
    if (gestureRecognizer == self.moveRecognizer)
    {
        return YES;
    }
    return NO;
}

@end
