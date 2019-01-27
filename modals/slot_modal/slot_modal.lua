local ProxyScene = require "Jester.proxy_scene"
local Scene = ProxyScene:subclass("LogoScene")
local COMMON = require "libs.common"
local SM = require "Jester.jester"
local WORLD = require "world.world"


function Scene:initialize()
    ProxyScene.initialize(self, "SlotModal", "/slot_modal#proxy", "slot_modal:/scene_controller")
  --  self.msg_receiver = COMMON.MSG()
end

function Scene:on_show(input)
    if not COMMON.GLOBAL.M3_HELP then
        COMMON.GLOBAL.M3_HELP = true
        COMMON.GLOBAL.M3_NEED_RESTART = true
        local l = WORLD.locale
        local dialog = {
            {text = l.M3_HELP_TEXT, name = l.NAME_AI,a1 = {text = l.M3_HELP_A1}}
        }
        SM.show("TextModal",{dialog = dialog},{popup = false})
    end
end

function Scene:on_hide()
end

function Scene:init(go_self)
end

function Scene:final(go_self)

end

function Scene:update(go_self, dt)
end

function Scene:show_out(co)

end

function Scene:on_message(go_self, message_id, message, sender)
    --self.msg_receiver:on_message(self, message_id, message, sender)
end

function Scene:on_input(go_self, action_id, action, sender)
 --  self.input_receiver:on_input(go_self,action_id,action,sender)
end





--endregion
return Scene