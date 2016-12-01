function calculateTime(seconds)
	local minutes = nil
	local hours = nil
	hours = math.floor(seconds/3600)
	local divisor_for_minutes = seconds % (60 * 60)
	minutes = math.floor(divisor_for_minutes / 60)
	local divisor_for_seconds = divisor_for_minutes % 60
	seconds = math.ceil(divisor_for_seconds)
	return hours..(hours == 1 and " hour, " or " hours, ")..minutes..(minutes == 1 and " minute, " or " minutes, ")..seconds..(seconds == 1 and " second " or " seconds")
end

return calculateTime