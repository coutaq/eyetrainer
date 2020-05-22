#import "NSGLView.h"
#import "OpenGLRenderer.h"∂

@interface NSGLView (PrivateMethods)

- (void) initGL;
- (void) drawView;

@end

@implementation NSGLView

OpenGLRenderer* m_renderer;

- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime
{
	// There is no autorelease pool when this method is called 
	// because it will be called from a background thread
	// It's important to create one or you will leak objects
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self drawView];
    
	[pool release];
	return kCVReturnSuccess;
}

// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    CVReturn result = [(NSGLView*)displayLinkContext getFrameForTime:outputTime];
    return result;
}

- (void) awakeFromNib
{   
    NSOpenGLPixelFormatAttribute attrs[] =
	{
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 24,
		// Must specify the 3.2 Core Profile to use OpenGL 3.2
#if ESSENTIAL_GL_PRACTICES_SUPPORT_GL3 
		NSOpenGLPFAOpenGLProfile,
		NSOpenGLProfileVersion3_2Core,
#endif
		0
	};
	
	NSOpenGLPixelFormat *pf = [[[NSOpenGLPixelFormat alloc] initWithAttributes:attrs] autorelease];
	
	if (!pf)
	{
		NSLog(@"No OpenGL pixel format");
	}
    
    NSOpenGLContext* context = [[[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil] autorelease];
    
    [self setPixelFormat:pf];
    
    [self setOpenGLContext:context];
}

- (void) prepareOpenGL
{
    _isStopping=false;
    
	[super prepareOpenGL];
	
	// Make all the OpenGL calls to setup rendering  
	//  and build the necessary rendering objects
	[self initGL];
	
	// Create a display link capable of being used with all active displays
	CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
	
	// Set the renderer output callback function
	CVDisplayLinkSetOutputCallback(displayLink, &MyDisplayLinkCallback, self);
	
	// Set the display link for the current renderer
	CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
	CGLPixelFormatObj cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];
	CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
	
	// Activate the display link
    
    // deactivating rendering start on
	// CVDisplayLinkStart(displayLink);
}

- (void) initGL
{
	// Make this openGL context current to the thread
	// (i.e. all openGL on this thread calls will go to this context)
	[[self openGLContext] makeCurrentContext];
	
	// Synchronize buffer swaps with vertical refresh rate
	GLint swapInt = 1;
	[[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	
	// Init our renderer.  Use 0 for the defaultFBO which is appropriate for MacOS (but not iOS)

	m_renderer = [[OpenGLRenderer alloc] initWithDefaultFBO:0:self.frame.size.width: self.frame.size.height];
}

- (void) reshape
{	
	[super reshape];
	
	// We draw on a secondary thread through the display link
	// When resizing the view, -reshape is called automatically on the main thread
	// Add a mutex around to avoid the threads accessing the context simultaneously when resizing
	CGLLockContext([[self openGLContext] CGLContextObj]);
	
	NSRect rect = [self bounds];
	
	[m_renderer resizeWithWidth:rect.size.width AndHeight:rect.size.height];
	
	CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

- (void) drawView
{	 
	[[self openGLContext] makeCurrentContext];

	// We draw on a secondary thread through the display link
	// When resizing the view, -reshape is called automatically on the main thread
	// Add a mutex around to avoid the threads accessing the context simultaneously	when resizing
	CGLLockContext([[self openGLContext] CGLContextObj]);
	
	[m_renderer render];
	
	CGLFlushDrawable([[self openGLContext] CGLContextObj]);
	CGLUnlockContext([[self openGLContext] CGLContextObj]);
    if(m_renderer.animationFinished && !_isStopping){
        _isStopping=true;
        [self.delegate animationOver];
    }
}

- (void) dealloc
{
	// Stop the display link BEFORE releasing anything in the view
    // otherwise the display link thread may call into the view and crash
    // when it encounters something that has been release
	CVDisplayLinkStop(displayLink);
    
	CVDisplayLinkRelease(displayLink);
        
	// Release the display link AFTER display link has been released
	[m_renderer release];
	
    [NSEvent removeMonitor:eventMon];
    
	[super dealloc];
}

-(void) stop
{
    _isStopped=true;
    [m_renderer stop];
    CVDisplayLinkStop(displayLink);
    
}

-(void) resume
{
    _isStopped=false;
    [m_renderer resume];
    CVDisplayLinkStart(displayLink);
}

-(void) endAnimation
{
//    [self stop];
    if(self.delegate){
        [self.delegate animationOver];
    }else{
        NSLog(@"Wtf No delegate to exit animation");
    }
    
}

-(void) mouseDown:(NSEvent *)event{
    if(self.delegate){
        [self.delegate view:self clickedWithEvent:event];
    }
}


@end
