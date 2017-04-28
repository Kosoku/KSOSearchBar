//
//  ViewController.m
//  Demo-tvOS
//
//  Created by William Towe on 4/28/17.
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

@interface ViewController () <KSOSearchBarViewDelegate>
@property (strong,nonatomic) KSOSearchBarView *searchBarView;
@property (strong,nonatomic) UISearchController *searchController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *items = @[@"First",@"Second",@"Third",@"Fourth"];
    
    [self setSearchBarView:[[KSOSearchBarView alloc] initWithFrame:CGRectZero]];
    [self.searchBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.searchBarView setDelegate:self];
    [self.searchBarView setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.searchBarView setPrompt:@"Prompt"];
    [self.searchBarView setPlaceholder:@"Placeholder"];
    [self.searchBarView setShowsScopeBar:YES];
    [self.searchBarView setScopeBarItems:items];
    [self.view addSubview:self.searchBarView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.searchBarView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:@{@"view": self.searchBarView}]];
    
    [self setSearchController:[[UISearchController alloc] initWithSearchResultsController:[[UIViewController alloc] init]]];
    [self.searchController.searchBar setPrompt:@"Prompt"];
    [self.searchController.searchBar setPlaceholder:@"Placeholder"];
    [self.searchController.searchBar setReturnKeyType:UIReturnKeySearch];
    [self.searchController.searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.searchController.searchBar];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": self.searchController.searchBar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview]-[view]" options:0 metrics:nil views:@{@"view": self.searchController.searchBar, @"subview": self.searchBarView}]];
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

@end
