//
//  EAGLView.h
//  Test
//
//  Created by Artheyn on 19/08/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <UIKit/UIAccelerometer.h>


#import "Utils.h"
#import "Vect2.h"
#import "Point2f.h"
#import "Particle.h"
#import "ParticleManager.h"
#import "CollisionManager.h"


/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/

@interface EAGLView : UIView<UIAccelerometerDelegate> {
    
@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
	
	Particle* pDirect;
	
	ParticleManager* particleManager;
	CollisionManager* collisionManager;
	
	UIAccelerometer* accelerometer;
	
	BOOL rainEffect;
	BOOL snowEffect;
	
	BOOL paused;
	
	CGPoint firstPosition;
	
	GLuint snowFontTex;
	GLuint rainFontTex;
}

@property NSTimeInterval animationInterval;
@property (nonatomic, retain) UIAccelerometer* accelerometer;
@property (nonatomic, retain)		  ParticleManager* particleManager;

//-(void)Accelerometer:(UIAccelerometer*)Accelerometer didAccelerate:(UIAcceleration*)Acceleration;
//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end
