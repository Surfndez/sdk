//
//  DelegateMRequestListener.m
//
//  Created by Javier Navarro on 08/10/14.
//  Copyright (c) 2014 MEGA. All rights reserved.
//

#import "DelegateMRequestListener.h"
#import "MRequest+init.h"
#import "MError+init.h"
#import "MegaSDK+init.h"

using namespace mega;

DelegateMRequestListener::DelegateMRequestListener(MegaSDK *megaSDK, id<MRequestDelegate>listener, bool singleListener) {
    this->megaSDK = megaSDK;
    this->listener = listener;
    this->singleListener = singleListener;
}

id<MRequestDelegate>DelegateMRequestListener::getUserListener() {
    return listener;
}

void DelegateMRequestListener::onRequestStart(MegaApi *api, MegaRequest *request) {
    if (listener != nil) {
        MegaRequest *tempRequest = request->copy();
        dispatch_async(dispatch_get_main_queue(), ^{
            [listener onRequestStart:this->megaSDK request:[[MRequest alloc]initWithMegaRequest:tempRequest cMemoryOwn:YES]];
        });
    }
}

void DelegateMRequestListener::onRequestFinish(MegaApi *api, MegaRequest *request, MegaError *e) {
    if (listener != nil) {
        MegaRequest *tempRequest = request->copy();
        MegaError *tempError = e->copy();
        dispatch_async(dispatch_get_main_queue(), ^{
            [listener onRequestFinish:this->megaSDK request:[[MRequest alloc]initWithMegaRequest:tempRequest cMemoryOwn:YES] error:[[MError alloc] initWithMegaError:tempError cMemoryOwn:YES]];
            if (singleListener) {
                [megaSDK freeRequestListener:this];
            }
        });
    }
}

void DelegateMRequestListener::onRequestUpdate(MegaApi *api, MegaRequest *request) {
    if (listener != nil) {
        MegaRequest *tempRequest = request->copy();
        dispatch_async(dispatch_get_main_queue(), ^{
            [listener onRequestUpdate:this->megaSDK request:[[MRequest alloc] initWithMegaRequest:tempRequest cMemoryOwn:YES]];
        });
    }
}

void DelegateMRequestListener::onRequestTemporaryError(MegaApi *api, MegaRequest *request, MegaError *e) {
    if (listener != nil) {
        MegaRequest *tempRequest = request->copy();
        dispatch_async(dispatch_get_main_queue(), ^{
            [listener onRequestTemporaryError:this->megaSDK request:[[MRequest alloc] initWithMegaRequest:tempRequest cMemoryOwn:YES] error:[[MError alloc] initWithMegaError:e cMemoryOwn:YES]];
        });
    }
}
