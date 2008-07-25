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
                size: (float) size
               color: (NSColor *) color
{
    self = [super initWithFrame: frameRect];

    if (self)
    {
        NSDictionary *fontAttributes = 
            [NSDictionary dictionaryWithObjectsAndKeys: 
                name, NSFontNameAttribute, 
                [NSNumber numberWithFloat: size], NSFontFixedAdvanceAttribute, 
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
            [NSFont fontWithName: @"Lucida Grande" size: kPinyinFontSize], NSFontAttributeName, 
            color, NSForegroundColorAttributeName, nil];
    
        _size = size;
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

        [hanzi drawAtPoint: NSMakePoint(10, 10) 
            withAttributes: _hanAttributes];

        NSArray *pinyin = [_item pinyin];

        if (pinyin)
        {
            NSEnumerator *enumerator = [pinyin objectEnumerator];
            NSString *py;
            float y = 10 + _size + 10;
            float x = 10;

            while (py = [enumerator nextObject])
            {
                float shift = (_size - [py sizeWithAttributes: _pyAttributes].width) / 2;
                NSRect rect = NSMakeRect(x + shift, y, _size, kPinyinFontSize);

                [py drawInRect: rect
                withAttributes: _pyAttributes];

                x += _size;
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
