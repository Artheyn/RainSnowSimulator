//
//  Particle.m
//  Test
//
//  Created by Artheyn on 21/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Particle.h"
#import "EAGLView.h"
#import "Utils.h"


@implementation Particle

@synthesize position;
@synthesize velocity;
@synthesize particleId;
@synthesize life;
@synthesize collisionLife;
@synthesize particleSize;

@synthesize textureManager;


-(id) initWithPosition:(Point2f*) pos andVelocity:(Vect2*) velo
{
	if( !(self = [super init]) )
	{
		return nil;
	}
	
	self->position = [[Point2f alloc] initWithX:[pos x] andY:[pos y]];
	self->velocity = [[Vect2 alloc] initWithX:[velo x] andY:[velo y]];
	
	self->collisionLife = 2.5f;
	self->life = 0.9f + [Utils getRandomBetween:0.0f And:0.2f];
	self->particleSize = [Utils getRandomBetween:3.0f And:6.0f];
	//self->particleSize = 15.0f;	
	//self->life = 100.0f;
	
	self->textureManager = [TextureManager sharedInstance];
	
	return self;
}

-(id) initWithPosition:(Point2f*) pos Velocity:(Vect2*) velo AndSize:(float) sz
{
	if( !(self = [super init]) )
	{
		return nil;
	}
	
	self->position = [[Point2f alloc] initWithX:[pos x] andY:[pos y]];
	self->velocity = [[Vect2 alloc] initWithX:[velo x] andY:[velo y]];
	self->particleSize = sz;
	self->life = 100.0f;
	
	self->textureManager = [TextureManager sharedInstance];
	
	return self;
}


-(id) initWithPosition:(Point2f*) pos Velocity:(Vect2*) velo Size:(float) sz AndLife:(float) lf
{
	if( !(self = [super init]) )
	{
		return nil;
	}
	
	self->position = [[Point2f alloc] initWithX:[pos x] andY:[pos y]];
	self->velocity = [[Vect2 alloc] initWithX:[velo x] andY:[velo y]];
	
	self->collisionLife = 2.5f;
	self->life = 0.5f + [Utils getRandomBetween:0.0f And:0.2f];
	self->particleSize = sz;
	
	self->life = lf;
	
	self->textureManager = [TextureManager sharedInstance];
	
	return self;
}




-(void)	display
{
	//glDisable(GL_TEXTURE_2D);
	//const GLubyte color[] = {255, 255, 255, 255};
//	glEnableClientState(GL_COLOR_ARRAY);
//	glColorPointer(4, GL_UNSIGNED_BYTE, 0, color);
	glPointSize(self->particleSize);
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, [self.position arrayValue]);
	
//	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//	glTexCoordPointer(2, GL_SHORT, 0, spriteTexcoords);
	

	glDrawArrays(GL_POINTS, 0, 1);
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void) moveWithTime:(float) time andExtForces:(Vect2*) extForces
{
	Vect2* tmp = [[Vect2 alloc] init];
	tmp = [Vect2 multScalar:time withVector:self.velocity];

	[self.velocity plusEqualVector: [Vect2 multScalar:time withVector:extForces]];
	[self.position plusEqualVector:tmp];
	
}

@end
