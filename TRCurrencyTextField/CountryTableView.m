//  CountryTableView.m
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

#import "CountryTableView.h"

@implementation CountryTableView

@synthesize countryCodeList = _countryCodeList;
@synthesize delegate = _delegate;

NSArray *_currentCountryCodes;
NSUInteger _selectedCountry;

#pragma mark - Superclass methods

-(id)initWithCountryCodes:(NSArray *)countryCodes andDelegate:(id<LocaleTableViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Country";
        
        _countryCodeList = [NSMutableArray new];
        
        NSArray *countryCodeList = [NSLocale ISOCountryCodes];
        for (NSString *countryCodeItem in countryCodeList) {
            NSNumberFormatter *formatter = [[FormatterHelper sharedInstance] currencyFormatterForCountryCode:countryCodeItem];
            if (formatter != nil) {
                [_countryCodeList addObject:countryCodeItem];
            }
        }
        
        _currentCountryCodes = countryCodes;
        
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath;
    
    if (_selectedCountry) {
        indexPath = [NSIndexPath indexPathForRow:_selectedCountry inSection:0];
    } else {
        NSUInteger index = [_countryCodeList indexOfObject:[_currentCountryCodes firstObject]];
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
    return self.countryCodeList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedCountryCode = self.countryCodeList[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *locales = [[LocaleHelper sharedInstance] allLocalesForCountryCode:selectedCountryCode];
    
    if ([locales count] > 1) {
        _selectedCountry = indexPath.row;
        
        LocaleTableView *localeView = [[LocaleTableView alloc] initWithCountryCode:selectedCountryCode andDelegate:self.delegate];
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
    
    NSString *countryCode = self.countryCodeList[indexPath.row];
    NSString *countryName = [[[LocaleHelper sharedInstance] localeForCountryCode:countryCode] displayNameForKey:NSLocaleCountryCode value:countryCode];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", countryCode, countryName];
    
    if([_currentCountryCodes containsObject:countryCode]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


@end
