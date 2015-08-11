//
//  Point2f.m
//  Test
//
//  Created by Artheyn on 21/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Point2f.h"


@implementation Point2f

@synthesize x;
@synthesize y;


-(id) initWithX:(float) aX andY:(float) aY
{
	if( !(self = [super init]) )
	{
		return nil;
	}
	
	self->x = aX;
	self->y = aY;
	
	return self;
}


-(GLfloat *) arrayValue
{
	static GLfloat v[2];
	v[0] = self->x;
	v[1] = self->y;
	
	return v;
}

-(void) plusEqualScalar:(float) aScalar
{
	printf("Scalar : %f\n", aScalar);
	self->x += aScalar;
	self->y += aScalar;
}

-(void) plusEqualVector:(Vect2*) aVector
{
	self->x += aVector.x;
	self->y += aVector.y;
}

-(void) display
{
	printf("\nPoint2f(%f, %f)\n", x, y);
}

+(float) lengthBetweenA:(Point2f*) aPoint andB:(Point2f*) anotherPoint
{
	return sqrt( (anotherPoint.x - aPoint.x)*(anotherPoint.x - aPoint.x) + (anotherPoint.y - aPoint.y)*(anotherPoint.y - aPoint.y) );
}



@end
