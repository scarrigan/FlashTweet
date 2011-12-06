//
//  FlashTweetViewController.m
//  FlashTweet
//
//  Created by Steve Carrigan on 11/30/11.
//  Copyright (c) 2011 OryxSoftware. All rights reserved.
//

#import <Twitter/Twitter.h>
#import "FlashTweetViewController.h"
#import "Logger.h"

@implementation FlashTweetViewController

@synthesize tweetPhoto;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)tweet {
    // Create the view controller
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];

    if (tweetPhoto) {
        [twitter addImage:tweetPhoto];
    }
    
    // Show the controller
    [self presentModalViewController:twitter animated:YES];
    
    // Called when the tweet dialog has been closed
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {
        NSString *title = @"Flash Tweet";
        NSString *msg; 
        
        if (result == TWTweetComposeViewControllerResultCancelled) {
            msg = @"Tweet cancelled!";
        }
        else if (result == TWTweetComposeViewControllerResultDone) {
            msg = @"Tweet posted!";
        } 
        
        // Show alert to see how things went...
        if (msg) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alertView show];
        }
        
        // Dismiss the controller
        [self dismissModalViewControllerAnimated:YES];
        
        // Exit flash tweet application
        exit(1);
    }; 
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    /*cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];*/
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = delegate;
    
    [controller presentModalViewController: cameraUI animated: YES];
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flash Tweet" message:@"Take a photo for your tweet?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self startCameraControllerFromViewController:self usingDelegate:self];
    } else {
        [self tweet];
    }
    
}

#pragma mark - UIImagePickerView delegate

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {    
    [[picker presentingViewController] dismissModalViewControllerAnimated: YES];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage *originalImage, *editedImage, *imageToSave;
    
    editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }
        
    // Save the new image (original or edited) to the Camera Roll
    UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    tweetPhoto = imageToSave;
    
    [[picker presentingViewController] dismissModalViewControllerAnimated: YES];
}

- (IBAction)tweet:(id)sender {
    [self tweet];
}
@end
