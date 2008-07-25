// PYView.m: PinyinView Implementation
// by Jjgod Jiang <gzjjgod@gmail.com>

#import "PYView.h"

@implementation PYMarkerItem

- (id) initWithHanzi: (NSString *) hanzi
              pinyin: (NSArray *) pinyin
                type: (int) type
{
    self = [super init];

    if (self)
    {
        _han = [hanzi retain];
        _py  = [pinyin retain];
        type = type;
    }

    return self;
}

- (void) dealloc
{
    [_han release];
    [_py release];

    [super dealloc];
}

- (NSString *) hanzi
{
    return _han;
}

- (NSArray *) pinyin
{
    return _py;
}

- (int) type
{
    return _type;
}

@end

@implementation PYView

- (id) initWithFrame: (NSRect) frameRect
            fontName: (NSString *) name
               color: (NSColor *) color
{
    self = [super initWithFrame: frameRect];

    if (self)
    {
        float size = (frameRect.size.height - kPinyinViewBorder * 2 - 
                      kPinyinHanziLeading) / (1 + kPinyinFontSizeRatio);
        _advance = size * kFontAdvanceRatio;

        NSLog(@"size = %g", size);

        NSDictionary *fontAttributes = 
            [NSDictionary dictionaryWithObjectsAndKeys: 
                name, NSFontNameAttribute, 
                [NSNumber numberWithFloat: _advance], NSFontFixedAdvanceAttribute, 
                nil];
    
        NSFontDescriptor *descriptor = 
            [NSFontDescriptor fontDescriptorWithFontAttributes: fontAttributes];
            
        if (! descriptor)
            return nil;

        NSFont *font = [NSFont fontWithDescriptor: descriptor 
                                             size: size];
        if (! font)
            return nil;
            
        _hanAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: 
            font, NSFontAttributeName, 
            color, NSForegroundColorAttributeName, nil];
        
        _pyAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: 
            [NSFont fontWithName: @"Helvetica Neue Light" size: kPinyinFontSizeRatio * size], NSFontAttributeName, 
            color, NSForegroundColorAttributeName, nil];

        _size = size;
        // Relax for a few more pixels
        _pinyinSize = kPinyinFontSizeRatio * size + 3;
    }
    
    return self;
}

- (void) drawRect: (NSRect) rect
{
    [[NSColor blackColor] set];
    NSRectFill(rect);

    if (_item && [_item hanzi])
    {
        NSString *hanzi = [_item hanzi];

        [hanzi drawAtPoint: NSMakePoint(kPinyinViewBorder, kPinyinViewBorder) 
            withAttributes: _hanAttributes];

        NSArray *pinyin = [_item pinyin];

        if (pinyin)
        {
            NSEnumerator *enumerator = [pinyin objectEnumerator];
            NSString *py;

            float y = kPinyinViewBorder + _size + kPinyinHanziLeading;
            float x = kPinyinViewBorder;

            while (py = [enumerator nextObject])
            {
                // Center the pinyin
                float shift = (_advance - [py sizeWithAttributes: _pyAttributes].width) / 2;

                [py drawAtPoint: NSMakePoint(x + shift, y)
                 withAttributes: _pyAttributes];

                x += _advance;
            }
        }
    }
}

- (void) setMarkerItem: (PYMarkerItem *) item
{
    [_item release];
    _item = [item retain];
}

- (void) dealloc
{
    [_item release];
    [_hanAttributes release];
    [_pyAttributes release];
    
    [super dealloc];
}

@end
