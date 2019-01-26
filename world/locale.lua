local COMMON = require "libs.common"



local M = COMMON.class("Locale")

function M:initialize(eng)
	self.NAME_AI = eng and "AI" or "ИИ"
	self.TASK_1_NAME = eng and "" or "Калибровка реактора"
	self.TASK_1_DESCRIPTION = eng and "" or "<img=gui:task_check/>Установить реактор\n\n<img=gui:task_check/>Добыть 100 энергии"
	self.TASK_1_TEXT = eng and "" or "Внештатная ситуация. Множественные повреждения корпуса.Выполняю аварийную посадку." .. "Посадка успешна."
	self.TASK_1_TEXT_2 = eng and "" or "Согласно директиве e1286 выполняю прерывание криосна.5, 4, 3, 2, 1.Прерывание выполнено. Показатели в пределах нормы."
	.. "Корабль привестует капитан. Иницирую передачу прав "
	self.TASK_1_TEXT_2_A_1 = eng and "" or "Права принял.Корабль, отчет."
	self.TASK_1_TEXT_2_A_2 = eng and "" or "Права принял.Что здесь происходит?"
	self.TASK_1_TEXT_3 = eng and "" or "Докладываю.Из-за воздействия неизвестной анамалии, корабль критически поврежден.Ремонт не возможен. Аварийный маяк не дееспособен.\n" ..
	"Права переданны капитану для принятия решений.Рекомендую инициировать протокол \"Робинзон\""
	self.TASK_1_TEXT_3_A_1 = eng and "" or "Протокол \"Робинзон\"?"
	self.TASK_1_TEXT_3_A_2 = eng and "" or "Другие варианты?"
	self.TASK_1_TEXT_3_A_3 = eng and "" or "Инициировать протокол \"Робинзон\""

	self.TASK_1_TEXT_4 = eng and "" or "Протокол \"Робинзон\" предназначен для длительного выживания.Корабль будет разобран на материалы.\n" ..
	"Будут созданы условия для жизни.Рекомендован для применения в критических ситуациях, при невозможности подать сигнал СОС"
	self.TASK_1_TEXT_4_A_1 = self.TASK_1_TEXT_3_A_2
	self.TASK_1_TEXT_4_A_2 = self.TASK_1_TEXT_3_A_3

	self.TASK_1_TEXT_5 = eng and "" or "Другие варианты не возможны."
	self.TASK_1_TEXT_5_A_1 = self.TASK_1_TEXT_3_A_1
	self.TASK_1_TEXT_5_A_2 = self.TASK_1_TEXT_3_A_3


	self.TASK_1_TEXT_6 = eng and "" or "Инициирую.Инициирую.Инициирую.\n" ..
	"Инициация успешна.Корабль разобран.Среда для жизни создана.\nНеобходимо откалибровать реактор"
	self.TASK_1_TEXT_6_A_1 = eng and "" or "Как всегда, все работу нужно делать самому."
end


function M:get_portrait(name)
	if name == self.NAME_AI then
		return "ai"
	end
end

return M