local d = require('debug')

hotline_protocol = Proto("HOTL",  "Hotline Protocol")

flag = ProtoField.int8("hotline.flag", "flag", base.DEC)
is_reply = ProtoField.int8("hotline.is_reply", "isReply", base.DEC)
req_type = ProtoField.uint16("hotline.req_type", "requestType", base.DEC)

tran_id = ProtoField.uint32("hotline.tran_id", "tranID", base.DEC)
error_code = ProtoField.uint32("hotline.error_code", "errorCode", base.DEC)
total_size = ProtoField.uint32("hotline.total_size", "totalSize", base.DEC)
data_size = ProtoField.uint32("hotline.data_size", "dataSize", base.DEC)
param_count = ProtoField.uint16("hotline.param_count", "fieldCount", base.DEC)

field_type = ProtoField.uint16("hotline.field_type", "fieldType", base.DEC)
field_size = ProtoField.uint16("hotline.field_size", "fieldSize", base.DEC)
field_data = ProtoField.none("hotline.field_data", "fieldData", base.HEX)

hotline_protocol.fields = { flag, is_reply, req_type, tran_id, error_code, total_size, data_size, param_count, field_type, field_size, field_data }

function hotline_protocol.dissector(buffer, pinfo, tree)
  length = buffer:len()
  if length == 0 then return end

  pinfo.cols.protocol = hotline_protocol.name

  local subtree = tree:add(hotline_protocol, buffer(), "Hotline Protocol Data")

  local is_reply_d = buffer(1,1):int()
  local opcode_number = buffer(2,2):int()
  local tran_name = get_tran_name(is_reply_d, opcode_number)

  subtree:add(flag, buffer(0,1))
  subtree:add(is_reply, buffer(1,1))
  subtree:add(req_type, buffer(2,2)):append_text(" (" .. tran_name .. ")")
  
  subtree:add(tran_id, buffer(4,4))
  subtree:add(error_code, buffer(8,4))
  subtree:add(total_size, buffer(12,4))
  subtree:add(data_size, buffer(16,4))
  subtree:add(param_count, buffer(20,2))

  local field_count = buffer(20,2):int()

  -- Starting byte of fields section of the payload.
  local cursor = 22
  for c=1,field_count do
      local field_size_i =  buffer(cursor+2,2):int()
      local field_id = buffer(cursor,2):int()
      local field_name = get_field_name(field_id)

      local fieldSubtree = subtree:add(hotline_protocol, buffer(), field_name)
      fieldSubtree:add(field_type, buffer(cursor,2)):append_text(" (" .. field_name .. ")")
      fieldSubtree:add(field_size, buffer(cursor+2,2))
      fieldSubtree:add(field_data, buffer(cursor+4, field_size_i))

      cursor = cursor + field_size_i + 4
  end
end

function get_tran_name(is_reply, opcode)
  local tran_name = "Unknown"

  -- Reply transactions don't include the transaction type, sadly
  if is_reply == 1 then
      return tran_name
  end

  if opcode ==    0    then tran_name = "TranError"
  elseif opcode == 101 then tran_name = "TranGetMsgs"
  elseif opcode == 102 then tran_name = "TranNewMsg"
  elseif opcode == 103 then tran_name = "TranOldPostNews"
  elseif opcode == 104 then tran_name = "TranServerMsg"
  elseif opcode == 105 then tran_name = "TranChatSend"
  elseif opcode == 106 then tran_name = "TranChatMsg"
  elseif opcode == 107 then tran_name = "TranLogin"
  elseif opcode == 108 then tran_name = "TranSendInstantMsg"
  elseif opcode == 109 then tran_name = "TranShowAgreement"
  elseif opcode == 110 then tran_name = "TranDisconnectUser"
  elseif opcode == 111 then tran_name = "TranDisconnectMsg"
  elseif opcode == 112 then tran_name = "TranInviteNewChat"
  elseif opcode == 113 then tran_name = "TranInviteToChat"
  elseif opcode == 114 then tran_name = "TranRejectChatInvite"
  elseif opcode == 115 then tran_name = "TranJoinChat"
  elseif opcode == 116 then tran_name = "TranLeaveChat"
  elseif opcode == 117 then tran_name = "TranNotifyChatChangeUse"
  elseif opcode == 118 then tran_name = "TranNotifyChatDeleteUse"
  elseif opcode == 119 then tran_name = "TranNotifyChatSubject"
  elseif opcode == 120 then tran_name = "TranSetChatSubject"
  elseif opcode == 121 then tran_name = "TranAgreed"
  elseif opcode == 122 then tran_name = "TranServerBanner"
  elseif opcode == 200 then tran_name = "TranGetFileNameList"
  elseif opcode == 202 then tran_name = "TranDownloadFile"
  elseif opcode == 203 then tran_name = "TranUploadFile"
  elseif opcode == 205 then tran_name = "TranNewFolder"
  elseif opcode == 204 then tran_name = "TranDeleteFile"
  elseif opcode == 206 then tran_name = "TranGetFileInfo"
  elseif opcode == 207 then tran_name = "TranSetFileInfo"
  elseif opcode == 208 then tran_name = "TranMoveFile"
  elseif opcode == 209 then tran_name = "TranMakeFileAlias"
  elseif opcode == 210 then tran_name = "TranDownloadFldr"
  elseif opcode == 211 then tran_name = "TranDownloadInfo"
  elseif opcode == 212 then tran_name = "TranDownloadBanner"
  elseif opcode == 213 then tran_name = "TranUploadFldr"
  elseif opcode == 300 then tran_name = "TranGetUserNameList"
  elseif opcode == 301 then tran_name = "TranNotifyChangeUser"
  elseif opcode == 302 then tran_name = "TranNotifyDeleteUser"
  elseif opcode == 303 then tran_name = "TranGetClientInfoText"
  elseif opcode == 304 then tran_name = "TranSetClientUserInfo"
  elseif opcode == 348 then tran_name = "TranListUsers"
  elseif opcode == 349 then tran_name = "TranUpdateUser"
  elseif opcode == 350 then tran_name = "TranNewUser"
  elseif opcode == 351 then tran_name = "TranDeleteUser"
  elseif opcode == 352 then tran_name = "TranGetUser"
  elseif opcode == 353 then tran_name = "TranSetUser"
  elseif opcode == 354 then tran_name = "TranUserAccess"
  elseif opcode == 355 then tran_name = "TranUserBroadcast"
  elseif opcode == 370 then tran_name = "TranGetNewsCatNameList"
  elseif opcode == 371 then tran_name = "TranGetNewsArtNameList"
  elseif opcode == 380 then tran_name = "TranDelNewsItem"
  elseif opcode == 381 then tran_name = "TranNewNewsFldr"
  elseif opcode == 382 then tran_name = "TranNewNewsCat"
  elseif opcode == 400 then tran_name = "TranGetNewsArtData"
  elseif opcode == 410 then tran_name = "TranPostNewsArt"
  elseif opcode == 411 then tran_name = "TranDelNewsArt"
  elseif opcode == 500 then tran_name = "TranKeepAlive"
  end

  return tran_name
