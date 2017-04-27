//
//  KSOSearchBarView.m
//  KSOSearchBar
//
//  Created by William Towe on 4/27/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOSearchBarView.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>

static CGFloat const kSubviewMargin = 8.0;

@interface KSOSearchBarView ()
@property (strong,nonatomic) UILabel *promptLabel;
@property (strong,nonatomic) KDITextField *textField;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;

- (void)_KSOSearchBarViewInit;
- (CGSize)_sizeThatFits:(CGSize)size layout:(BOOL)layout;
- (void)_updatePromptLabel;
+ (UIColor *)_defaultPromptTextColor;
@end

@implementation KSOSearchBarView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _KSOSearchBarViewInit];
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _KSOSearchBarViewInit];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _sizeThatFits:self.bounds.size layout:YES];
}

- (CGSize)intrinsicContentSize {
    return [self _sizeThatFits:CGSizeZero layout:NO];
}
- (CGSize)sizeThatFits:(CGSize)size {
    return [self _sizeThatFits:size layout:NO];
}

- (void)setPrompt:(NSString *)prompt {
    BOOL promptWasVisible = self.prompt.length > 0;
    
    _prompt = [prompt copy];
    
    [self _updatePromptLabel];
    
    if (prompt.length > 0 && !promptWasVisible) {
        [self addSubview:self.promptLabel];
        [self setNeedsLayout];
        [self invalidateIntrinsicContentSize];
    }
    else if (prompt.length == 0 && promptWasVisible) {
        [self.promptLabel removeFromSuperview];
        [self setNeedsLayout];
        [self invalidateIntrinsicContentSize];
    }
}
- (void)setPromptTextColor:(UIColor *)promptTextColor {
    _promptTextColor = promptTextColor ?: [self.class _defaultPromptTextColor];
    
    [self _updatePromptLabel];
}
- (void)setShowsScopeBar:(BOOL)showsScopeBar {
    if (_showsScopeBar == showsScopeBar) {
        return;
    }
    
    _showsScopeBar = showsScopeBar;
    
    if (_showsScopeBar) {
        [self addSubview:self.segmentedControl];
        [self setNeedsLayout];
        [self invalidateIntrinsicContentSize];
    }
    else {
        [self.segmentedControl removeFromSuperview];
        [self setNeedsLayout];
        [self invalidateIntrinsicContentSize];
    }
}
- (void)setScopeBarItems:(NSArray *)scopeBarItems {
    _scopeBarItems = [scopeBarItems copy];
    
    [self.segmentedControl removeAllSegments];
    
    if ([_scopeBarItems.firstObject isKindOfClass:[NSString class]]) {
        for (NSInteger i=0; i<_scopeBarItems.count; i++) {
            [self.segmentedControl insertSegmentWithTitle:_scopeBarItems[i] atIndex:i animated:NO];
        }
    }
    else {
        for (NSInteger i=0; i<_scopeBarItems.count; i++) {
            [self.segmentedControl insertSegmentWithImage:_scopeBarItems[i] atIndex:i animated:NO];
        }
    }
    
    [self.segmentedControl setSelectedSegmentIndex:0];
}

- (void)_KSOSearchBarViewInit; {
    [self setBackgroundColor:KDIColorHexadecimal(@"c9c9ce")];
    
    _promptTextColor = [self.class _defaultPromptTextColor];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _textField = [[KDITextField alloc] initWithFrame:CGRectZero];
    [_textField setAdjustsFontForContentSizeCategory:YES];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [_textField setTextEdgeInsets:UIEdgeInsetsMake(0, kSubviewMargin, 0, kSubviewMargin)];
    [self addSubview:_textField];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_contentSizeCategoryDidChange:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}
- (CGSize)_sizeThatFits:(CGSize)size layout:(BOOL)layout; {
    CGSize retval = CGSizeZero;
 
    if (self.prompt.length > 0) {
        retval.height += kSubviewMargin;
        retval.height += [self.promptLabel sizeThatFits:CGSizeZero].height;
    }
    
    retval.height += kSubviewMargin;
    retval.height += [self.textField sizeThatFits:CGSizeZero].height;
    retval.height += kSubviewMargin;
    
    if (self.showsScopeBar) {
        retval.height += [self.segmentedControl sizeThatFits:CGSizeZero].height;
        retval.height += kSubviewMargin;
    }
    
    if (layout) {
        if (self.prompt.length > 0) {
            [self.promptLabel setFrame:CGRectMake(kSubviewMargin, kSubviewMargin, CGRectGetWidth(self.bounds) - kSubviewMargin - kSubviewMargin, [self.promptLabel sizeThatFits:CGSizeZero].height)];
        }
        
        if (self.prompt.length > 0) {
            [self.textField setFrame:CGRectMake(kSubviewMargin, CGRectGetMaxY(self.promptLabel.frame) + kSubviewMargin, CGRectGetWidth(self.bounds) - kSubviewMargin - kSubviewMargin, [self.textField sizeThatFits:CGSizeZero].height)];
        }
        else {
            [self.textField setFrame:CGRectMake(kSubviewMargin, kSubviewMargin, CGRectGetWidth(self.bounds) - kSubviewMargin - kSubviewMargin, [self.textField sizeThatFits:CGSizeZero].height)];
        }
        
        if (self.showsScopeBar) {
            [self.segmentedControl setFrame:CGRectMake(kSubviewMargin, CGRectGetMaxY(self.textField.frame) + kSubviewMargin, CGRectGetWidth(self.bounds) - kSubviewMargin - kSubviewMargin, [self.segmentedControl sizeThatFits:CGSizeZero].height)];
        }
    }
    
    return retval;
}
- (void)_updatePromptLabel; {
    if (self.prompt.length > 0) {
        [self.promptLabel setAttributedText:[[NSAttributedString alloc] initWithString:self.prompt attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName: self.promptTextColor, NSTextEffectAttributeName: NSTextEffectLetterpressStyle, NSParagraphStyleAttributeName: [NSParagraphStyle KDI_paragraphStyleWithCenterTextAlignment]}]];
    }
}

+ (UIColor *)_defaultPromptTextColor; {
    return UIColor.darkGrayColor;
}

- (void)_contentSizeCategoryDidChange:(NSNotification *)note {
    [self _updatePromptLabel];
    
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

@end
