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

@interface KSOSearchBarView : UIView

@property (weak,nonatomic,nullable) id<KSOSearchBarViewDelegate> delegate;

@property (copy,nonatomic,nullable) NSString *prompt;
@property (strong,nonatomic,null_resettable) UIColor *promptTextColor UI_APPEARANCE_SELECTOR;
@property (copy,nonatomic,nullable) NSString *text;
@property (copy,nonatomic,nullable) NSString *placeholder;
@property (assign,nonatomic) BOOL showsScopeBar;
@property (copy,nonatomic) NSArray *scopeBarItems;
@property (assign,nonatomic) BOOL showsCancelButton;

@end

@protocol KSOSearchBarViewDelegate <NSObject>
@optional
- (BOOL)searchBarViewShouldBeginEditing:(KSOSearchBarView *)searchBarView;
- (void)searchBarViewDidBeginEditing:(KSOSearchBarView *)searchBarView;
- (BOOL)searchBarViewShouldEndEditing:(KSOSearchBarView *)searchBarView;
- (void)searchBarViewDidEndEditing:(KSOSearchBarView *)searchBarView;
- (BOOL)searchBarView:(KSOSearchBarView *)searchBarView shouldChangeTextInRange:(NSRange)range replacementText:(nullable NSString *)text;
- (void)searchBarView:(KSOSearchBarView *)searchBarView didChangeText:(nullable NSString *)text;

- (void)searchBarViewDidTapCancelButton:(KSOSearchBarView *)searchBarView;
- (void)searchBarViewDidTapClearButton:(KSOSearchBarView *)searchBarView;

- (void)searchBarView:(KSOSearchBarView *)searchBarView didChangeSelectedScopeBarIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
