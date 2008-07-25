PinyinView
==========

PinyinView (PYView) is an Objective-C class for Cocoa framework
to display annotated Pinyin text above Chinese characters (Hanzi).


Usage
-----

Basically, PYView can be embeded into your app like this:

    #include "PYView.h"

    NSRect viewRect = NSMakeRect(50, 250, 700, 80);
    view = [[PYView alloc] initWithFrame: viewRect
                                fontName: @"FZKai-Z03"
                                   color: [NSColor whiteColor]];

    NSArray *pinyin1 = [NSArray arrayWithObjects: @"nǐ", @"hǎo", nil];
    NSArray *pinyin2 = [NSArray arrayWithObjects: @"zhōng", @"huá",
                        @"rén", @"mín", @"gòng", @"hé", @"guó", nil];


    [view appendMarkerItem: [PYMarkerItem itemWithHanzi: @"你好"
                                                 pinyin: pinyin1
                                                   type: 1]];
    [view appendMarkerItem: [PYMarkerItem itemWithHanzi: @"中华人民共和国"
                                                 pinyin: pinyin2
                                                   type: 1]];

For more details, check the PYViewTest project.

Contact
-------

Bugs, feature requests & advices, please send to gzjjgod@gmail.com.

