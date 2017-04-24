note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_SUBMIT

inherit
	EQA_TEST_SET

feature -- Test routines

	submit_test
			-- New test routine
		note
			testing:  "covers/{APPLICATION_EXECUTION}.setup_router"
		local
			app: APPLICATION
			req: WSF_REQUEST
			res: WSF_RESPONSE
		do

		end

end


