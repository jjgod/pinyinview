// PYView.h: Public Interface for PinyinView

#import <Cocoa/Cocoa.h>

#define kPinyinFontSize 20.0

@interface PYMarkerItem : NSObject
{
    NSString *_han;
    NSArray	 *_py;
    int	      _type;
}

- (NSString *) hanzi;
- (NSArray *) pinyin;
- (int) type;

- (id) initWithHanzi: (NSString *) hanzi
              pinyin: (NSArray *) pinyin
                type: (int) type;

@end

@interface PYView : NSView
{
    PYMarkerItem *_item;
    NSDictionary *_hanAttributes;
    NSDictionary *_pyAttributes;
    float         _size;
}

- (void) setMarkerItem: (PYMarkerItem *) item;
- (id) initWithFrame: (NSRect) frameRect
            fontName: (NSString *) name
                size: (float) size
                color: (NSColor *) color;

@end
