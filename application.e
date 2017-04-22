note
	description: "AnnualForm application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	WSF_DEFAULT_SERVICE[APPLICATION_EXECUTION]
		redefine
			initialize
		end



create
	make_and_launch

feature {NONE} -- Initialization

	initialize
		local
		database:DATABASE

		do
			set_service_option("port", 9090)
			create database.make

		end

end
