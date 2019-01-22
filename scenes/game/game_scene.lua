local ProxyScene = require "Jester.proxy_scene"
local Scene = ProxyScene:subclass("LogoScene")
local COMMON = require "libs.common"
local WORLD = require "world.world"
local Subscription = require "libs.context_subscription"


function Scene:init_input()
    COMMON.input_acquire()
    self.input_receiver = COMMON.INPUT()
end
--endregion

function Scene:initialize()
    ProxyScene.initialize(self, "GameScene", "/game#proxy", "game:/scene_controller")
    self.msg_receiver = COMMON.MSG()
end

function Scene:on_show(input)

end

function Scene:on_hide()
end

function Scene:init(go_self)
    self:init_input()
    self.subscription = Subscription()
end

function Scene:final(go_self)
    self.subscription:unsubscribe()
    COMMON.input_release()
    WORLD:save()
    WORLD:dispose()
end

function Scene:update(go_self, dt)
    self.subscription:act()
    WORLD:update(dt)
end

function Scene:show_out(co)

end

function Scene:on_message(go_self, message_id, message, sender)
    self.msg_receiver:on_message(self, message_id, message, sender)
end

function Scene:on_input(go_self, action_id, action, sender)
   self.input_receiver:on_input(go_self,action_id,action,sender)
end





--endregion
return Scene