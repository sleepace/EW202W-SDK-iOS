//
//  SLPUtils+Data.m
//  Sleepace
//
//  Created by Martin on 5/16/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPUtils+Data.h"
#define kDeviceMaxBrightness (100)

@implementation SLPUtils (Data)

+ (UInt64)byteToUInt64:(Byte *)byte{
    UInt64 value = 0;
    value = (UInt64)(((UInt64)(byte[0] & 0xff) << 56)|
                     ((UInt64)(byte[1] & 0xff) << 48)|
                     ((UInt64)(byte[2] & 0xff) << 40)|
                     ((UInt64)(byte[3] & 0xff) << 32)|
                     ((byte[4] & 0xff) << 24)|
                     ((byte[5] & 0xff) << 16)|
                     ((byte[6] & 0xff) << 8)|
                     ((byte[7] & 0xff) << 0));
    return value;
}

+ (int32_t)byteToInt32:(Byte *)byte{
    int32_t value = 0;
    value = (int32_t)(((byte[0] & 0xff) << 24)|
                      ((byte[1] & 0xff) << 16)|
                      ((byte[2] & 0xff) << 8)|
                      ((byte[3] & 0xff) << 0));
    return value;
}

+ (int16_t)byteToInt16:(Byte *)byte{
    int16_t value = 0;
    value = (int16_t) (((byte[0] & 0xFF)<<8)
                       |(byte[1] & 0xFF));
    return value;
}

+ (int8_t)byteToInt8:(Byte *)byte{
    int8_t value = 0;
    value = (int8_t) (byte[0]);
    return value;
}


+(short)bytesToShort:(Byte *)src
{
    short value = 0;
    value = (short) ( ((src[0] & 0xFF)<<8)
                     |(src[1] & 0xFF));
    return value;
}


+ (NSData *)streamDataByInt64:(int64_t)value{
    Byte byte[sizeof(value)];
    memset(byte, 0, sizeof(byte));
    byte[0] = (value>>56)&0xFF;
    byte[1] = (value>>48)&0xFF;
    byte[2] = (value>>40)&0xFF;
    byte[3] = (value>>32)&0xFF;
    byte[4] = (value>>24)&0xFF;
    byte[5] = (value>>16)&0xFF;
    byte[6] = (value>>8)&0xFF;
    byte[7] = value & 0xFF;
    return [NSData dataWithBytes:byte length:sizeof(byte)];
}

+ (NSData *)streamDataByInt32:(int32_t)value{
    Byte byte[sizeof(value)];
    memset(byte, 0, sizeof(byte));
    byte[0] = (value>>24)&0xFF;
    byte[1] = (value>>16)&0xFF;
    byte[2] = (value>>8)&0xFF;
    byte[3] = value & 0xFF;
    return [NSData dataWithBytes:byte length:sizeof(byte)];
}

+ (NSData *)streamDataByInt16:(int16_t)value{
    Byte byte[sizeof(value)];
    memset(byte, 0, sizeof(byte));
    byte[0] = (value>>8)&0xFF;
    byte[1] = value&0xFF;
    return [NSData dataWithBytes:byte length:sizeof(byte)];
}

+ (NSData *)streamDataByInt8:(int8_t)value{
    Byte byte[sizeof(value)];
    memset(byte, 0, sizeof(byte));
    byte[0] = value&0xFF;
    return [NSData dataWithBytes:byte length:sizeof(byte)];
}

+ (void)emptyMutableData:(NSMutableData *)mutData{
    [mutData setData:[NSData data]];
}

+ (void)removeDataAtRange:(NSRange)range fromDataBuffer:(NSMutableData *)dataBuffer{
    if (!dataBuffer || dataBuffer.length == 0){
        return;
    }
    NSInteger dataLen = dataBuffer.length;
    if (range.location >= dataLen){
        return;
    }
    
    if (range.location + range.length > dataLen){
        range.length = dataLen - range.location;
    }
    [dataBuffer replaceBytesInRange:range withBytes:NULL length:0];
}

