//
//  CollisionManager.m
//  Test
//
//  Created by Artheyn on 29/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CollisionManager.h"
#import "ParticleManager.h"
#import "Particle.h"
#import "Utils.h"
#import "Vect2.h"


static CollisionManager* sharedCollisionManager;

@implementation CollisionManager

static float minValue;


+(CollisionManager*) sharedInstance
{
	// Initialize the shared instance
	if(!sharedCollisionManager)
	{
		sharedCollisionManager = [[CollisionManager alloc] init];
		minValue = -1.10f;
	}
	
	return sharedCollisionManager;
}


-(void) computeCollisions:(NSMutableSet*) collisionSet withTimeStep:(float) timeStep
{
	NSMutableSet* objectToBeDeleted = [[NSMutableSet alloc] init];
	
	
	// We test only the collisions between the particles in movement and the static particles
	for(Particle* p in collisionSet)
	{
		[p setCollisionLife:([p collisionLife] - timeStep)];
		
		if([p collisionLife] <= 0.0f)
		{
			[objectToBeDeleted addObject:p];
		}
		else
		{
			// If the current particle is already on bottom we don't test the collision now
			if(![Vect2 isVectorTo0:p.velocity])
			{
				// If the particle is in collision with the bottom
				if(p.position.y <= minValue)
				{
					p.velocity.x = 0.0f;
					p.velocity.y = 0.0f;
				}
				else // Else while the particle has not an y position below minValue+particleRadius
					if(p.position.y <= (minValue + 0.015f))
					{
						for(Particle* pEach in collisionSet)
						{
							if(pEach.position.y <= (minValue + 0.015f))
							{
								// If there is a collision between particles
								if([Point2f lengthBetweenA:p.position andB:pEach.position] <= 0.015f)
								{
									//printf("Length : %f\n",[Point2f lengthBetweenA:p.position andB:pEach.position]);
									if([Vect2 isVectorTo0:pEach.velocity])
									{
										minValue = p.position.y;
										p.velocity.x = 0.0f;
										p.velocity.y = 0.0f;
									}
								}	
							}
						}
					}
			}
		}
	}
	
	for(Particle* pDel in objectToBeDeleted)
	{
		[collisionSet removeObject:pDel];
	}
	
	[objectToBeDeleted removeAllObjects];
	[objectToBeDeleted release];
}


-(void) computeRainCollisionsWithTimeStep:(float) timeStep
{
	ParticleManager* partMan = [ParticleManager sharedInstance];
	
	NSMutableSet* objectToBeDeleted = [[NSMutableSet alloc] init];
	
	for(Particle* p in partMan.collisionSet)
	{
		// When the particle enter in collision with the ground
		if(p.position.y <= -1.35f)
		{
			[objectToBeDeleted addObject:p];
			
			// The particle is destroyed and two new particles are created with a tiny life time
			RainParticle* rP = [[RainParticle alloc] initWithPosition:[[Point2f alloc] initWithX:p.position.x andY:p.position.y] 
																	Velocity:[[Vect2 alloc] initWithX:[Utils getRandomBetween:-1.5f And:1.5f] andY:1.0f] 
																		Size:5.5f
																		AndLife:0.1f];
			RainParticle* rPS = [[RainParticle alloc] initWithPosition:[[Point2f alloc] initWithX:p.position.x andY:p.position.y] 
																	Velocity:[[Vect2 alloc] initWithX:[Utils getRandomBetween:-1.5f And:1.5f] andY:1.0f] 
																		Size:5.5f
																		AndLife:0.1f];
			[rP loadTexture:@"texWater.png"];
			[rPS loadTexture:@"texWater.png"];
			
			[partMan.particlesSet addObject:rP];
			[partMan.particlesSet addObject:rPS];
		}
	}
	
	// Destroying all the dead particles
	for(Particle* pDel in objectToBeDeleted)
	{
		[partMan.collisionSet removeObject:pDel];
		[partMan.particlesSet removeObject:pDel];
		[pDel release];
	}
	
	[objectToBeDeleted removeAllObjects];
	[objectToBeDeleted release];
}

@end
