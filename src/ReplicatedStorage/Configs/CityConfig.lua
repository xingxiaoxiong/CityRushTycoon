local RS = game:GetService('ReplicatedStorage')
local Card = require(RS.Source:WaitForChild("Constants"):WaitForChild("Card"))

local CityConfig = {
	['43'] = {
		Name = 'Beijing',
		Description = "Home to giant pandas and a huge palace where emperors once lived!",
		Cards = {
			Card.Teleport,
			Card.DestroyRail
		},
		Functions = {
			Shop = true,
		},
		Image = 'rbxassetid://14445247849',
	},
	['29'] = {
		Name = 'NanJing',
		Description = 'A city of gold history, where ancient walls are long.',
		Cards = {
			Card.DestroyRail,
		},
		Image = 'rbxassetid://14433114535',
	},
	['21'] = {
		Name = 'Lanzhou',
		Image = 'rbxassetid://14433115311',
		Description = 'Where golden noodles flow like rivers under the desert sun.',
	},
	['22'] = {
		Name = 'Xining',
		Image = 'rbxassetid://14433112373',
		Description = 'Snow-capped mountains and Tibetan chants, where spiritual journeys are done.',
	},
	['23'] = {
		Name = 'Chengdu',
		Image = 'rbxassetid://14433122331',
		Description = 'Tea, pandas, and spicy treats, laid-back fun has just begun!',
	},
	['24'] = {
		Name = 'Shijiazhuang',
		Image = 'rbxassetid://14433113804',
		Description = 'Fields of wheat dance with the wind, in this vibrant heartland.',
	},
	['25'] = {
		Name = 'Guiyang',
		Image = 'rbxassetid://14433121569',
		Description = "Mystical mountains and Miao songs, echoing nature's hum.",
	},
	['26'] = {
		Name = 'Wuhan',
		Image = 'rbxassetid://14433112815',
		Description = 'Mighty Yangtze River flows, with melodies of bells and gongs.',
	},
	['27'] = {
		Name = 'Zhengzhou',
		Image = 'rbxassetid://14433111975',
		Description = "Ancient crossroads where China's heartbeats prolong.",
	},
	['28'] = {
		Name = 'Jinan',
		Image = 'rbxassetid://14433115659',
		Description = "Springs bubble with stories, where waters and legends belong.",
	},
	['30'] = {
		Name = 'Hefei',
		Image = 'rbxassetid://14433116431',
		Description = 'Science and nature in harmony, innovation going strong.',
	},
	['31'] = {
		Name = 'Hangzhou',
		Image = 'rbxassetid://14445248435',
		Description = 'Majestic West Lake, where poets and dreamers belong.',
	},
	['32'] = {
		Name = 'Nanchang',
		Image = 'rbxassetid://14433114741',
		Description = "Heroes and lakes under the eastern sun's song.",
	},
	['33'] = {
		Name = 'Fuzhou',
		Image = 'rbxassetid://14433121894',
		Description = "By the sea with hot springs, where stories of ancient mariners throng.",
	},
	['34'] = {
		Name = 'Guangzhou',
		Image = 'rbxassetid://14433121753',
		Description = "Canton Tower twinkles, in this southern city of song.",
	},
	['35'] = {
		Name = 'Changsha',
		Image = 'rbxassetid://14433122625',
		Description = 'Spicy stews and TV stars, entertainment all night long.',
	},
	['36'] = {
		Name = 'Haikou',
		Image = 'rbxassetid://14433116774',
		Description = "Tropical breezes and coconut dreams, where summer feels lifelong.",
	},
	['37'] = {
		Name = 'Shenyang',
		Image = 'rbxassetid://14433113999',
		Description = "Ancient palaces whisper tales of China's northeastern land.",
	},
	['38'] = {
		Name = 'Changchun',
		Image = 'rbxassetid://14433122864',
		Description = "The land of cars and forests, where modern and nature blend.",
	},
	['39'] = {
		Name = 'Harbin',
		Image = 'rbxassetid://14433116980',
		Description = 'Ice castles and snow sculptures light up the winter wonderland.',
	},
	['40'] = {
		Name = 'Taiyuan',
		Image = 'rbxassetid://14433113406',
		Description = 'Ancient temples and coal mines, history and energy hand in hand.',
	},
	['41'] = {
		Name = "Xi'an",
		Image = 'rbxassetid://14433112495',
		Description = "Home to the terracotta warriors, silent guards of the ancient sand.",
	},
	['42'] = {
		Name = 'Taipei',
		Image = 'rbxassetid://14433113580',
		Description = "Soaring 101 tower, in this island of traditions and modern song.",
	},
	['44'] = {
		Name = 'Shanghai',
		Image = 'rbxassetid://14445248182',
		Description = "Skyscrapers rise like bamboo shoots, and boats sail the Bund!",
	},
	['45'] = {
		Name = 'Chongqing',
		Image = 'rbxassetid://14433122124',
		Description = "A city built on mountains with spicy hotpot that tickles your tongue!",
	},
	['46'] = {
		Name = 'Tianjin',
		Image = 'rbxassetid://14445248693',
		Description = "Where tall towers and ancient culture meet by the river's side.",
	},
	['47'] = {
		Name = 'Hohhot',
		Image = 'rbxassetid://14433115878',
		Description = "Vast grasslands and blue skies, where yurts and horses stand.",
	},
	['48'] = {
		Name = 'Nanning',
		Image = 'rbxassetid://14433114320',
		Description = "Lush green landscapes and folk songs sung strong.",
	},
	['49'] = {
		Name = 'Lhasa',
		Image = 'rbxassetid://14433115142',
		Description = "High in the clouds, where monks and majestic palaces belong.",
	},
	['50'] = {
		Name = 'Yinchuan',
		Image = 'rbxassetid://14433112210',
		Description = "Deserts meet green oases, where the ancient Silk Road used to shine and glow!",
	},
	['51'] = {
		Name = 'Urumqi',
		Image = 'rbxassetid://14433112645',
		Description = "Bazaars and dances, where cultures blend and throng.",
	},
	['52'] = {
		Name = 'Hong Kong',
		Image = 'rbxassetid://14433116148',
		Description = "Dazzling lights and island sights, a city that buzzes all night long.",
	},
	['53'] = {
		Name = 'Macao',
		Image = 'rbxassetid://14433114921',
		Description = "Neon lights and magic nights, where luck might make you strong.",
	},
	['54'] = {
		Name = "Kunming",
		Image = 'rbxassetid://14433115515',
		Description = "The Spring City with flowers that bloom all year long.",
	}
}

return CityConfig