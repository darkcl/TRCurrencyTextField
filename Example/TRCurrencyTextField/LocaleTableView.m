//  LocaleTableView.m
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

#import "LocaleTableView.h"

@implementation LocaleTableView

@synthesize delegate = _delegate;

NSArray *_locales;

NSString *_currencyCode;
NSString *_countryCode;

#pragma mark - Superclass methods

- (id)initWithCurrencyCode:(NSString *)currencyCode andDelegate:(id<LocaleTableViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Locale";
        
        _locales = [[TRLocaleHelper sharedInstance] allLocalesForCurrencyCode:currencyCode];
        _currencyCode = currencyCode;
        
        _delegate = delegate;
    }
    return self;
}

- (id)initWithCountryCode:(NSString *)countryCode andDelegate:(id<LocaleTableViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Locale";
        
        _locales = [[TRLocaleHelper sharedInstance] allLocalesForCountryCode:countryCode];
        _countryCode = countryCode;
        
        _delegate = delegate;
    }
    return self;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _locales.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
        
    if (_delegate) {
        [_delegate selectedLocale:[_locales objectAtIndex:indexPath.row]];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSLocale *locale = [_locales objectAtIndex:indexPath.row];
    
    NSString *localeIdentifier = [locale objectForKey:NSLocaleIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", localeIdentifier];
    
    NSString *currencySymbol = [[[TRFormatterHelper sharedInstance] currencyFormatterForLocale:locale] currencySymbol];
    if (_currencyCode) {
        NSString *countryName = [locale displayNameForKey:NSLocaleCountryCode value:[locale objectForKey:NSLocaleCountryCode]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", currencySymbol, countryName];
    } else if (_countryCode) {
        NSString *currencyCode = [locale objectForKey:NSLocaleCurrencyCode];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", currencySymbol, currencyCode];
    }
    
    return cell;
}


@end
