//
//  TRCurrencyTextFieldTests.m
//  TRCurrencyTextFieldTests
//
//  Created by Thiago Rossener on 08/05/2015.
//  Copyright (c) 2015 Thiago Rossener. All rights reserved.
//

@import XCTest;
@import TRCurrencyTextField;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConvertValueToStringWithCurrencyCodeValid
{
    NSString *formattedString = [[TRFormatterHelper sharedInstance] stringFormattedFromValue:[NSNumber numberWithFloat:1.23f] withCurrencyCode:@"BRL"];
    
    XCTAssert([formattedString isEqualToString:@"R$ 1,23"]);
}

- (void)testConvertValueToStringWithCurrencyCodeInvalid
{
    XCTAssertThrowsSpecific([[TRFormatterHelper sharedInstance] stringFormattedFromValue:[NSNumber numberWithFloat:1.23f] withCurrencyCode:@"ZZZ"], NSException, @"Currency code passed as parameter is not valid.");
}

- (void)testConvertStringToValueWithCurrencyCodeValue
{
    NSNumber *number = [[TRFormatterHelper sharedInstance] valueFromStringFormatted:@"R$ 1,23" andCurrencyCode:@"BRL"];
    
    XCTAssert([number isEqualToNumber:[NSNumber numberWithDouble:1.23]]);
}

- (void)testConvertStringToValueWithCurrencyCodeInvalue
{
    XCTAssertThrowsSpecific([[TRFormatterHelper sharedInstance] valueFromStringFormatted:@"R$ 1,23" andCurrencyCode:@"ZZZ"], NSException, @"Currency code passed as parameter is not valid.");
}

@end

