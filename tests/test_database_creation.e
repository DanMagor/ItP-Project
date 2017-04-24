note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_DATABASE_CREATION

inherit
	EQA_TEST_SET

feature -- Test routines

	database_create_test
			-- New test routine
		note
			testing:  "covers/{APPLICATION_EXECUTION}.setup_router", "covers/{DATABASE}.make"
		local
			db:DATABASE

		do
			create db.make
		ensure

		end

end


