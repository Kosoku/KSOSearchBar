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
static CGSize const kIconSize = {.width=16.0, .height=16.0};

@interface KSOSearchBarView () <UITextFieldDelegate>
@property (strong,nonatomic) UILabel *promptLabel;
@property (strong,nonatomic) KDITextField *textField;
@property (strong,nonatomic) UIImageView *searchImageView;
@property (strong,nonatomic) UIButton *clearButton;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;

- (void)_KSOSearchBarViewInit;
- (CGSize)_sizeThatFits:(CGSize)size layout:(BOOL)layout;
- (void)_updatePromptLabel;
- (void)_updateClearButton;
+ (UIColor *)_defaultPromptTextColor;
@end

@implementation KSOSearchBarView
#pragma mark *** Subclass Overrides ***
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

- (BOOL)canBecomeFirstResponder {
    return self.textField.canBecomeFirstResponder;
}
- (BOOL)isFirstResponder {
    return self.textField.isFirstResponder;
}
- (BOOL)becomeFirstResponder {
    BOOL retval = [self.textField becomeFirstResponder];
    
    if (retval) {
        
    }
    
    return retval;
}
- (BOOL)resignFirstResponder {
    BOOL retval = [self.textField resignFirstResponder];
    
    if (retval) {
        
    }
    
    return retval;
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
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setNeedsLayout];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    [self setNeedsLayout];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

#pragma mark *** Public Methods ***
#pragma mark Properties
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
@dynamic text;
- (NSString *)text {
    return self.textField.text;
}
- (void)setText:(NSString *)text {
    [self.textField setText:text];
    
    [self _updateClearButton];
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
#pragma mark *** Private Methods ***
- (void)_KSOSearchBarViewInit; {
    [self setBackgroundColor:KDIColorHexadecimal(@"c9c9ce")];
    
    _promptTextColor = [self.class _defaultPromptTextColor];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _searchImageView = [[UIImageView alloc] initWithImage:[UIImage KSO_fontAwesomeImageWithIcon:KSOFontAwesomeIconSearch foregroundColor:UIColor.grayColor size:kIconSize]];
    [self addSubview:_searchImageView];
    
    _textField = [[KDITextField alloc] initWithFrame:CGRectZero];
    [_textField setAdjustsFontForContentSizeCategory:YES];
    [_textField setReturnKeyType:UIReturnKeySearch];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [_textField setDelegate:self];
    [_textField setTextEdgeInsets:UIEdgeInsetsMake(0, kSubviewMargin + CGRectGetWidth(_searchImageView.frame) + kSubviewMargin, 0, kSubviewMargin)];
    kstWeakify(self);
    [_textField KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self _updateClearButton];
    } forControlEvents:UIControlEventEditingChanged];
    [self insertSubview:_textField belowSubview:_searchImageView];
    
    _clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_clearButton setImage:[UIImage KSO_fontAwesomeImageWithString:@"\uf057" foregroundColor:UIColor.grayColor size:kIconSize] forState:UIControlStateNormal];
    [_clearButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self setText:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [_clearButton sizeToFit];
    [_textField setRightView:_clearButton];
    [_textField setRightViewMode:UITextFieldViewModeAlways];
    [_textField setRightViewEdgeInsets:UIEdgeInsetsMake(0, kSubviewMargin, 0, kSubviewMargin)];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    
    [self _updateClearButton];
    
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
        
        if (self.isFirstResponder) {
            [self.searchImageView setFrame:KSTCGRectCenterInRectVertically(CGRectMake(CGRectGetMinX(self.textField.frame) + kSubviewMargin, 0, CGRectGetWidth(self.searchImageView.frame), CGRectGetHeight(self.searchImageView.frame)), self.textField.frame)];
        }
        else {
            [self.searchImageView setFrame:KSTCGRectCenterInRect(self.searchImageView.frame, self.textField.frame)];
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
- (void)_updateClearButton; {
    [self.clearButton setAlpha:self.text.length > 0 ? 1.0 : 0.0];
}

+ (UIColor *)_defaultPromptTextColor; {
    return UIColor.darkGrayColor;
}
#pragma mark Notifications
- (void)_contentSizeCategoryDidChange:(NSNotification *)note {
    [self _updatePromptLabel];
    
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

@end
