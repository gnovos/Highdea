//
//  HIViewController.m
//  Highdea
//
//  Created by Mason on 8/25/13.
//  Copyright (c) 2013 Tych. All rights reserved.
//

#import "HIghViewController.h"

#import "HIghdea.h"

#import "HPGrowingTextView.h"

@interface HIghViewController ()

@property (weak, nonatomic) IBOutlet UITextView *highdeasView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutlet HPGrowingTextView *inputView;


@end

@implementation HIghViewController {
    NSMutableArray* _highdeas;
    NSTimer* _timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    _highdeas = [[NSMutableArray alloc] init];
    
    _highdeasView.clipsToBounds = YES;
    
    CALayer* layer = _highdeasView.layer;
    
    layer.masksToBounds = NO;
    layer.opaque = YES;
    
    [layer setBorderColor:[[UIColor colorWithRed:0.4f green:0.3f blue:0.8f alpha:0.4f] CGColor]];
    [layer setBorderWidth:3.0f];
    [layer setCornerRadius:30.0f];
    
    [layer setShadowColor:[UIColor blackColor].CGColor];
    [layer setShadowOpacity:0.8f];
    [layer setShadowRadius:3.0f];
    [layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    
    _inputView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 320, 40)];
    
    _inputView.contentInset = UIEdgeInsetsMake(0, 5, 0, 10);
    
	_inputView.minNumberOfLines = 1;
	_inputView.maxNumberOfLines = 6;
	_inputView.returnKeyType = UIReturnKeySend;
	_inputView.font = [UIFont systemFontOfSize:15.0f];
	_inputView.delegate = self;
    _inputView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 10, 0);
    _inputView.backgroundColor = [UIColor whiteColor];
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 315, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [_containerView addSubview:imageView];
    [_containerView addSubview:_inputView];
    [_containerView addSubview:entryImageView];
    
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    
    [_highdeasView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resign)]];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resign];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self pollHighdeas];
}

- (void) viewWillDisappear:(BOOL)animated {
    [_timer invalidate];
    _timer = nil;
    
    [super viewWillDisappear:animated];
}

- (void) resign {
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:42.0f target:self selector:@selector(pollHighdeas) userInfo:nil repeats:YES];

    [_inputView resignFirstResponder];
    [self pollHighdeas];
}

- (void) addIdeas:(NSArray*)ideas {
    [_highdeas addObjectsFromArray:[ideas filteredArrayUsingPredicate:
                                    [NSPredicate predicateWithBlock:^BOOL(HIghdea* hi, NSDictionary *bindings) {
        return hi.idea && ![_highdeas containsObject:hi];
    }]]];
    
    [_highdeas filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HIghdea* hi, NSDictionary *bindings) {
        return hi.idea.length > 0;
    }]];
    
    [_highdeas setArray:[[NSSet setWithArray:_highdeas] allObjects]];
    
    NSUInteger count = [_highdeas count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [_highdeas exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    HIghdea* idea;    
    while ((idea = [_highdeas lastObject]) && !(idea.idea && idea.idea.length)) {
        [_highdeas removeLastObject];        
    }
    
    [UIView transitionWithView:_highdeasView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _highdeasView.text = [NSString stringWithFormat:@"“%@”\n", idea.idea];
                        NSRange range = NSMakeRange(_highdeasView.text.length - 1, 1);
                        [_highdeasView scrollRangeToVisible:range];
                    }
                    completion:^(BOOL finished) {
                        //                            _highdeasView.text = idea.idea;
                    }];

}

- (IBAction) pollHighdeas {
    
    [HIghdea highdeas:^(NSArray *ideas) {
        [self addIdeas:ideas];
    }];
    
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = _containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	_containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = _containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	_containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = _containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	_containerView.frame = r;
}

- (BOOL) growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    return YES;
}

- (void) growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView {
    NSString* idea = _inputView.text;
    _inputView.text = @"";
    [UIView transitionWithView:_highdeasView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _highdeasView.text = [NSString stringWithFormat:@"“%@”\n", idea];
                        NSRange range = NSMakeRange(_highdeasView.text.length - 1, 1);
                        [_highdeasView scrollRangeToVisible:range];
                    }
                    completion:^(BOOL finished) {
                        [HIghdea create:idea withCompletion:^(NSArray *ideas) {
                            [self addIdeas:ideas];
                        }];
                    }];
}

@end
