function OnTranslationsReady() {
	tags = Translations.ReportTags;
	condecorates = Translations.Condecorations;
	divisions = Translations.DivisionsData;
	dataTableLanguage = {
		sProcessing: Translations.sProcessing,
		sLengthMenu: Translations.sLengthMenu,
		sZeroRecords: Translations.sZeroRecords,
		sEmptyTable: Translations.sEmptyTable,
		sInfo: Translations.sInfo,
		sInfoEmpty: Translations.sInfoEmpty,
		sInfoFiltered: Translations.sInfoFiltered,
		sInfoPostFix: '',
		sSearch: Translations.sSearch,
		sUrl: '',
		sInfoThousands: ',',
		sLoadingRecords: Translations.sLoadingRecords,
		oPaginate: {
			sFirst: Translations.oPaginateFirst,
			sLast: Translations.oPaginateLast,
			sNext: Translations.oPaginateNext,
			sPrevious: Translations.oPaginatePrevious
		},
		oAria: {
			sSortAscending: Translations.sSortAscending,
			sSortDescending: Translations.sSortDescending
		}
	};
}