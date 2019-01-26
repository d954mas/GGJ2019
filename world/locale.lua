local COMMON = require "libs.common"



local M = COMMON.class("Locale")

function M:initialize(eng)
	self.TASK_1_TEXT = eng and "" or "Внештатная ситуация.\nМножественные повреждения корпуса.\nВыполняю аварийную посадку.\n" .. "Посадка успешна."
	self.TASK_1_TEXT_2 = eng and "" or "Прерывание крио сна командного состава через:\n 5, 4, 3, 2, 1."

end


return M