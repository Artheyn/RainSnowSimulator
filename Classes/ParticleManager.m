//
//  ParticleManager.m
//  Test
//
//  Created by Artheyn on 26/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParticleManager.h"
#import "Utils.h"

#define PARTICLE_COUNT 10
#define PARTICLES_RAIN_COUNT 10


static ParticleManager* sharedParticleManager;

@implementation ParticleManager


@synthesize snowEffectTimer;
@synthesize rainEffectTimer;
@synthesize textureManager;
@synthesize particlesSet;
@synthesize collisionSet;
@synthesize timeStep;
@synthesize gravity;


// Get the instance of the singleton class ParticleManager
+(ParticleManager*) sharedInstance
{
	if(!sharedParticleManager)
	{
		sharedParticleManager = [[[self class] alloc] init];
		sharedParticleManager->particlesSet = [[NSMutableSet alloc] init];
		sharedParticleManager->collisionSet = [[NSMutableSet alloc] init];
		sharedParticleManager->timeStep = 0.01f;
		sharedParticleManager->gravity = [[Vect2 alloc] initWithX:0.0f andY:-1.0f];
		sharedParticleManager->textureManager = [TextureManager sharedInstance];
		sharedParticleManager->lastState = [[NSMutableString alloc] init];
		sharedParticleManager->isWorldActive = YES;
		
		//sharedParticleManager->displayFlag = 0;
	}
	
	return sharedParticleManager;
}



//TODO regler le probleme du sleep (screen off) de l'iphone appli pause/resume...

-(void) pauseWorld
{
	if(isWorldActive)
	{
		if(rainEffectTimer)
		{
			lastState = @"rain";
			[self.rainEffectTimer invalidate];
		}
		else
			if(snowEffectTimer)
			{
				lastState = @"snow";
				[self.snowEffectTimer invalidate];
			}
		
		isWorldActive = NO;
	}
}

-(void) wakeupWorld
{
	if(!isWorldActive)
	{
		if(lastState == @"rain")
			[self startRainEffect];
		else
			if(lastState == @"snow")
				[self startSnowEffect];
		
		isWorldActive = YES;	
	}
		
}


// Add a particle to the set of particles
-(void)	addParticle:(Particle*) aParticle
{
	[particlesSet addObject:aParticle];
	[collisionSet addObject:aParticle];
}

// Display all particles
-(void) displayParticles
{
//	if(isWorldActive)
		for(Particle* p in particlesSet)
			[p display];
}


// Move all particles
-(void) moveParticles
{	
	if(isWorldActive)
	{
		NSMutableSet* objectToBeDeleted = [[NSMutableSet alloc] init];
		
		for(Particle* p in particlesSet)
		{
			if(![Vect2 isVectorTo0:p.velocity])
			{
				[p moveWithTime:timeStep andExtForces:gravity];
				
				if(p.position.x >= 1.0f || p.position.x <= -1.0f)
				{
					[objectToBeDeleted addObject:p];
				}
			}
			
			[p setLife:(p.life - timeStep)];
			if(p.life <= 0.0f)
				[objectToBeDeleted addObject:p];
		}
		
		for(Particle* pDel in objectToBeDeleted)
		{
			[particlesSet removeObject:pDel];
			[collisionSet removeObject:pDel];
			[pDel release];
		}
		
		[objectToBeDeleted removeAllObjects];
		
		[objectToBeDeleted release];	
	}
}


//Effects



/******** RAIN EFFECT */

-(void) generateRainParticles
{	
	for(int i=0; i < PARTICLES_RAIN_COUNT; i++)
	{
		RainParticle* rP = [[RainParticle alloc] initWithPosition:[[Point2f alloc] initWithX:[Utils getRandomBetween:-1.0f And:1.0f] andY:(1.5f+[Utils getRandomBetween0and1])] 
													Velocity:[[Vect2 alloc] initWithX:0.5f andY:-10.f]
													 AndSize: 15.0f];
		[rP loadTexture:@"texWater.png"];
		[self addParticle:rP];
	}
}

-(void) startRainEffect
{
	NSTimeInterval p = 0.1f;
	self.rainEffectTimer = [NSTimer scheduledTimerWithTimeInterval: p target:self selector:@selector(rainEffect) userInfo:nil repeats:YES];	
}

-(void) stopRainEffect
{
	NSMutableSet* objectToBeDeleted = [[NSMutableSet alloc] init];
	
	// Stop the timer
	[self.rainEffectTimer invalidate];
	self.rainEffectTimer = nil;
	
	for(Particle* p in particlesSet)
		[objectToBeDeleted addObject:p];

	for(Particle* pDel in objectToBeDeleted)
	{
		[collisionSet removeObject:pDel];
		[particlesSet removeObject:pDel];
		[pDel release];
	}
	
	[objectToBeDeleted removeAllObjects];
	[objectToBeDeleted release];
}

-(void) rainEffect
{
	[self generateRainParticles];
}


/******** END RAIN EFFECT */


/******** SNOW EFFECT */

// Load PARTICLE_COUNT particles and put them in the particlesSet
-(void) generateSnowParticles
{
	//		[self addParticle:[[Particle alloc] initWithPosition:[[Point2f alloc] initWithX:[Utils getRandomBetweenMinus1And1] andY:1.25f] 
	//												 andVelocity:[[Vect2 alloc] initWithX:[Utils getRandomBetweenMinus1And1] andY:0.0f]]];
	
	for(int i=0; i < PARTICLE_COUNT; i++)
	{
		SnowParticle* sP = [[SnowParticle alloc] initWithPosition:[[Point2f alloc] initWithX:[Utils getRandomBetweenMinus1And1] andY:(1.5f+[Utils getRandomBetween0and1])] 
												   andVelocity:[[Vect2 alloc] initWithX:[Utils getRandomBetweenMinus1And1] andY:-3.f]];
		[sP loadTexture:@"texSnow.png"];
		[self addParticle:sP];
	}
	
}


-(void) startSnowEffect
{	
	//self->snowEffectTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5f target:self selector:@selector(snowEffect) userInfo:nil repeats:YES];
	self.snowEffectTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5f target:self selector:@selector(snowEffect) userInfo:nil repeats:YES];
		//self->snowEffectTimer = [NSTimer scheduledTimerWithTimeInterval: 5.5f target:self selector:@selector(snowEffect) userInfo:nil repeats:YES];
		//printf("Snow effect start\n");
}

-(void) stopSnowEffect
{	
	NSMutableSet* objectToBeDeleted = [[NSMutableSet alloc] init];
	
	[self.snowEffectTimer invalidate];
	self.snowEffectTimer = nil;
	
	// Delete all the particles
	for(Particle* p in particlesSet)
		[objectToBeDeleted addObject:p];
	
	for(Particle* pDel in objectToBeDeleted)
	{
		[collisionSet removeObject:pDel];
		[particlesSet removeObject:pDel];
		[pDel release];
	}
	
	[objectToBeDeleted removeAllObjects];
	[objectToBeDeleted release];
}

-(void) snowEffect
{
	[self generateSnowParticles];
	
}


/******** END SNOW EFFECT */


/******** ANIMATION EFFECT */
// Called each 2 seconds
-(void) animateCharacter
{
	
}

// Update texture for movement : called by animateCharacter
-(void) updateTexture
{
	
}

@end
