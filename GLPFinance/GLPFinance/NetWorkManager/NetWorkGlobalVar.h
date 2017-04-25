//
//  NetWorkGlobalVar.h
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#ifndef NetWorkGlobalVar_h
#define NetWorkGlobalVar_h

/*********************API接口****************************/
/************************LoginAPI***********************/
#define GF_Login_API @"/public/login"
/*******************************************************/

/************************PasswordResetAPI***********************/
#define GF_PasswordReset_API @"/public/forget_password"
#define GF_MessageSend_API @"/public/send_sms"
/*******************************************************/

/************************UserCenterAPI***********************/
#define GF_UploadPicture_API @"/public/upload_pic"
#define GF_HeadImageSet_API @"/user/set_head_image"
/*******************************************************/

/************************FeedbackAPI***********************/
#define GF_Feedback_API @"/user/feedback"
/*******************************************************/

/************************CheckAPI***********************/
#define GF_CheckList_API @"/check/get_list"
#define GF_CheckInfo_API @"/check/get_info"
#define GF_Audit_API @"/check/audit"
#define GF_UploadMaterialInfo_API @"/check/get_upload_info"
/*******************************************************/
/*******************************************************/

#endif /* NetWorkGlobalVar_h */
