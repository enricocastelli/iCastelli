//
//  VideoViewController.m
//  iCastelli
//
//  Created by Eyolph on 12/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface VideoViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *space;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIView *viewLayer;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.videoFile getFilePathInBackgroundWithBlock:^(NSString * _Nullable filePath, NSError * _Nullable error) {
        [self setCastelliPlayer:filePath];

    }];
}

- (void)setCastelliPlayer:(NSString*)path {
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    
    AVURLAsset *urlAss = [AVURLAsset assetWithURL:url];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:urlAss];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    AVPlayerLayer *layer = [AVPlayerLayer layer];
    
    [layer setPlayer:self.player];
    [layer setFrame: CGRectMake(self.viewLayer.frame.origin.x, self.viewLayer.frame.origin.y, self.viewLayer.frame.size.width -20, self.viewLayer.frame.size.height- 30)];
    [layer setBackgroundColor:[UIColor blueColor].CGColor];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.viewLayer.layer addSublayer:layer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    CMTime interval = CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC);
    [self.player addPeriodicTimeObserverForInterval:interval queue:NULL usingBlock:^(CMTime time) {
        CGFloat prog =  CMTimeGetSeconds(self.player.currentTime);
        self.progress.progress = prog/CMTimeGetSeconds(self.player.currentItem.asset.duration);
        self.progressLabel.text = [NSString stringWithFormat:@"%0.1f", prog];
        self.durationLabel.text = [NSString stringWithFormat:@"%0.1f", CMTimeGetSeconds(self.player.currentItem.asset.duration)];
;
    }];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.player pause];
}

- (IBAction)play:(UIButton *)sender {
    [self.player play];
}

- (IBAction)pause:(UIButton *)sender {
    [self.player pause];
}

- (void)itemDidFinishPlaying:(NSNotification *) notification
{
    Float64 seconds = 0;
    CMTime targetTime = CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
    [self.player seekToTime:targetTime];
}



@end
