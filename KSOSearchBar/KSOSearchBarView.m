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
#import "NSBundle+KSOSearchBarPrivateExtensions.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>

static NSString *const kCloseButtonString = @"\uf057";
static CGFloat const kSubviewMargin = 8.0;
#if (TARGET_OS_IOS)
static CGSize const kIconSize = {.width=16.0, .height=16.0};
#endif

@interface KSOSearchBarView () <UITextFieldDelegate>
@property (strong,nonatomic) UILabel *promptLabel;
@property (strong,nonatomic) KDITextField *textField;
@property (strong,nonatomic) UILabel *placeholderLabel;
@property (strong,nonatomic) UIImageView *searchImageView;
@property (strong,nonatomic) UIButton *clearButton;
@property (strong,nonatomic) UIButton *cancelButton;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;

- (void)_KSOSearchBarViewInit;
- (CGSize)_sizeThatFits:(CGSize)size layout:(BOOL)layout;
- (void)_updatePromptLabel;
- (void)_updatePlaceholderLabel;
- (void)_updateClearButton;
+ (UIColor *)_defaultPromptTextColor;
+ (UIColor *)_defaultTextColor;
+ (UIColor *)_defaultPlaceholderTextColor;
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

- (id)forwardingTargetForSelector:(SEL)aSelector {
    // to handle the UITextInputTraits methods
    if ([self.textField respondsToSelector:aSelector]) {
        return self.textField;
    }
    return nil;
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
#pragma mark UIFocusEnvironment
- (NSArray<id<UIFocusEnvironment>> *)preferredFocusEnvironments {
    NSMutableArray *retval = [NSMutableArray arrayWithObjects:self.textField, nil];
    
    if (self.showsScopeBar) {
        [retval addObject:self.segmentedControl];
    }
    
    return retval;
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarViewShouldBeginEditing:)]) {
        return [self.delegate searchBarViewShouldBeginEditing:self];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarViewDidBeginEditing:)]) {
        [self.delegate searchBarViewDidBeginEditing:self];
    }
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
        [self _updatePlaceholderLabel];
        [self.cancelButton setEnabled:YES];
    } completion:nil];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarViewShouldEndEditing:)]) {
        return [self.delegate searchBarViewShouldEndEditing:self];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if ([self.delegate respondsToSelector:@selector(searchBarViewDidEndEditing:)]) {
        [self.delegate searchBarViewDidEndEditing:self];
    }
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
        [self _updatePlaceholderLabel];
        [self.cancelButton setEnabled:NO];
    } completion:nil];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(searchBarView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate searchBarView:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
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
- (void)setPromptTextColor:(UIColor *)promptTextColor {
    _promptTextColor = promptTextColor ?: [self.class _defaultPromptTextColor];
    
    [self _updatePromptLabel];
}
@dynamic text;
- (NSString *)text {
    return self.textField.text;
}
- (void)setText:(NSString *)text {
    [self.textField setText:text];
    
    [self _updatePlaceholderLabel];
    [self _updateClearButton];
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor ?: [self.class _defaultTextColor];
    
    [self.textField setTextColor:_textColor];
}
@dynamic placeholder;
- (NSString *)placeholder {
#if (TARGET_OS_IOS)
    return self.placeholderLabel.text;
#else
    return self.textField.placeholder;
#endif
}
- (void)setPlaceholder:(NSString *)placeholder {
#if (TARGET_OS_IOS)
    BOOL placeholderWasVisible = self.placeholder.length > 0;
    
    [self.placeholderLabel setText:placeholder];
    
    if (placeholder.length > 0 && !placeholderWasVisible) {
        [self addSubview:self.placeholderLabel];
        [self setNeedsLayout];
    }
    else if (placeholder.length == 0 && placeholderWasVisible) {
        [self.placeholderLabel removeFromSuperview];
        [self setNeedsLayout];
    }
#else
    [self.textField setPlaceholder:placeholder];
#endif
}
- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = placeholderTextColor ?: [self.class _defaultPlaceholderTextColor];
    
    [self.placeholderLabel setTextColor:_placeholderTextColor];
}
- (void)setShowsScopeBar:(BOOL)showsScopeBar {
    if (_showsScopeBar == showsScopeBar) {
        return;
    }
    
    _showsScopeBar = showsScopeBar;
    
    if (_showsScopeBar) {
        [self addSubview:self.segmentedControl];
        [self.segmentedControl removeAllSegments];
        [self.segmentedControl insertSegmentWithTitle:@"Title" atIndex:0 animated:NO];
        [self.segmentedControl insertSegmentWithTitle:@"Title" atIndex:1 animated:NO];
        [self.segmentedControl setSelectedSegmentIndex:0];
        [self setNeedsLayout];
        [self invalidateIntrinsicContentSize];
    }
    else {
        [self.segmentedControl removeFromSuperview];
        [self setNeedsLayout];
        [self invalidateIntrinsicContentSize];
    }
}
@dynamic selectedScopeBarIndex;
- (NSInteger)selectedScopeBarIndex {
    return self.segmentedControl.selectedSegmentIndex;
}
- (void)setSelectedScopeBarIndex:(NSInteger)selectedScopeBarIndex {
    [self.segmentedControl setSelectedSegmentIndex:selectedScopeBarIndex];
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
- (void)setShowsCancelButton:(BOOL)showsCancelButton {
    if (_showsCancelButton == showsCancelButton) {
        return;
    }
    
    _showsCancelButton = showsCancelButton;
    
    if (_showsCancelButton) {
        [self addSubview:self.cancelButton];
        [self setNeedsLayout];
    }
    else {
        [self.cancelButton removeFromSuperview];
        [self setNeedsLayout];
    }
}
- (void)setInputAccessoryView:(__kindof UIView *)inputAccessoryView {
    [self.textField setInputAccessoryView:inputAccessoryView];
}
#pragma mark *** Private Methods ***
- (void)_KSOSearchBarViewInit; {
#if (TARGET_OS_IOS)
    // sampled from UISearchBar
    [self setBackgroundColor:KDIColorHexadecimal(@"c9c9ce")];
#endif
    
    _promptTextColor = [self.class _defaultPromptTextColor];
    _textColor = [self.class _defaultTextColor];
    _placeholderTextColor = [self.class _defaultPlaceholderTextColor];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
#if (TARGET_OS_IOS)
    _searchImageView = [[UIImageView alloc] initWithImage:[UIImage KSO_fontAwesomeImageWithIcon:KSOFontAwesomeIconSearch foregroundColor:_placeholderTextColor size:kIconSize]];
    [self addSubview:_searchImageView];
#endif
    
    _textField = [[KDITextField alloc] initWithFrame:CGRectZero];
    [_textField setAdjustsFontForContentSizeCategory:YES];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
#if (TARGET_OS_IOS)
    [_textField setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [_textField setTextEdgeInsets:UIEdgeInsetsMake(0, kSubviewMargin + CGRectGetWidth(_searchImageView.frame) + kSubviewMargin, 0, kSubviewMargin)];
#else
    [_textField setTextEdgeInsets:UIEdgeInsetsMake(kSubviewMargin, kSubviewMargin, kSubviewMargin, kSubviewMargin)];
#endif
    [_textField setTextColor:_textColor];
    [_textField setDelegate:self];
    [_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_textField setEnablesReturnKeyAutomatically:YES];
    [_textField setReturnKeyType:UIReturnKeySearch];
    [_textField setSpellCheckingType:UITextSpellCheckingTypeNo];
    kstWeakify(self);
    [_textField KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self _updatePlaceholderLabel];
        [self _updateClearButton];
        
        if ([self.delegate respondsToSelector:@selector(searchBarView:didChangeText:)]) {
            [self.delegate searchBarView:self didChangeText:self.text];
        }
    } forControlEvents:UIControlEventEditingChanged];
    [self insertSubview:_textField atIndex:0];
    
#if (TARGET_OS_IOS)
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_placeholderLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [_placeholderLabel setTextColor:_placeholderTextColor];
#endif
    
#if (TARGET_OS_IOS)
    _clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_clearButton setImage:[UIImage KSO_fontAwesomeImageWithString:kCloseButtonString foregroundColor:_placeholderTextColor size:kIconSize] forState:UIControlStateNormal];
    [_clearButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        if ([self.delegate respondsToSelector:@selector(searchBarViewDidTapClearButton:)]) {
            [self.delegate searchBarViewDidTapClearButton:self];
        }
        BOOL shouldChangeText = YES;
        if ([self.delegate respondsToSelector:@selector(searchBarView:shouldChangeTextInRange:replacementText:)]) {
            shouldChangeText = [self.delegate searchBarView:self shouldChangeTextInRange:NSMakeRange(0, self.text.length) replacementText:nil];
        }
        if (shouldChangeText) {
            [self setText:nil];
            if ([self.delegate respondsToSelector:@selector(searchBarView:didChangeText:)]) {
                [self.delegate searchBarView:self didChangeText:self.text];
            }
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [_clearButton sizeToFit];
    [_textField setRightView:_clearButton];
    [_textField setRightViewMode:UITextFieldViewModeAlways];
    [_textField setRightViewEdgeInsets:UIEdgeInsetsMake(0, kSubviewMargin, 0, kSubviewMargin)];
#endif
    
#if (TARGET_OS_IOS)
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cancelButton setEnabled:NO];
    [_cancelButton.titleLabel setAdjustsFontForContentSizeCategory:YES];
    [_cancelButton.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [_cancelButton setTitle:NSLocalizedStringWithDefaultValue(@"CANCEL_BUTTON_TITLE", nil, [NSBundle KSO_searchBarFrameworkBundle], @"Cancel", @"cancel button title") forState:UIControlStateNormal];
    [_cancelButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        if ([self.delegate respondsToSelector:@selector(searchBarViewDidTapCancelButton:)]) {
            [self.delegate searchBarViewDidTapCancelButton:self];
        }
        [self resignFirstResponder];
    } forControlEvents:UIControlEventTouchUpInside];
#endif
    
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    [_segmentedControl KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        if ([self.delegate respondsToSelector:@selector(searchBarView:didChangeSelectedScopeBarIndex:)]) {
            [self.delegate searchBarView:self didChangeSelectedScopeBarIndex:self.segmentedControl.selectedSegmentIndex];
        }
    } forControlEvents:UIControlEventValueChanged];
    
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
        CGFloat frameY = kSubviewMargin;
        
        if (self.prompt.length > 0) {
            [self.promptLabel setFrame:CGRectMake(kSubviewMargin, frameY, CGRectGetWidth(self.bounds) - kSubviewMargin - kSubviewMargin, [self.promptLabel sizeThatFits:CGSizeZero].height)];
            
            frameY = CGRectGetMaxY(self.promptLabel.frame) + kSubviewMargin;
        }
