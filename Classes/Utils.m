//
//  Utils.m
//  Test
//
//  Created by Artheyn on 26/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"


@implementation Utils


+(float) getRandomBetween0and1
{
	return arc4random() % RAND_MAX /((float) RAND_MAX + 1);
}

+(float) getRandomBetweenMinus1And1
{
	return (arc4random() % RAND_MAX /((float) RAND_MAX + 1)) - (arc4random() % RAND_MAX /((float) RAND_MAX - 1));
}

+(float) getRandomBetween:(float) lower And:(float) higher
{
	return lower + (higher - lower)*(1.0f*arc4random())/((float) RAND_MAX);
}

@end
