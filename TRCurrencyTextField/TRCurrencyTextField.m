//  TRCurrencyTextField.m
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

#import "TRCurrencyTextField.h"

@implementation TRCurrencyTextField

@synthesize currencyCode = _currencyCode;
@synthesize countryCode = _countryCode;
@synthesize maxDigits = _maxDigits;
@synthesize value = _value;

NSNumberFormatter *_numberFormatter = nil;

#pragma mark - Superclass methods

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Private methods

- (void)initialize
{
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.font = [UIFont systemFontOfSize:15];
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.returnKeyType = UIReturnKeyDone;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.maxDigits = 11; // $999,999,999.99
    self.currencyCode = @"BRL";
    self.value = [NSNumber numberWithInt:0];
    
    self.delegate = self;
}

#pragma mark - Properties

- (void)setCurrencyCode:(NSString *)currencyCode
{
    _currencyCode = currencyCode;
    _countryCode = [[[LocaleHelper sharedInstance] localeWithCurrencyCode:_currencyCode] objectForKey:NSLocaleCountryCode];
    _numberFormatter = [[FormatterHelper sharedInstance] currencyFormatterForCurrencyCode:_currencyCode];
    self.text = [_numberFormatter stringFromNumber:_value];
}

- (NSString *)currencyCode
{
    return _currencyCode;
}

- (void)setCountryCode:(NSString *)countryCode
{
    _countryCode = countryCode;
    _currencyCode = [[[LocaleHelper sharedInstance] localeWithCountryCode:_countryCode] objectForKey:NSLocaleCurrencyCode];
    _numberFormatter = [[FormatterHelper sharedInstance] currencyFormatterForCountryCode:_countryCode];
    self.text = [_numberFormatter stringFromNumber:_value];
}

- (NSString *)countryCode
{
    return _countryCode;
}

- (void)setValue:(NSNumber *)value
{
    _value = value;
    self.text = [_numberFormatter stringFromNumber:_value];
}

- (NSNumber *)value
{
    if (_value) return _value;
    _value = [NSNumber numberWithInt:0];
    return _value;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.value = [NSNumber numberWithInt:0];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *stringMaybeChanged = [NSString stringWithString:string];
    if (stringMaybeChanged.length > 1)
    {
        NSMutableString *stringPasted = [NSMutableString stringWithString:stringMaybeChanged];
        
        [stringPasted replaceOccurrencesOfString:_numberFormatter.currencySymbol
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [stringPasted length])];
        
        [stringPasted replaceOccurrencesOfString:_numberFormatter.groupingSeparator
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [stringPasted length])];
        
        NSDecimalNumber *numberPasted = [NSDecimalNumber decimalNumberWithString:stringPasted];
        stringMaybeChanged = [_numberFormatter stringFromNumber:numberPasted];
    }
    
    UITextRange *selectedRange = [textField selectedTextRange];
    UITextPosition *start = textField.beginningOfDocument;
    NSInteger cursorOffset = [textField offsetFromPosition:start toPosition:selectedRange.start];
    NSMutableString *textFieldTextStr = [NSMutableString stringWithString:textField.text];
    NSUInteger textFieldTextStrLength = textFieldTextStr.length;
    
    [textFieldTextStr replaceCharactersInRange:range withString:stringMaybeChanged];
    
    [textFieldTextStr replaceOccurrencesOfString:_numberFormatter.currencySymbol
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [textFieldTextStr length])];
    
    [textFieldTextStr replaceOccurrencesOfString:_numberFormatter.groupingSeparator
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [textFieldTextStr length])];
    
    [textFieldTextStr replaceOccurrencesOfString:_numberFormatter.decimalSeparator
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [textFieldTextStr length])];
    
    if (textFieldTextStr.length <= self.maxDigits) {
        NSDecimalNumber *textFieldTextNum = [NSDecimalNumber decimalNumberWithString:textFieldTextStr];
        NSDecimalNumber *divideByNum = [[[NSDecimalNumber alloc] initWithInt:10] decimalNumberByRaisingToPower:_numberFormatter.maximumFractionDigits];
        NSDecimalNumber *textFieldTextNewNum = [textFieldTextNum decimalNumberByDividingBy:divideByNum];
        
        self.value = textFieldTextNewNum;
        
        if (cursorOffset != textFieldTextStrLength) {
            NSInteger lengthDelta = self.text.length - textFieldTextStrLength;
            NSInteger newCursorOffset = MAX(0, MIN(self.text.length, cursorOffset + lengthDelta));
            UITextPosition* newPosition = [textField positionFromPosition:textField.beginningOfDocument offset:newCursorOffset];
            UITextRange* newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
            [textField setSelectedTextRange:newRange];
        }
    }
    
    return NO;
}

@end