#if (TARGET_OS_IOS)
        if (self.showsCancelButton) {
            CGSize cancelButtonSize = [self.cancelButton sizeThatFits:CGSizeZero];
            
            [self.cancelButton setFrame:CGRectMake(CGRectGetWidth(self.bounds) - cancelButtonSize.width - kSubviewMargin, frameY, cancelButtonSize.width, cancelButtonSize.height)];
        }
        
        [self.textField setFrame:CGRectMake(kSubviewMargin, frameY, self.showsCancelButton ? CGRectGetMinX(self.cancelButton.frame) - kSubviewMargin - kSubviewMargin : CGRectGetWidth(self.bounds) - kSubviewMargin - kSubviewMargin, [self.textField sizeThatFits:CGSizeZero].height)];
#else
        CGSize textFieldSize = [self.textField sizeThatFits:CGSizeZero];
        
        [self.textField setFrame:KSTCGRectCenterInRectHorizontally(CGRectMake(0, frameY, ceil(CGRectGetWidth(self.bounds) * 0.3), textFieldSize.height), self.bounds)];
#endif
        
        frameY = CGRectGetMaxY(self.textField.frame) + kSubviewMargin;
        
#if (TARGET_OS_IOS)
        if (self.isFirstResponder ||
            self.text.length > 0) {
            
            [self.searchImageView setFrame:KSTCGRectCenterInRectVertically(CGRectMake(CGRectGetMinX(self.textField.frame) + kSubviewMargin, 0, CGRectGetWidth(self.searchImageView.frame), CGRectGetHeight(self.searchImageView.frame)), self.textField.frame)];
            
            if (self.placeholder.length > 0) {
                CGSize placeholderSize = [self.placeholderLabel sizeThatFits:CGSizeZero];
                
                [self.placeholderLabel setFrame:KSTCGRectCenterInRectVertically(CGRectMake(CGRectGetMaxX(self.searchImageView.frame) + kSubviewMargin, 0, placeholderSize.width, placeholderSize.height), self.textField.frame)];
            }
        }
        else {
            if (self.placeholder.length > 0) {
                CGSize placeholderSize = [self.placeholderLabel sizeThatFits:CGSizeZero];
                CGRect rect = KSTCGRectCenterInRect(CGRectMake(0, 0, CGRectGetWidth(self.searchImageView.frame) + kSubviewMargin + placeholderSize.width, MAX(CGRectGetHeight(self.searchImageView.frame), placeholderSize.height)), self.textField.frame);
                
                [self.searchImageView setFrame:KSTCGRectCenterInRectVertically(CGRectMake(CGRectGetMinX(rect), 0, CGRectGetWidth(self.searchImageView.frame), CGRectGetHeight(self.searchImageView.frame)), rect)];
                [self.placeholderLabel setFrame:KSTCGRectCenterInRectVertically(CGRectMake(CGRectGetMaxX(self.searchImageView.frame) + kSubviewMargin, 0, placeholderSize.width, placeholderSize.height), rect)];
            }
            else {
                [self.searchImageView setFrame:KSTCGRectCenterInRect(self.searchImageView.frame, self.textField.frame)];
            }
        }