end

function get_field_name(field_id)
    print("fieldID", field_id)
  local field_name = "Unknown"

  if field_id ==     100 then field_name = "TranError"
  elseif field_id == 101 then field_name = "FieldData"
  elseif field_id == 102 then field_name = "FieldUserName"
  elseif field_id == 103 then field_name = "FieldUserID"
  elseif field_id == 104 then field_name = "FieldUserIconID"
  elseif field_id == 105 then field_name = "FieldUserLogin"
  elseif field_id == 106 then field_name = "FieldUserPassword"
  elseif field_id == 107 then field_name = "FieldRefNum"
  elseif field_id == 108 then field_name = "FieldTransferSize"
  elseif field_id == 109 then field_name = "FieldChatOptions"
  elseif field_id == 110 then field_name = "FieldUserAccess"
  elseif field_id == 111 then field_name = "FieldUserAlias"
  elseif field_id == 112 then field_name = "FieldUserFlags"
  elseif field_id == 113 then field_name = "FieldOptions"
  elseif field_id == 114 then field_name = "FieldChatID"
  elseif field_id == 115 then field_name = "FieldChatSubject"
  elseif field_id == 116 then field_name = "FieldWaitingCount"
  elseif field_id == 152 then field_name = "FieldBannerType"
  elseif field_id == 152 then field_name = "FieldNoServerAgreement"
  elseif field_id == 160 then field_name = "FieldVersion"
  elseif field_id == 161 then field_name = "FieldCommunityBannerID"
  elseif field_id == 162 then field_name = "FieldServerName"
  elseif field_id == 200 then field_name = "FieldFileNameWithInfo"
  elseif field_id == 201 then field_name = "FieldFileName"
  elseif field_id == 202 then field_name = "FieldFilePath"
  elseif field_id == 203 then field_name = "FieldFileResumeData"
  elseif field_id == 204 then field_name = "FieldFileTransferOption"
  elseif field_id == 205 then field_name = "FieldFileTypeString"
  elseif field_id == 206 then field_name = "FieldFileCreatorString"
  elseif field_id == 207 then field_name = "FieldFileSize"
  elseif field_id == 208 then field_name = "FieldFileCreateDate"
  elseif field_id == 209 then field_name = "FieldFileModifyDate"
  elseif field_id == 210 then field_name = "FieldFileComment"
  elseif field_id == 211 then field_name = "FieldFileNewName"
  elseif field_id == 212 then field_name = "FieldFileNewPath"
  elseif field_id == 213 then field_name = "FieldFileType"
  elseif field_id == 214 then field_name = "FieldQuotingMsg"
  elseif field_id == 215 then field_name = "FieldAutomaticResponse"
  elseif field_id == 220 then field_name = "FieldFolderItemCount"
  elseif field_id == 300 then field_name = "FieldUsernameWithInfo"
  elseif field_id == 321 then field_name = "FieldNewsArtListData"
  elseif field_id == 322 then field_name = "FieldNewsCatName"
  elseif field_id == 323 then field_name = "FieldNewsCatListData15"
  elseif field_id == 325 then field_name = "FieldNewsPath"
  elseif field_id == 326 then field_name = "FieldNewsArtID"
  elseif field_id == 327 then field_name = "FieldNewsArtDataFlav"
  elseif field_id == 328 then field_name = "FieldNewsArtTitle"
  elseif field_id == 329 then field_name = "FieldNewsArtPoster"
  elseif field_id == 330 then field_name = "FieldNewsArtDate"
  elseif field_id == 331 then field_name = "FieldNewsArtPrevArt"
  elseif field_id == 332 then field_name = "FieldNewsArtNextArt"
  elseif field_id == 333 then field_name = "FieldNewsArtData"
  elseif field_id == 334 then field_name = "FieldNewsArtFlags"
  elseif field_id == 335 then field_name = "FieldNewsArtParentArt"
  elseif field_id == 336 then field_name = "FieldNewsArt1stChildArt"
  elseif field_id == 337 then field_name = "FieldNewsArtRecurseDel"
  end

  return field_name
end

local tcp_port = DissectorTable.get("tcp.port")
tcp_port:add(5500, hotline_protocol)
tcp_port:add(5600, hotline_protocol)
