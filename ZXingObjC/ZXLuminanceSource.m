/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ZXLuminanceSource.h"

@interface ZXLuminanceSource ()

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) BOOL cropSupported;
@property (nonatomic, assign) BOOL rotateSupported;

@end

@implementation ZXLuminanceSource

@synthesize width;
@synthesize height;
@synthesize cropSupported;
@synthesize rotateSupported;

- (id)initWithWidth:(int)aWidth height:(int)aHeight {
  if (self = [super init]) {
    self.width = aWidth;
    self.height = aHeight;
  }

  return self;
}


/**
 * Fetches one row of luminance data from the underlying platform's bitmap. Values range from
 * 0 (black) to 255 (white). Because Java does not have an unsigned byte type, callers will have
 * to bitwise and with 0xff for each value. It is preferable for implementations of this method
 * to only fetch this row rather than the whole image, since no 2D Readers may be installed and
 * getMatrix() may never be called.
 */
- (unsigned char *)row:(int)y row:(unsigned char *)row {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}


/**
 * Fetches luminance data for the underlying bitmap. Values should be fetched using:
 * int luminance = array[y * width + x] & 0xff;
 * 
 * Returns A row-major 2D array of luminance values. Do not use result.length as it may be
 * larger than width * height bytes on some platforms. Do not modify the contents
 * of the result.
 */
- (unsigned char *)matrix {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}


/**
 * Returns a new object with cropped image data. Implementations may keep a reference to the
 * original data rather than a copy. Only callable if isCropSupported() is true.
 */
- (ZXLuminanceSource *)crop:(int)left top:(int)top width:(int)width height:(int)height {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:@"This luminance source does not support cropping."
                               userInfo:nil];
}


/**
 * Returns a new object with rotated image data. Only callable if isRotateSupported() is true.
 */
- (ZXLuminanceSource *)rotateCounterClockwise {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:@"This luminance source does not support rotation."
                               userInfo:nil];
}

- (NSString*)description {
  unsigned char* row = NULL;
  NSMutableString* result = [NSMutableString stringWithCapacity:height * (width + 1)];
  for (int y = 0; y < height; y++) {
    row = [self row:y row:row];
    for (int x = 0; x < width; x++) {
      int luminance = row[x] & 0xFF;
      unichar c;
      if (luminance < 0x40) {
        c = '#';
      } else if (luminance < 0x80) {
        c = '+';
      } else if (luminance < 0xC0) {
        c = '.';
      } else {
        c = ' ';
      }
      [result appendFormat:@"%C", c];
    }
    [result appendString:@"\n"];
    free(row);
    row = NULL;
  }
  return result;
}

@end
