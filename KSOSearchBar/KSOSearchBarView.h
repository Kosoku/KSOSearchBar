//
//  KSOSearchBarView.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KSOSearchBarViewDelegate;

/**
 `KSOSearchBarView` is an alternative implementation of `UISearchBar`.
 */
@interface KSOSearchBarView : UIView <UITextInputTraits>

/**
 Set and get the delegate of the receiver.
 
 @see KSOSearchBarViewDelegate
 */
@property (weak,nonatomic,nullable) id<KSOSearchBarViewDelegate> delegate;

/**
 Set and get the prompt of the receiver. The prompt appears above the text field.
 */
@property (copy,nonatomic,nullable) NSString *prompt;
/**
 Set and get the text color of the prompt.
 
 The default is UIColor.grayColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *promptTextColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the text of the receiver. This is set as the text property of the managed UITextField.
 */
@property (copy,nonatomic,nullable) NSString *text;
/**
 Set and get the text color of the text. This is set as the textColor property of the managed UITextField.
 */
@property (strong,nonatomic,null_resettable) UIColor *textColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the placeholder of the receiver. The placeholder is displayed when the text property is nil.
 */
@property (copy,nonatomic,nullable) NSString *placeholder;
/**
 Set and get the text color of the placeholder, search icon and clear button. The search icon is displayed to left of the placeholder and the clear button is displayed on the right edge of the text field.
 */
@property (strong,nonatomic,null_resettable) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;
/**
 Set and get whether the receiver shows the scope bar. The scope bar is displayed below the text field.
 
 The default is NO;
 */
@property (assign,nonatomic) BOOL showsScopeBar;
/**
 Set and get the selected index of the scope bar.
 
 The default is 0.
 */
@property (assign,nonatomic) NSInteger selectedScopeBarIndex;
/**
 Set and get the scope bar items. The items can be either NSString or UIImage instances.
 
 The default is nil.
 */
@property (copy,nonatomic) NSArray *scopeBarItems;
/**
 Set and get whether the receiver shows the cancel button. The cancel button is displayed to the right of the text field.
 
 The default is NO.
 */
@property (assign,nonatomic) BOOL showsCancelButton __TVOS_PROHIBITED;

/**
 Set the inputAccessoryView on the UITextField managed by the receiver.
 */
- (void)setInputAccessoryView:(__kindof UIView * _Nullable)inputAccessoryView;

@end

/**
 Protocol describing the delegate of KSOSearchBarView instances.
 */
@protocol KSOSearchBarViewDelegate <NSObject>
@optional
/**
 Called to determine if the text field managed by the receiver should begin editing.
 
 @param searchBarView The sender of the message
 @return YES if the text field should begin editing, otherwise NO
 */
- (BOOL)searchBarViewShouldBeginEditing:(KSOSearchBarView *)searchBarView;
/**
 Called when the text field managed by the receiver begins editing.
 
 @param searchBarView The sender of the message
 */
- (void)searchBarViewDidBeginEditing:(KSOSearchBarView *)searchBarView;
/**
 Called to determine if the text field managed by the receiver should end editing.
 
 @param searchBarView The sender of the message
 @return YES if the text field should end editing, otherwise NO
 */
- (BOOL)searchBarViewShouldEndEditing:(KSOSearchBarView *)searchBarView;
/**
 Called when the text field managed by the receiver ends editing.
 
 @param searchBarView The sender of the message
 */
- (void)searchBarViewDidEndEditing:(KSOSearchBarView *)searchBarView;
/**
 Called to determine if the text field should change its text in the provided *range* to *text*.
 
 @param searchBarView The sender of the message
 @param range The range which is being edited
 @param text The replacement text
 @return YES if the replacement should be made, otherwise NO
 */
- (BOOL)searchBarView:(KSOSearchBarView *)searchBarView shouldChangeTextInRange:(NSRange)range replacementText:(nullable NSString *)text;
/**
 Called when the text of the text field changes.
 
 @param searchBarView The sender of the message
 @param text The text of the text field
 */
- (void)searchBarView:(KSOSearchBarView *)searchBarView didChangeText:(nullable NSString *)text;

/**
 Called when the cancel button is tapped.
 
 @param searchBarView The sender of the message
 */
- (void)searchBarViewDidTapCancelButton:(KSOSearchBarView *)searchBarView;
/**
 Called when the clear button is tapped.
 
 @param searchBarView The sender of the message
 */
- (void)searchBarViewDidTapClearButton:(KSOSearchBarView *)searchBarView;

/**
 Called when the scope bar selected index changes.
 
 @param searchBarView The sender of the message
 @param index The selected scope bar index
 */
- (void)searchBarView:(KSOSearchBarView *)searchBarView didChangeSelectedScopeBarIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
