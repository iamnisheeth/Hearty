//
//  UUIDKey.swift
//  Basic Chat
//
//  Created by Trevor Beaton on 12/3/16.
//  Copyright © 2016 Vanguard Logic LLC. All rights reserved.
//

import CoreBluetooth
//Uart Service uuid


//let kBLEService_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"

//  HEARTY device UUID
//let kBLEService_UUID = "D9E532CB-D12D-F0BE-78E4-DBC2FC09BCA2"
//let kBLE_Characteristic_uuid_Tx = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
//let kBLE_Characteristic_uuid_Rx = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"

//For HEARTY
let kBLEService_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb"
let kBLE_Characteristic_uuid_Tx = "0000ffe1-0000-1000-8000-00805f9b34fb"
let kBLE_Characteristic_uuid_Rx = "0000ffe1-0000-1000-8000-00805f9b34fb"
let MaxCharacters = 20

let BLEService_UUID = CBUUID(string: kBLEService_UUID)
let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx)//(Property = Write without response)
let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)// (Property = Read/Notify)
