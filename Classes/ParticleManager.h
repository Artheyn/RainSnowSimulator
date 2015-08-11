//
//  ParticleManager.h
//  Test
//
//  Created by Artheyn on 26/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnowParticle.h"
#import "RainParticle.h"
#import "TextureManager.h"

@interface ParticleManager : NSObject
{
@private
	NSMutableSet* particlesSet;
	NSMutableSet* collisionSet;
	
//	// Flag to optimize the display of the particles
//	int displayFlag;
	
	// Vector of gravity
	Vect2* gravity;
	// To generate unik id for a particle
	int particleId;
	// The time step of the animation
	float timeStep;
	// The texture manager which manages to load textures
	TextureManager* textureManager;
	// Flag to know in which state was the world
	NSMutableString* lastState;
	// To stop moving particles when the world is paused
	BOOL isWorldActive;
	
	//Effects timers
	NSTimer* snowEffectTimer;
	NSTimer* rainEffectTimer;
	
	NSTimer* animateCharacterTimer;
	NSTimer* updateTextureTimer;
}

@property(nonatomic, assign)	NSTimer* snowEffectTimer;
@property(nonatomic, assign)	NSTimer* rainEffectTimer;
@property(nonatomic, retain)	NSMutableSet* particlesSet;
@property(nonatomic, retain)	NSMutableSet* collisionSet;
@property(nonatomic, retain)	TextureManager* textureManager;
@property(nonatomic, retain)	Vect2* gravity;
@property(nonatomic)			float timeStep;

+(ParticleManager*) sharedInstance;


-(void)	addParticle:(Particle*) aParticle;
-(void) displayParticles;
-(void) moveParticles;

//Effects

-(void) pauseWorld;
-(void) wakeupWorld;

/******** SNOW EFFECT */
-(void) generateSnowParticles;
-(void) startSnowEffect;
-(void) stopSnowEffect;
-(void) snowEffect;

/******** RAIN EFFECT */
-(void) generateRainParticles;
-(void) startRainEffect;
-(void) stopRainEffect;
-(void) rainEffect;


/******** ANIMATION EFFECT */
// Called each 2 seconds
-(void) animateCharacter;

// Update texture for movement : called by animateCharacter
-(void) updateTexture;


@end
