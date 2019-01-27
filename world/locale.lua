local COMMON = require "libs.common"



local M = COMMON.class("Locale")

function M:initialize(eng)
	self.ENERGY = "%d <img=gui:energy_icon/>"
	self.ORE = "%d <img=gui:ore_icon/>"
	self.STEEL = "%d <img=gui:steel_icon/>"
	self.TECH = "%d <img=gui:tech_icon/>"



	self.BUILDING_1 =  eng and "Reactor" or "Реактор"
	self.BUILDING_2 =  eng and "Reactor" or "Шахта"
	self.BUILDING_3 =  eng and "Reactor" or "Переплавка"
	self.BUILDING_4 =  eng and "Reactor" or "Лаборатория"
	self.BUILDING_5 =  eng and "Reactor" or "Здание 5"


	self.NAME_AI = eng and "AI" or "ИИ"
	--region dialog1
	self.TASK_1_NAME = eng and "" or "Калибровка реактора"
	self.TASK_1_DESCRIPTION_1 = eng and "" or "Установить реактор"
	self.TASK_1_DESCRIPTION_2 = eng and "" or "Добыть 50 <img=gui:energy_icon/>"
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

	--endregion

	self.M3_HELP_TEXT = eng and "" or ""..
	"Проводи ремонт<img=gui:repair_icon/>.Улучшай здание <img=gui:upgrade_icon/>.Ускоряй его работу<img=gui:stopwatch_icon/> При работе твои инженерные навыки <img=gui:tech_icon/> улучшаются, они тебе еще пригодятся"
	self.M3_HELP_A1 = "Понятно"

    self.TASK_2_TEXT = eng and "" or "Отличная работа.Энергии достаточно для запуска шахты.При своей работе шахтеры тратят энергию, внимательно следи за ее количсетвом"
    self.TASK_2_A1 = eng and "" or "Вперед.В шахты."

    self.TASK_2_DESCRIPTION_1 = eng and "" or "Запусти шахты."
    self.TASK_2_DESCRIPTION_2 = eng and "" or "Добыть 50 <img=gui:ore_icon/>"
end


function M:get_portrait(name)
	if name == self.NAME_AI then
		return "ai"
	end
end

return M