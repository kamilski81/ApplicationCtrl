//
//  Header.h
//  OpsCheckSDK
//
//  Created by Giuseppe Macri on 8/21/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#ifndef OpsCheckSDK_Constants_h
#define OpsCheckSDK_Constants_h

#define OPSCHECK_SERVER @"http://localhost:3000"
#define OPSCHECK_PATH @"/versionings/check?version=%@&build=%@&app_key=%@"

#define OPSCHECK_CHECK_HEADER @"Version-Check"
#define OPSCHECK_FORCE_UPDATE_HEADER @"Version-Check-Force"

#define STATUS_CONNECT @"CONNECT"
#define STATUS_DONT_CONNECT @"DON'T CONNECT"

#define STATUS_SUCCESS 200
#define STATUS_MALFORMED_REQUEST 400
#define STATUS_PERMISSION_DENIED 401


#define DEBUG_PREFIX @"DEBUG OPSCHECK -"

#endif
