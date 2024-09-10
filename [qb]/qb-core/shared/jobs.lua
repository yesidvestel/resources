QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = false -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
QBShared.Jobs = {
	unemployed = { label = 'Civil', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Freelancer', payment = 10 } } },
	bus = { label = 'Autobús', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Conductor', payment = 50 } } },
	judge = { label = 'Honorario', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Juez', payment = 100 } } },
	lawyer = { label = 'Bufete', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Asociado', payment = 50 } } },
	reporter = { label = 'Reportero', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Periodista', payment = 50 } } },
	trucker = { label = 'Camionero', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Conductor', payment = 50 } } },
	tow = { label = 'Grua', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Conductor', payment = 50 } } },
	garbage = { label = 'Basura', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Recolector', payment = 50 } } },
	vineyard = { label = 'Viñedo', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Recolector', payment = 50 } } },
	hotdog = { label = 'Puesto de Hotdog', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Vendedor', payment = 50 } } },

	police = {
		label = 'Police',
		type = 'leo',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Recluta', payment = 20 },
			['1'] = { name = 'Patrullero', payment = 30 },
			['2'] = { name = 'Oficial', payment = 57 },
			['3'] = { name = 'Teniente', payment = 70 },
			['4'] = { name = 'Coronel', payment = 120 },
			['5'] = { name = 'General', isboss = true, payment = 150 },
		},
	},
	ambulance = {
		label = 'EMS',
		type = 'ems',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = 'Paramedico', payment = 20 },
			['1'] = { name = 'Enfermero', payment = 30 },
			['2'] = { name = 'Enfermero Jefe', payment = 57 },
			['3'] = { name = 'Médico', payment = 70 },
			['4'] = { name = 'Especialista', payment = 120 },
			['5'] = { name = 'Director General', isboss = true, payment = 150 },
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