+ (NSRange)searchSubData:(NSData *)subData fromTheBeginOfBuffer:(NSData *)buffer atRange:(NSRange)range{
    if (!subData || subData.length == 0){
        return NSMakeRange(NSNotFound, 0);
    }
    
    NSUInteger subDataLength = subData.length;
    if (!buffer || buffer.length < subDataLength){
        return NSMakeRange(NSNotFound, 0);
    }
    
    NSInteger rangeEnd = range.location + range.length;
    if (rangeEnd > buffer.length){
        return NSMakeRange(NSNotFound, 0);
    }
    
    for (NSUInteger index = range.location ; index <= rangeEnd - subDataLength; index++){
        NSData *aData = [buffer subdataWithRange:NSMakeRange(index, subDataLength)];
        if ([aData isEqualToData:subData]){
            return NSMakeRange(index, subDataLength);
        }
    }
    return NSMakeRange(NSNotFound, 0);
}

+ (NSArray *)separateBuffer:(NSMutableData *)buffer withSeparator:(NSData *)separator{
    if (buffer.length == 0 || separator.length == 0){
        return nil;
    }
    
    NSUInteger bufferLength = buffer.length;
    NSUInteger separatorLength = separator.length;
    NSUInteger location = 0;
    
    NSMutableArray *subDataList = [NSMutableArray array];
    
    do{
        NSRange range = [self searchSubData:separator fromTheBeginOfBuffer:buffer atRange:NSMakeRange(location, bufferLength - location)];
        if (range.location == NSNotFound){
            location = NSNotFound;
        }else{
            NSUInteger subDataEndLocation = range.location + range.length;
            NSData *subData = [buffer subdataWithRange:NSMakeRange(location, subDataEndLocation - location)];
            [subDataList addObject:subData];
            location = subDataEndLocation;
        }
    }while (location != NSNotFound && location + separatorLength <= bufferLength);
    
    NSRange lastSeparatorRange = [buffer rangeOfData:separator options:NSDataSearchBackwards range:NSMakeRange(0, buffer.length)];
    if (lastSeparatorRange.location != NSNotFound){
        NSRange range = NSMakeRange(0,lastSeparatorRange.location + lastSeparatorRange.length);
        [self removeDataAtRange:range fromDataBuffer:buffer];
    }
    return subDataList;
}

+ (NSData *)fourteenByteDataFromDeviceID:(NSString *)deviceID;{
    NSMutableData *content = [NSMutableData data];
    if (deviceID.length > 0){
        NSData *deviceIDData = [deviceID dataUsingEncoding:NSUTF8StringEncoding];
        if (deviceIDData){
            [content appendData:deviceIDData];
        }
    }
    
    NSInteger length = content.length;
    for (NSInteger i = length; i < 14; i++){
        [content appendData:[SLPUtils streamDataByInt8:0]];
    }
    return content;
}


+ (UInt8)validDeviceBrightness:(NSInteger)brightness {
    return MIN(brightness, kDeviceMaxBrightness);
}

+ (NSData *)destinationLengthData:(NSInteger)length string:(NSString *)string {
    NSMutableData *content = [NSMutableData data];
    NSData *addressData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [content appendData:addressData];
    for (NSUInteger i = content.length; i < length; i++) {
        [content appendData:[SLPUtils streamDataByInt8:0]];
    }
    return content;
}

///小端数据
+ (int32_t)byteToInt32_SmallPort:(NSData *)data{
    //    int32_t value = 0;
    //    value = (int32_t)(((byte[0] & 0xff) << 0)|
    //                      ((byte[1] & 0xff) << 8)|
    //                      ((byte[2] & 0xff) << 16)|
    //                      ((byte[3] & 0xff) << 24));
    //    return value;
    
    //    int datalength;
    //    [data getBytes: &datalength length: sizeof(datalength)];
    //    int length=CFSwapInt32LittleToHost(datalength);
    UInt32 datalength;
    [data getBytes: &datalength length: sizeof(datalength)];
    UInt32 value=CFSwapInt32LittleToHost(datalength);
    return value;
    
}

+ (NSData *)streamDataByInt32_SmallPort:(int32_t)value{
    //    Byte byte[sizeof(value)];
    //    memset(byte, 0, sizeof(byte));
    //    byte[0] = (value>>0)&0xFF;
    //    byte[1] = (value>>8)&0xFF;
    //    byte[2] = (value>>16)&0xFF;
    //    byte[3] = (value>>24)&0xFF;
    //    return [NSData dataWithBytes:byte length:sizeof(byte)];
    UInt32 datatemplength =CFSwapInt32LittleToHost(value);
    NSData *data = [NSData dataWithBytes:&datatemplength length: sizeof(datatemplength)];
    return data;
}

@end
