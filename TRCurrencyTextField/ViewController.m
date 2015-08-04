//  ViewController.m
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

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UIImageView *_buttonCurrencyImage;
UIImageView *_buttonCountryImage;

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.navigationItem.title = @"Example";
        
        self.textField = [[TRCurrencyTextField alloc] initWithFrame:[self textFieldFrame]];
        [self.view addSubview:self.textField];
        
        self.buttonValue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.buttonValue addTarget:self action:@selector(showValue) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonValue addTarget:self action:@selector(highlightButton:) forControlEvents:UIControlEventTouchDown];
        [self.buttonValue addTarget:self action:@selector(unhighlightButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonValue addTarget:self action:@selector(unhighlightButton:) forControlEvents:UIControlEventTouchUpOutside];
        [self.buttonValue setTitle:@"Give me value!" forState:UIControlStateNormal];
        self.buttonValue.frame = [self buttonFrame];
        [self unhighlightButton:self.buttonValue];
        [self.view addSubview:self.buttonValue];
        
        self.buttonCurrency = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.buttonCurrency addTarget:self action:@selector(selectCurrency) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonCurrency addTarget:self action:@selector(highlightButton:) forControlEvents:UIControlEventTouchDown];
        [self.buttonCurrency addTarget:self action:@selector(unhighlightButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonCurrency addTarget:self action:@selector(unhighlightButton:) forControlEvents:UIControlEventTouchUpOutside];
        [self.buttonCurrency setTitle:@"Select currency code" forState:UIControlStateNormal];
        self.buttonCurrency.frame = [self buttonFrame];
        
        _buttonCurrencyImage = [self forwardIconNormal];
        [self.buttonCurrency addSubview:_buttonCurrencyImage];
        [self unhighlightButton:self.buttonCurrency];
        [self.view addSubview:self.buttonCurrency];
        
        self.buttonCountry = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.buttonCountry addTarget:self action:@selector(selectCountry) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonCountry addTarget:self action:@selector(highlightButton:) forControlEvents:UIControlEventTouchDown];
        [self.buttonCountry addTarget:self action:@selector(unhighlightButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonCountry addTarget:self action:@selector(unhighlightButton:) forControlEvents:UIControlEventTouchUpOutside];
        [self.buttonCountry setTitle:@"Select country code" forState:UIControlStateNormal];
        self.buttonCountry.frame = [self buttonFrame];
        
        _buttonCountryImage = [self forwardIconNormal];
        [self.buttonCountry addSubview:_buttonCountryImage];
        [self unhighlightButton:self.buttonCountry];
        [self.view addSubview:self.buttonCountry];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.textField becomeFirstResponder];
}

#pragma mark - CountryTableViewDelegate

- (void)selectedCountry:(NSString *)countryCode
{
    self.textField.countryCode = countryCode;
}

#pragma mark - CurrencyTableViewDelegate

- (void)selectedCurrency:(NSString *)currencyCode
{
    self.textField.currencyCode = currencyCode;
}

#pragma mark - Private methods

- (void)showValue
{
    NSString *message = [NSString stringWithFormat:@"Text: %@\n", self.textField.text];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"Number: %@\n", self.textField.value]];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"Currency Code: %@\n", self.textField.currencyCode]];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"Country Code: %@", self.textField.countryCode]];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Your value is..." message: message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}

- (void)selectCurrency
{
    CurrencyTableView *currencyTableView = [[CurrencyTableView alloc] initWithCurrencyCode:self.textField.currencyCode andDelegate:self];
    [self.navigationController pushViewController:currencyTableView animated:YES];
}

- (void)selectCountry
{
    CountryTableView *countryTableView = [[CountryTableView alloc] initWithCountryCode:self.textField.countryCode andDelegate:self];
    [self.navigationController pushViewController:countryTableView animated:YES];
}

- (CGRect)textFieldFrame
{
    float width = 200.0;
    float height = 40.0;
    float x = (self.view.frame.size.width - width)/2;
    float y = 30.0;
    
    return CGRectMake(x, y, width, height);
}

- (CGRect)buttonFrame
{
    float width = 200.0;
    float height = 40.0;
    float x = (self.view.frame.size.width - width)/2;
    
    UIView *lastView = [[self.view subviews] lastObject];
    float y = lastView.frame.origin.y + lastView.frame.size.height + 15.0;
    
    return CGRectMake(x, y, width, height);
}

- (void)highlightButton:(UIButton *)button
{
    button.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    [button setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    if ([button isEqual:self.buttonCurrency]) {
        [_buttonCurrencyImage removeFromSuperview];
        _buttonCurrencyImage = [self forwardIconHighlight];
        [button addSubview:_buttonCurrencyImage];
    }
    
    if ([button isEqual:self.buttonCountry]) {
        [_buttonCountryImage removeFromSuperview];
        _buttonCountryImage = [self forwardIconHighlight];
        [button addSubview:_buttonCountryImage];
    }
}

- (void)unhighlightButton:(UIButton *)button
{
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setCornerRadius:5.0];
    
    button.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if ([button isEqual:self.buttonCurrency]) {
        [_buttonCurrencyImage removeFromSuperview];
        _buttonCurrencyImage = [self forwardIconNormal];
        [button addSubview:_buttonCurrencyImage];
    }
    
    if ([button isEqual:self.buttonCountry]) {
        [_buttonCountryImage removeFromSuperview];
        _buttonCountryImage = [self forwardIconNormal];
        [button addSubview:_buttonCountryImage];
    }
}

- (UIImageView *)forwardIconNormal
{
    UIImageView *image = [[UIImageView alloc] init];
    image.frame = CGRectMake(180, 15, 10, 10);
    image.image = [UIImage imageNamed:@"forward-normal.png"];
    return image;
}

- (UIImageView *)forwardIconHighlight
{
    UIImageView *image = [[UIImageView alloc] init];
    image.frame = CGRectMake(180, 15, 10, 10);
    image.image = [UIImage imageNamed:@"forward-highlight.png"];
    return image;
}

@end
