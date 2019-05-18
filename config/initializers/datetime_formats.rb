Time::DATE_FORMATS[:rmpd_custom] = '%H:%M:%S'
Date::DATE_FORMATS[:rmpd_custom_date] = '%d.%m.%Y'
Time::DATE_FORMATS[:rmpd_custom_date_time] = Date::DATE_FORMATS[:rmpd_custom_date] + ' ' + Time::DATE_FORMATS[:rmpd_custom] + ' %Z'
