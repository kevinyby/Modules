#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioPlayer

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object {
    if ([object isKindOfClass: [AVAudioPlayer class]]){
        AVAudioPlayer* audio = (AVAudioPlayer*)object;
        
        int playMode = [[config objectForKey: @"MODE"] intValue];
        if (playMode == 1) {
            [audio pause];
            return;
        } else if (playMode == 2) {
            [audio stop];
            return;
        }
        
        // if mode == 0 , play it
        
        NSNumber* volumeNum = [config objectForKey: @"VOLUME"];
        NSNumber* loopNum = [config objectForKey: @"LOOP"];
        NSNumber* currentTimeNum = [config objectForKey: @"CURRENTTIME"];
        
        float volume = volumeNum ? [volumeNum floatValue] : 0.5;
        int loop = loopNum ? [loopNum intValue] : 0;
        float currentTime = currentTimeNum ? [currentTimeNum floatValue] : 0.0;
        audio.volume = volume;
        audio.numberOfLoops = loop;
        audio.currentTime = currentTime;
        if (audio.isPlaying) {
            [audio stop];
        }
        [audio performSelectorInBackground: @selector(play) withObject:nil];
        return;
    }
}


@end
