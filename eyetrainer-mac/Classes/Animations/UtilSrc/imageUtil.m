/*
     File: imageUtil.m
 Abstract: 
 Functions for loading an image files for textures.
 
  Version: 1.6
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "imageUtil.h"

#if ESSENTIAL_GL_PRACTICES_IOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

demoImage* imgLoadImage(NSString* filepathname, int flipVertical)
{
  
    NSImage *nsimage = [NSImage imageNamed: filepathname];
	
	NSBitmapImageRep *imageClass = [[NSBitmapImageRep alloc] initWithData:[nsimage TIFFRepresentation]];
	
	CGImageRef cgImage = imageClass.CGImage;
	if (!cgImage)
	{
        [imageClass release];
		return NULL;
	}
	
	demoImage* image =(demoImage*) malloc(sizeof(demoImage));
	image->width = CGImageGetWidth(cgImage);
	image->height = CGImageGetHeight(cgImage);
	image->rowByteSize = image->width * 4;
	image->data =(GLubyte*) malloc(image->height * image->rowByteSize);
	image->format = GL_RGBA;
	image->type = GL_UNSIGNED_BYTE;
	
	CGContextRef context = CGBitmapContextCreate(image->data, image->width, image->height, 8, image->rowByteSize, CGImageGetColorSpace(cgImage), kCGImageAlphaNoneSkipLast);
	CGContextSetBlendMode(context, kCGBlendModeCopy);
	if(flipVertical)
	{
		CGContextTranslateCTM(context, 0.0, image->height);
		CGContextScaleCTM(context, 1.0, -1.0);
	}
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, image->width, image->height), cgImage);
	CGContextRelease(context);
	
	if(NULL == image->data)
	{
		imgDestroyImage(image);
        
        [imageClass release];
		return NULL;
	}
	
    [imageClass release];
    
	return image;
}

void imgDestroyImage(demoImage* image)
{
	free(image->data);
	free(image);
}

GLuint buildTexture(demoImage* image)
{
	GLuint texName;
	
	// Create a texture object to apply to model
	glGenTextures(1, &texName);
	glBindTexture(GL_TEXTURE_2D, texName);
	
	// Set up filter and wrap modes for this texture object
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	// Indicate that pixel rows are tightly packed
	//  (defaults to stride of 4 which is kind of only good for
	//  RGBA or FLOAT data types)
	//glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
	
	// Allocate and load image data into texture
	glTexImage2D(GL_TEXTURE_2D, 0, image->format, image->width, image->height, 0,
				 image->format, image->type, image->data);
    
	// Create mipmaps for this texture for better image quality
	//glGenerateMipmap(GL_TEXTURE_2D);
	
	return texName;
}

GLuint loadTexture(NSString* fileName)
{
    demoImage* img =  imgLoadImage(fileName, false);
    GLuint texName = buildTexture(img);
    imgDestroyImage(img);
    return texName;
}