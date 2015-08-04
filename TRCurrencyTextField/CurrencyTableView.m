//  CurrencyTableView.m
//  Thiago Rossener ( https://github.com/thiagoross/TRCurrencyTextField )
//
//  Copyright (c) 2015 Rossener ( http://www.rossener.com/ )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CurrencyTableView.h"

@implementation CurrencyTableView

@synthesize currencyFormatterList = _currencyFormatterList;
@synthesize delegate = _delegate;

NSNumberFormatter *_currentCurrencyFormatter;
NSArray *_localeOptions;
NSUInteger _selectedCurrency;

#pragma mark - Superclass methods

- (id)initWithCurrencyCode:(NSString *)currencyCode andDelegate:(id<LocaleTableViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Currency";
        
        _currencyFormatterList = [NSMutableArray new];
        
        NSArray *currencyCodeList = [NSLocale ISOCurrencyCodes];
        for (NSString *currencyCodeItem in currencyCodeList) {
            NSNumberFormatter *formatter = [[FormatterHelper sharedInstance] currencyFormatterForCurrencyCode:currencyCodeItem];
            if (formatter != nil) {
                if ([formatter.currencyCode isEqual:currencyCode]) {
                    _currentCurrencyFormatter = formatter;
                }
                
                [_currencyFormatterList addObject:formatter];
            }
        }
        
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath;
    
    if (_selectedCurrency) {
        indexPath = [NSIndexPath indexPathForRow:_selectedCurrency inSection:0];
    } else {
        NSUInteger index = [_currencyFormatterList indexOfObject:_currentCurrencyFormatter];
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    }

    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currencyFormatterList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumberFormatter *selectedCurrencyFormatter = self.currencyFormatterList[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSArray *locales = [[LocaleHelper sharedInstance] allLocalesForCurrencyCode:selectedCurrencyFormatter.currencyCode];
    
    if ([locales count] > 1) {
        _selectedCurrency = indexPath.row;
        
        LocaleTableView *localeView = [[LocaleTableView alloc] initWithCurrencyCode:selectedCurrencyFormatter.currencyCode andDelegate:self.delegate];
        [self.navigationController pushViewController:localeView animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        if (_delegate) {
            [_delegate selectedLocale:[locales firstObject]];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *currencyCode = [self.currencyFormatterList[indexPath.row] currencyCode];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", currencyCode];
    
    if([_currentCurrencyFormatter isEqual:_currencyFormatterList[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    
        if (_delegate) {
            [_delegate selectedLocale:[_localeOptions objectAtIndex:buttonIndex-1]];
        }
    }
}

@end
