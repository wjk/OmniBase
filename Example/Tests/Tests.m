//
//  OmniBaseTests.m
//  OmniBaseTests
//
//  Created by William Kent on 07/03/2014.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <OmniBase/OmniBase.h>

SpecBegin(OmniBase)

describe(@"NSError(OBExtensions)", ^{
    it(@"should find an underlying error by its domain correctly", ^{
        NSError *innerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
        NSError *outerError = [NSError errorWithDomain:@"TestErrorDomain" code:1 userInfo:@{ NSUnderlyingErrorKey: innerError }];
        
        NSError *foundError = [outerError underlyingErrorWithDomain:NSCocoaErrorDomain];
        expect(foundError).to.equal(innerError);
    });

    it(@"should find an underlying error by its domain and code correctly (pass #1)", ^{
        NSError *innerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
        NSError *middleError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUbiquitousFileUnavailableError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        NSError *outerError = [NSError errorWithDomain:@"TestErrorDomain" code:1 userInfo:@{ NSUnderlyingErrorKey: middleError }];
        
        NSError *foundError = [outerError underlyingErrorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError];
        expect(foundError).to.equal(innerError);
    });
    
    it(@"should find an underlying error by its domain and code correctly (pass #1)", ^{
        NSError *innerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
        NSError *middleError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUbiquitousFileUnavailableError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        NSError *outerError = [NSError errorWithDomain:@"TestErrorDomain" code:1 userInfo:@{ NSUnderlyingErrorKey: middleError }];
        
        NSError *foundError = [outerError underlyingErrorWithDomain:NSCocoaErrorDomain code:NSUbiquitousFileUnavailableError];
        expect(foundError).to.equal(middleError);
    });
    
    it(@"should report if it has an underlying error correctly", ^{
        NSError *innerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
        NSError *middleError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUbiquitousFileUnavailableError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        NSError *outerError = [NSError errorWithDomain:@"TestErrorDomain" code:1 userInfo:@{ NSUnderlyingErrorKey: middleError }];
        
        BOOL errorExists = [outerError hasUnderlyingErrorDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError];
        expect(errorExists).to.beTruthy();
        errorExists = [outerError hasUnderlyingErrorDomain:NSCocoaErrorDomain code:NSUbiquitousFileUnavailableError];
        expect(errorExists).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by user cancelling (pass #1)", ^{
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil];
        expect(error.causedByUserCancelling).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by user cancelling (pass #2)", ^{
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:errAuthorizationCanceled userInfo:nil];
        expect(error.causedByUserCancelling).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by user cancelling (pass #3)", ^{
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:userCanceledErr userInfo:nil];
        expect(error.causedByUserCancelling).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by a missing file (pass #1)", ^{
        NSError *innerError = [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOENT userInfo:nil];
        NSError *outerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        expect(outerError.causedByMissingFile).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by a missing file (pass #2)", ^{
        NSError *innerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
        NSError *outerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        expect(outerError.causedByMissingFile).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by an unreachable host (pass #1)", ^{
        NSError *innerError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:nil];
        NSError *outerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        expect(outerError.causedByUnreachableHost).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by an unreachable host (pass #2)", ^{
        NSError *innerError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotFindHost userInfo:nil];
        NSError *outerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        expect(outerError.causedByUnreachableHost).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by an unreachable host (pass #3)", ^{
        NSError *innerError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNetworkConnectionLost userInfo:nil];
        NSError *outerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        expect(outerError.causedByUnreachableHost).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by an unreachable host (pass #4)", ^{
        NSError *innerError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorDNSLookupFailed userInfo:nil];
        NSError *outerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        expect(outerError.causedByUnreachableHost).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by an unreachable host (pass #5)", ^{
        NSError *innerError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
        NSError *outerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        expect(outerError.causedByUnreachableHost).to.beTruthy();
    });
    
    it(@"should determine if an error is caused by an unreachable host (pass #6)", ^{
        NSError *innerError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil];
        NSError *outerError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:@{ NSUnderlyingErrorKey: innerError }];
        expect(outerError.causedByUnreachableHost).to.beTruthy();
    });
});

SpecEnd
