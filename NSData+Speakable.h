//
//  NSData+Speakable.h
//  FinalChallenge
//
//  Created by Alessandro on 08/06/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Speakable)

- (NSString *)encodeAsSpeakableString;
+ (NSData *)dataWithSpeakableString:(NSString *)s
							  error:(NSError **)e;

@end
