//  LocaleHelper.m
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

#import "LocaleHelper.h"

@implementation LocaleHelper

static LocaleHelper *_self = nil;
static NSMutableDictionary *_currencyCodes = nil;

#pragma mark - Superclass methods

- (id)init
{
    self = [super init];
    if (self) {
        [self fillCurrencyCodeMap];
    }
    return self;
}

#pragma mark - Public methods

+ (id)sharedInstance
{
    if (!_self) {
        _self = [LocaleHelper new];
    }
    return _self;
}

- (NSLocale *)localeWithCountryCode:(NSString *)countryCode
{
    NSDictionary *components = [NSDictionary dictionaryWithObject:countryCode forKey:NSLocaleCountryCode];
    NSString *localeIdentifier = [NSLocale localeIdentifierFromComponents:components];
    
    if (localeIdentifier != nil) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
        NSString *currencyCode = [locale objectForKey: NSLocaleCurrencyCode];
        return [self localeWithCurrencyCode:currencyCode];
    }
    
    return nil;
}

- (NSLocale *)localeWithCurrencyCode:(NSString *)currencyCode
{
    NSLocale *locale = [_currencyCodes objectForKey:currencyCode];
    return locale;
}

#pragma mark - Private methods

- (void)fillCurrencyCodeMap
{
    _currencyCodes = [NSMutableDictionary new];
    
    // When we use availableLocalIdentifiers to get currency code, all separators and symbols are correct.
    // It does not happen when we try to get currency like country code method. Why? No-ideas.
    for (NSString *identifier in [NSLocale availableLocaleIdentifiers]) {
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:identifier];
        NSString *currencyCode = [locale objectForKey:NSLocaleCurrencyCode];
        
        if (currencyCode != nil) {
            [_currencyCodes setObject:locale forKey:currencyCode];
        }
    }
}

@end
