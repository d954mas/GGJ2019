local COMMON = require "libs.common"



local M = COMMON.class("Locale")

function M:initialize(eng)
	self.NAME_AI = eng and "AI" or "ИИ"
	self.TASK_1_TEXT = eng and "" or "Внештатная ситуация. Множественные повреждения корпуса.Выполняю аварийную посадку." .. "Посадка успешна."
	self.TASK_1_TEXT_2 = eng and "" or "Прерывание крио сна командного состава через:\n 5, 4, 3, 2, 1."
	self.TASK_1_TEXT_2_A_1 = eng and "" or "Ответ 1"
	self.TASK_1_TEXT_2_A_2 = eng and "" or "Ответ 2"
end


function M:get_portrait(name)
	if name == self.NAME_AI then
		return "ai"
	end
end

return M