//
//  Particle.h
//  Test
//
//  Created by Artheyn on 21/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

#import "TextureManager.h"
#import "Point2f.h"
#import "Vect2.h"



@interface Particle : NSObject 
{
@private
	Point2f* position;
	Vect2* velocity;
	float collisionLife;
	float life;
	int particleId;
	float particleSize;
@protected
	TextureManager* textureManager;
}

@property float particleSize;
@property float life;
@property float collisionLife;
@property int particleId;
@property(nonatomic, retain) Point2f* position;
@property(nonatomic, retain) Vect2* velocity;

@property(nonatomic, retain) TextureManager* textureManager;


-(id) initWithPosition:(Point2f*) pos andVelocity:(Vect2*) velo;
-(id) initWithPosition:(Point2f*) pos Velocity:(Vect2*) velo AndSize:(float) sz;
-(id) initWithPosition:(Point2f*) pos Velocity:(Vect2*) velo Size:(float) sz AndLife:(float) lf;

//Display the point at the actual position
-(void)	display;
//Move the point with the actual timerInterval and affect with the external forces
-(void) moveWithTime:(float) time andExtForces:(Vect2*) extForces;


@end
