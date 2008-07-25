// PYView.m: PinyinView Implementation
// by Jjgod Jiang <gzjjgod@gmail.com>

#import "PYView.h"

@implementation PYMarkerItem

+ (id) itemWithHanzi: (NSString *) hanzi
              pinyin: (NSArray *) pinyin
                type: (int) type
{
    return [[[PYMarkerItem alloc] initWithHanzi: hanzi
                                         pinyin: pinyin
                                           type: type] autorelease];
}

- (id) initWithHanzi: (NSString *) hanzi
              pinyin: (NSArray *) pinyin
                type: (int) type
{
    self = [super init];

    if (self)
    {
        _han = [hanzi retain];
        _py  = [pinyin retain];
        _type = type;
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

        _items = [[NSMutableArray alloc] initWithCapacity: kMarkerItemsInitialCapacity];
    }

    return self;
}

- (float) drawItem: (PYMarkerItem *) item
           atPoint: (NSPoint) point
{
    NSString *hanzi = [item hanzi];

    [hanzi drawAtPoint: point
        withAttributes: _hanAttributes];

    NSArray *pinyin = [item pinyin];

    float x = point.x;
    float y = point.y + _size + kPinyinHanziLeading;

    if (pinyin)
    {
        NSEnumerator *enumerator = [pinyin objectEnumerator];
        NSString *py;

        while (py = [enumerator nextObject])
        {
            // Center the pinyin
            float shift = (_advance - [py sizeWithAttributes: _pyAttributes].width) / 2;

            [py drawAtPoint: NSMakePoint(x + shift, y)
             withAttributes: _pyAttributes];

            x += _advance;
        }
    }

    return x;
}

- (void) drawRect: (NSRect) rect
{
    [[NSColor blackColor] set];
    NSRectFill(rect);

    NSEnumerator *enumerator = [_items objectEnumerator];
    PYMarkerItem *item;

    NSPoint p = NSMakePoint(kPinyinViewBorder,
                            kPinyinViewBorder);

    while (item = [enumerator nextObject])
        if ([item type] == 1)
            p.x = [self drawItem: item atPoint: p] + kMarkerItemInterspacing;
}

- (void) appendMarkerItem: (PYMarkerItem *) item
{
    [_items addObject: item];
}

- (void) clearMarkerItems
{
    [_items removeAllObjects];
}

- (void) dealloc
{
    [_items release];
    [_hanAttributes release];
    [_pyAttributes release];
    
    [super dealloc];
}

@end