#endif
        
        if (self.showsScopeBar) {
            [self.segmentedControl setFrame:CGRectMake(kSubviewMargin, frameY, CGRectGetWidth(self.bounds) - kSubviewMargin - kSubviewMargin, [self.segmentedControl sizeThatFits:CGSizeZero].height)];
        }
    }
    
    return retval;
}
- (void)_updatePromptLabel; {
    if (self.prompt.length > 0) {
        [self.promptLabel setAttributedText:[[NSAttributedString alloc] initWithString:self.prompt attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName: self.promptTextColor, NSTextEffectAttributeName: NSTextEffectLetterpressStyle, NSParagraphStyleAttributeName: [NSParagraphStyle KDI_paragraphStyleWithCenterTextAlignment]}]];
    }
}
- (void)_updatePlaceholderLabel; {
    [self.placeholderLabel setAlpha:self.text.length > 0 ? 0.0 : 1.0];
}
- (void)_updateClearButton; {
    [self.clearButton setAlpha:self.text.length > 0 ? 1.0 : 0.0];
}

+ (UIColor *)_defaultPromptTextColor; {
    return UIColor.darkGrayColor;
}
+ (UIColor *)_defaultTextColor; {
    return UIColor.blackColor;
}
+ (UIColor *)_defaultPlaceholderTextColor; {
    return UIColor.grayColor;
}
#pragma mark Notifications
- (void)_contentSizeCategoryDidChange:(NSNotification *)note {
    [self _updatePromptLabel];
    
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

@end
