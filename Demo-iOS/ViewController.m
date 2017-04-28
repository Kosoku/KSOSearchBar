//
//  ViewController.m
//  Demo-iOS
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

#import "ViewController.h"

#import <KSOSearchBar/KSOSearchBar.h>
#import <Stanley/Stanley.h>

@interface ViewController () <KSOSearchBarViewDelegate,UISearchBarDelegate>
@property (weak,nonatomic) IBOutlet KSOSearchBarView *searchBarView;
@property (weak,nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBarView setDelegate:self];
    [self.searchBarView setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.searchBar setDelegate:self];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchBarView becomeFirstResponder];
    });
}

- (BOOL)searchBarViewShouldBeginEditing:(KSOSearchBarView *)searchBarView; {
    KSTLogObject(searchBarView);
    return YES;
}
- (void)searchBarViewDidBeginEditing:(KSOSearchBarView *)searchBarView {
    KSTLogObject(searchBarView);
}
- (BOOL)searchBarViewShouldEndEditing:(KSOSearchBarView *)searchBarView {
    KSTLogObject(searchBarView);
    return YES;
}
- (void)searchBarViewDidEndEditing:(KSOSearchBarView *)searchBarView {
    KSTLogObject(searchBarView);
}
- (BOOL)searchBarView:(KSOSearchBarView *)searchBarView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    KSTLog(@"searchBarView=%@ range=%@ text=%@",searchBarView,NSStringFromRange(range),text);
    return YES;
}
- (void)searchBarView:(KSOSearchBarView *)searchBarView didChangeText:(NSString *)text {
    KSTLog(@"searchBarView=%@ text=%@",searchBarView,text);
}
- (void)searchBarViewDidTapCancelButton:(KSOSearchBarView *)searchBarView {
    KSTLogObject(searchBarView);
}
- (void)searchBarViewDidTapClearButton:(KSOSearchBarView *)searchBarView {
    KSTLogObject(searchBarView);
}
- (void)searchBarView:(KSOSearchBarView *)searchBarView didChangeSelectedScopeBarIndex:(NSInteger)index {
    KSTLog(@"searchBarView=%@ index=%@",searchBarView,@(index));
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    KSTLog(@"searchBar=%@ range=%@ text=%@",searchBar,NSStringFromRange(range),text);
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    KSTLog(@"searchBar=%@ text=%@",searchBar,searchText);
}

- (IBAction)_showsCancelButton:(UISwitch *)sender {
    [self.searchBarView setShowsCancelButton:sender.isOn];
    [self.searchBar setShowsCancelButton:sender.isOn];
}
- (IBAction)_showsScopeBar:(UISwitch *)sender {
    [self.searchBarView setShowsScopeBar:sender.isOn];
    [self.searchBar setShowsScopeBar:sender.isOn];
}
- (IBAction)_promptAction:(UITextField *)sender {
    [self.searchBarView setPrompt:[NSString stringWithFormat:@"%@: %@",NSStringFromClass(self.searchBarView.class),sender.text]];
    [self.searchBar setPrompt:[NSString stringWithFormat:@"%@: %@",NSStringFromClass(self.searchBar.class),sender.text]];
}
- (IBAction)_placeholderAction:(UITextField *)sender {
    [self.searchBarView setPlaceholder:[NSString stringWithFormat:@"%@: %@",NSStringFromClass(self.searchBarView.class),sender.text]];
    [self.searchBar setPlaceholder:[NSString stringWithFormat:@"%@: %@",NSStringFromClass(self.searchBar.class),sender.text]];
}

@end
