//
//  Vect2.m
//  Test
//
//  Created by Artheyn on 20/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Vect2.h"

@implementation Vect2

@synthesize x;
@synthesize y;


-(id) initWithX:(float) xV andY:(float) yV
{
	// Init the super class (here NSObject)
	if( !(self = [super init]) )
	{
		return nil;
	}
	
	// Initiliaze position attributes with parameters xP and yP
	self->x = xV;
	self->y = yV;
	
	// Return the initialiized object
	return self;
	
}

-(GLfloat*) arrayValue
{	
	static GLfloat v[2];
	v[0] = self->x; 
	v[1] = self->y;
	
	return v;
}

-(void)	plusEqualVector:(Vect2*) aVector
{
	self->x += aVector.x;
	self->y += aVector.y;
}

-(void)	plusEqualScalar:(float) aScalar
{
	self->x += aScalar;
	self->y += aScalar;
}

-(void) display
{
	printf("\nVect2(%f, %f)\n", x, y);
}

+(Vect2*) multScalar:(float) aScalar withVector:(Vect2*) aVector
{	
	Vect2* v = [[Vect2 alloc]initWithX:aScalar*aVector.x andY:aScalar*aVector.y];
	
	return [v autorelease];
}

+(BOOL) isVectorTo0:(Vect2*) aVector
{
	return ( (aVector.x == 0.0f) && (aVector.y == 0.0f) );
}




@end