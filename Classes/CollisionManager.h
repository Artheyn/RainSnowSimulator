//
//  CollisionManager.h
//  Test
//
//  Created by Artheyn on 29/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CollisionManager : NSObject 
{

}

+(CollisionManager*) sharedInstance;

-(void) computeCollisions:(NSMutableSet*) collisionSet withTimeStep:(float) timeStep;
-(void) computeRainCollisionsWithTimeStep:(float) timeStep;

@end
