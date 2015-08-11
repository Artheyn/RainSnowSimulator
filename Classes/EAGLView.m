//
//  EAGLView.m
//  Test
//
//  Created by Artheyn on 19/08/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "EAGLView.h"

#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end

@interface EAGLView(EAGLViewParticle)

-(void) initViewAndAccelerometer;

@end



@implementation EAGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;
@synthesize accelerometer;

@synthesize particleManager;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        animationInterval = 0.01f;
		[self initViewAndAccelerometer];
    }
    return self;
}


-(void) initViewAndAccelerometer
{
	particleManager = [ParticleManager sharedInstance];
	collisionManager = [CollisionManager sharedInstance];
	
	snowFontTex = [[particleManager textureManager] loadTexture:@"texSnowFont.png"];
	rainFontTex = [[particleManager textureManager] loadTexture:@"texRainFont.png"];
	
	rainEffect = YES;
	snowEffect = NO;
	
	paused = NO;
	
	[particleManager startRainEffect];
	
	// Setup the accelerometer
	self.accelerometer = [UIAccelerometer sharedAccelerometer];
	self.accelerometer.updateInterval = .1;
	self.accelerometer.delegate = self;
	
	
	//Setup the view
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
	
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	
	glEnable(GL_DEPTH_TEST);
}

// Get the accelerometer data
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
	// Set the gravity of the world
	[particleManager setGravity:[[Vect2 alloc] initWithX:10.0f*acceleration.x andY:acceleration.y]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touchesBegan");
	// Test for the screen off
//	CGPoint p;
//	
	for(UITouch* t in [event allTouches])
	{
		firstPosition = [t locationInView:self];
	}
//	
//	if(p.x >= 250 && p.y <= 70)
//	{
//			if(!paused)
//			{
//				[particleManager pauseWorld];
//				paused = YES;
//			}
//			else
//			{
//				[particleManager wakeupWorld];
//				paused = NO;
//			}
//		
//	}
//	else
//	{
//	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* t = [[UITouch alloc] init];
		
	for(UITouch* tou in [event allTouches])
	{
		t = tou;
	}
	
	if( [t locationInView:self].x - firstPosition.x >= 150 )
	{
		if(rainEffect)
		{
			rainEffect = NO;
			snowEffect = YES;
			[particleManager stopRainEffect];
			[particleManager startSnowEffect];
			
		}
		else
		{
			snowEffect = NO;
			rainEffect = YES;
			[particleManager stopSnowEffect];
			[particleManager startRainEffect];
		}
		firstPosition = [t locationInView:self];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touchesEnded");
}

const GLfloat squareVertices[] = {
-1.0, 1.5,               // Top left
-1.0, -1.5,              // Bottom left
1.0, -1.5,               // Bottom right
1.0, 1.5
};

const GLshort squareTextureCoords[] = {
0, 0,       // bottom left
0, 1,       // top left
1, 1,        // top right
1, 0       // bottom right

};


- (void)drawView {
	
    [EAGLContext setCurrentContext:context];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
    glViewport(0, 0, backingWidth, backingHeight);
	
	glClear(GL_COLOR_BUFFER_BIT);
	
	glDisable(GL_POINT_SPRITE_OES);
	
	if(rainEffect)
		glBindTexture(GL_TEXTURE_2D, rainFontTex);
	else
	if(snowEffect)
		glBindTexture(GL_TEXTURE_2D, snowFontTex);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glTexCoordPointer(2, GL_SHORT, 0, squareTextureCoords);
	
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_POINT_SPRITE_OES);
	
	[particleManager displayParticles];
	[particleManager moveParticles];
	
	if(rainEffect)
		[collisionManager computeRainCollisionsWithTimeStep: particleManager.timeStep];
	
	
//	if(snowEffect)
//		[collisionManager computeCollisions: particleManager.collisionSet withTimeStep: particleManager.timeStep];

    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
    self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}


- (void)dealloc {
    
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

@end
