//
//  main.m
//  FinalChallenge
//
//  Created by Alessandro on 08/06/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Speakable.h"

int main(int argc, const char * argv[])
{

	@autoreleasepool {
	    
	    srandom((unsigned int)time(NULL));
		int64_t randomBytes = (random() << 32) | random();
		
		NSData *inData = [NSData dataWithBytes:&randomBytes
										length:sizeof(int64_t)];
		NSLog(@"In Data = %@", inData);
		NSString *speakable = [inData encodeAsSpeakableString];
		NSLog(@"Got string \"%@\"", speakable);
		
		NSError *err;
		NSData *outData = [NSData dataWithSpeakableString:speakable
													error:&err];
		if (!outData) {
			NSLog(@"Unexpected error: %@", [err localizedDescription]);
			return -1;
		}
		NSLog(@"Out data: %@", outData);
		
		if (![outData isEqual:inData]) {
			NSLog(@"Data coming out not the same as what went in.");
			return -1;
		}
		
		// Test a misspelling
		speakable = @"2 Jeep 3 Halo 7 Teevo 2 Pepsi 2 Volvo";
		outData = [NSData dataWithSpeakableString:speakable
											error:&err];
		if (!outData) {
			NSLog(@"Expected error: %@", [err localizedDescription]);
		} else {
			NSLog(@"Missed bad string");
			return -1;
		}
		
	}
    return 0;
}

