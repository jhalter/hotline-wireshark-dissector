local d = require('debug')

hotline_protocol = Proto("HOTL",  "Hotline Protocol")

flag = ProtoField.int8("hotline.flag", "flag", base.DEC)
is_reply = ProtoField.int8("hotline.is_reply", "isReply", base.DEC)
req_type = ProtoField.uint16("hotline.req_type", "requestType", base.DEC)

tran_id = ProtoField.uint32("hotline.tran_id", "tranID", base.DEC)
error_code = ProtoField.uint32("hotline.error_code", "errorCode", base.DEC)
total_size = ProtoField.uint32("hotline.total_size", "totalSize", base.DEC)
data_size = ProtoField.uint32("hotline.data_size", "dataSize", base.DEC)
param_count = ProtoField.uint16("hotline.param_count", "paramCount", base.DEC)
-- tran_id = ProtoField.uint32("hotline.tran_id", "tranID", base.DEC)

hotline_protocol.fields = { flag, is_reply, req_type, tran_id, error_code, total_size, data_size, param_count }

function hotline_protocol.dissector(buffer, pinfo, tree)
  length = buffer:len()
  if length == 0 then return end

  pinfo.cols.protocol = hotline_protocol.name

  local subtree = tree:add(hotline_protocol, buffer(), "Hotline Protocol Data")

  local opcode_number = buffer(2,2):int()
  local opcode_name = get_opcode_name(opcode_number)

  subtree:add(flag, buffer(0,1))
  subtree:add(is_reply, buffer(1,1))
  subtree:add(req_type, buffer(2,2)):append_text(" (" .. opcode_name .. ")")
  
  subtree:add(tran_id, buffer(4,4))
  subtree:add(error_code, buffer(8,4))
  subtree:add(total_size, buffer(12,4))
  subtree:add(data_size, buffer(16,4))
  subtree:add(param_count, buffer(20,2))
  
  
end

function get_opcode_name(opcode)
  local opcode_name = "Unknown"

      if opcode ==    0 then opcode_name = "TranError"
	  elseif opcode == 101 then opcode_name = "TranGetMsgs"
	  elseif opcode == 102 then opcode_name = "TranNewMsg"
	  elseif opcode == 103 then opcode_name = "TranOldPostNews"
	  elseif opcode == 104 then opcode_name = "TranServerMsg"
	  elseif opcode == 105 then opcode_name = "TranChatSend"
	  elseif opcode == 106 then opcode_name = "TranChatMsg"
	  elseif opcode == 107 then opcode_name = "TranLogin"
	  elseif opcode == 108 then opcode_name = "TranSendInstantMsg"
	  elseif opcode == 109 then opcode_name = "TranShowAgreement"
	  elseif opcode == 110 then opcode_name = "TranDisconnectUser"
	  elseif opcode == 111 then opcode_name = "TranDisconnectMsg"
	  elseif opcode == 112 then opcode_name = "TranInviteNewChat"
	  elseif opcode == 113 then opcode_name = "TranInviteToChat"
	  elseif opcode == 114 then opcode_name = "TranRejectChatInvite"
	  elseif opcode == 115 then opcode_name = "TranJoinChat"
	  elseif opcode == 116 then opcode_name = "TranLeaveChat"
	  elseif opcode == 117 then opcode_name = "TranNotifyChatChangeUse"
	  elseif opcode == 118 then opcode_name = "TranNotifyChatDeleteUse"
	  elseif opcode == 119 then opcode_name = "TranNotifyChatSubject"
	  elseif opcode == 120 then opcode_name = "TranSetChatSubject"
	  elseif opcode == 121 then opcode_name = "TranAgreed"
	  elseif opcode == 122 then opcode_name = "TranServerBanner"
	  elseif opcode == 200 then opcode_name = "TranGetFileNameList"
	  elseif opcode == 202 then opcode_name = "TranDownloadFile"
	  elseif opcode == 203 then opcode_name = "TranUploadFile"
	  elseif opcode == 205 then opcode_name = "TranNewFolder"
	  elseif opcode == 204 then opcode_name = "TranDeleteFile"
	  elseif opcode == 206 then opcode_name = "TranGetFileInfo"
	  elseif opcode == 207 then opcode_name = "TranSetFileInfo"
	  elseif opcode == 208 then opcode_name = "TranMoveFile"
	  elseif opcode == 209 then opcode_name = "TranMakeFileAlias"
	  elseif opcode == 210 then opcode_name = "TranDownloadFldr"
	  elseif opcode == 211 then opcode_name = "TranDownloadInfo"
	  elseif opcode == 212 then opcode_name = "TranDownloadBanner"
	  elseif opcode == 213 then opcode_name = "TranUploadFldr"
	  elseif opcode == 300 then opcode_name = "TranGetUserNameList"
	  elseif opcode == 301 then opcode_name = "TranNotifyChangeUser"
	  elseif opcode == 302 then opcode_name = "TranNotifyDeleteUser"
	  elseif opcode == 303 then opcode_name = "TranGetClientInfoText"
	  elseif opcode == 304 then opcode_name = "TranSetClientUserInfo"
	  elseif opcode == 348 then opcode_name = "TranListUsers"
	  elseif opcode == 349 then opcode_name = "TranUpdateUser"
	  elseif opcode == 350 then opcode_name = "TranNewUser"
	  elseif opcode == 351 then opcode_name = "TranDeleteUser"
	  elseif opcode == 352 then opcode_name = "TranGetUser"
	  elseif opcode == 353 then opcode_name = "TranSetUser"
	  elseif opcode == 354 then opcode_name = "TranUserAccess"
	  elseif opcode == 355 then opcode_name = "TranUserBroadcast"
	  elseif opcode == 370 then opcode_name = "TranGetNewsCatNameList"
	  elseif opcode == 371 then opcode_name = "TranGetNewsArtNameList"
	  elseif opcode == 380 then opcode_name = "TranDelNewsItem"
	  elseif opcode == 381 then opcode_name = "TranNewNewsFldr"
	  elseif opcode == 382 then opcode_name = "TranNewNewsCat"
	  elseif opcode == 400 then opcode_name = "TranGetNewsArtData"
	  elseif opcode == 410 then opcode_name = "TranPostNewsArt"
	  elseif opcode == 411 then opcode_name = "TranDelNewsArt"
	  elseif opcode == 500 then opcode_name = "TranKeepAlive" end

  return opcode_name
end

local tcp_port = DissectorTable.get("tcp.port")
tcp_port:add(5500, hotline_protocol)
