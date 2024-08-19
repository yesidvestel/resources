QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
QBShared.Jobs = {
	unemployed = { label = 'Civilian', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Freelancer', payment = 10 } } },
	bus = { label = 'Bus', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Driver', payment = 50 } } },
	judge = { label = 'Honorary', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Judge', payment = 100 } } },
	lawyer = { label = 'Law Firm', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Associate', payment = 50 } } },
	reporter = { label = 'Reporter', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Journalist', payment = 50 } } },
	trucker = { label = 'Trucker', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Driver', payment = 50 } } },
	tow = { label = 'Towing', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Driver', payment = 50 } } },
	garbage = { label = 'Garbage', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Collector', payment = 50 } } },
	vineyard = { label = 'Vineyard', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Picker', payment = 50 } } },
	hotdog = { label = 'Hotdog', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Sales', payment = 50 } } },

	police = {
		label = 'Law Enforcement',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'Officer', payment = 30 },
			['2'] = { name = 'Sergeant', payment = 57 },
			['3'] = { name = 'Lieutenant', payment = 70 },
			['4'] = { name = 'Chief', isboss = true, payment = 120 },
		},
	},
	ambulance = {
		label = 'EMS',
		type = 'ems',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'Paramedic', payment = 30 },
			['2'] = { name = 'Doctor', payment = 57 },
			['3'] = { name = 'Surgeon', payment = 70 },
			['4'] = { name = 'Chief', isboss = true, payment = 120 },
		},
	},
	realestate = {
		label = 'Real Estate',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'House Sales', payment = 30 },
			['2'] = { name = 'Business Sales', payment = 57 },
			['3'] = { name = 'Broker', payment = 700 },
			['4'] = { name = 'Manager', isboss = true, payment = 120 },
		},
	},
	taxi = {
		label = 'Taxi',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'Driver', payment = 30 },
			['2'] = { name = 'Event Driver', payment = 57 },
			['3'] = { name = 'Sales', payment = 70 },
			['4'] = { name = 'Manager', isboss = true, payment = 120 },
		},
	},
	cardealer = {
		label = 'Vehicle Dealer',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'Showroom Sales', payment = 30 },
			['2'] = { name = 'Business Sales', payment = 57 },
			['3'] = { name = 'Finance', payment = 70 },
			['4'] = { name = 'Manager', isboss = true, payment = 120 },
		},
	},
	mechanic = {
		label = 'LS Customs',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'Novice', payment = 30 },
			['2'] = { name = 'Experienced', payment = 57 },
			['3'] = { name = 'Advanced', payment = 70 },
			['4'] = { name = 'Manager', isboss = true, payment = 120 },
		},
	},
	mechanic2 = {
		label = 'LS Customs',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'Novice', payment = 30 },
			['2'] = { name = 'Experienced', payment = 57 },
			['3'] = { name = 'Advanced', payment = 70 },
			['4'] = { name = 'Manager', isboss = true, payment = 120 },
		},
	},
	mechanic3 = {
		label = 'LS Customs',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'Novice', payment = 30 },
			['2'] = { name = 'Experienced', payment = 57 },
			['3'] = { name = 'Advanced', payment = 70 },
			['4'] = { name = 'Manager', isboss = true, payment = 120 },
		},
	},
	beeker = {
		label = 'Beeker\'s Garage',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'Novice', payment = 30 },
			['2'] = { name = 'Experienced', payment = 57 },
			['3'] = { name = 'Advanced', payment = 70 },
			['4'] = { name = 'Manager', isboss = true, payment = 120 },
		},
	},
	bennys = {
		label = 'Benny\'s Original Motor Works',
		type = 'mechanic',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recruit', payment = 20 },
			['1'] = { name = 'Novice', payment = 30 },
			['2'] = { name = 'Experienced', payment = 57 },
			['3'] = { name = 'Advanced', payment = 70 },
			['4'] = { name = 'Manager', isboss = true, payment = 120 },
		},
	},
	 vunicorn = {
		label = 'Vanilla Unicorn',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = { name = 'Trainee', payment = 20  },
			['1'] = {
                name = 'Employee',
                payment = 30
            },
			['2'] = {
                name = 'Bar Staff',
                payment = 40
            },
			['3'] = {
                name = 'Dancer',
                payment = 50
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 70
            },
            ['5'] = {
                name = 'Owner',
				isboss = true,
                payment = 120
            },
        },
	},
	uwu = {
		label = 'UwU Cat Cafe',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Novice',
                payment = 20
            },
			['1'] = {
                name = 'Employee',
                payment = 30
            },
			['2'] = {
                name = 'Experienced',
                payment = 57
            },
			['3'] = {
                name = 'Advanced',
                payment = 70
            },
			['4'] = {
                name = 'Boss',
				isboss = true,
                payment = 120
            },
        },
	},
}
