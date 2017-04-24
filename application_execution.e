note
	description: "Summary description for {APPLICATION_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_EXECUTION

inherit

	WSF_ROUTED_EXECUTION
		redefine
			initialize
		end

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_EXECUTION

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Constants

	db_path: STRING
		once
			Result := "AnnualForm.db"
		end

	db_open: SQLITE_DATABASE
		do
			create Result.make_open_read_write (db_path)
		end

feature {NONE} --Initialization

	initialize
		do
			Precursor
			initialize_router
		end

	setup_router
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
		do
			map_uri_template_agent ("/api/submit", agent submit, router.methods_get)
			map_uri_template_agent ("/api/admin", agent admin_page, router.methods_get)
			map_uri_template_agent ("/api/admin/publications", agent publications_over_year, router.methods_get)
			map_uri_template_agent ("/api/admin/unit_info", agent unit_info, router.methods_get)
			map_uri_template_agent ("/api/admin/lab_courses", agent lab_courses, router.methods_get)
			map_uri_template_agent ("/api/admin/number_students", agent number_students, router.methods_get)
			map_uri_template_agent ("/api/admin/number_collaborations", agent number_collaborations, router.methods_get)
			map_uri_template_agent ("/api/admin/best_paper", agent best_paper, router.methods_get)
			map_uri_template_agent ("/api/admin/list_of_units", agent list_of_units, router.methods_get)
			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"index.html">>)
			router.handle ("", fhdl, router.methods_GET)
		end

	list_of_units (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			db: SQLITE_DATABASE
			db_query_statement: SQLITE_QUERY_STATEMENT
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			query: READABLE_STRING_8
			mesg: WSF_HTML_PAGE_RESPONSE
			l_html: STRING
		do
			db := db_open
			query := "SELECT ANSWER FROM NameOfUnit;"
			create db_query_statement.make (query, db)
			cursor := db_query_statement.execute_new
			l_html := "<h1>Name of units</h1>"
			from
				cursor.start
			until
				cursor.after
			loop
				l_html.append ("<p>" + cursor.item.string_value (1) + "</p>")
				cursor.forth
			end
			if not l_html.has_substring ("<p>") then
				l_html.append ("<p>There are no units yet.</p>")
			end
			create mesg.make
			mesg.set_body (l_html)
			response.send (mesg)
			db.close
		end

	best_paper (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			db: SQLITE_DATABASE
			db_query_statement: SQLITE_QUERY_STATEMENT
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			query: READABLE_STRING_8
			name_of_unit: READABLE_STRING_8
			mesg: WSF_HTML_PAGE_RESPONSE
			l_html: STRING
		do
			name_of_unit := ""
			if attached {WSF_STRING} req.query_parameter ("NameOfUnit") as data_i then
				name_of_unit := data_i.url_encoded_value
			end
			db := db_open
			query := "[
				SELECT BestPaperAwards.ANSWER
					FROM BestPaperAwards
				JOIN NameOfUnit
					USING (G_ID)
				WHERE (NameOfUnit.ANSWER = '
			]" + name_of_unit + "');"
			create db_query_statement.make (query, db)
			cursor := db_query_statement.execute_new
			cursor.start
			create l_html.make_empty
			l_html.append ("<h1>Best papers</h1>")
			if not cursor.after then
				l_html.append ("<p>" + cursor.item.string_value (1) + "</p>")
			else
				l_html.append ("<p>There are no papers yet.</p>")
			end
			create mesg.make
			mesg.set_body (l_html)
			response.send (mesg)
			db.close
		end

	number_collaborations (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			db: SQLITE_DATABASE
			db_query_statement: SQLITE_QUERY_STATEMENT
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			query: READABLE_STRING_8
			i: INTEGER
			l_html: STRING
			mesg: WSF_HTML_PAGE_RESPONSE
		do
			db := db_open
			query := "[
				SELECT ANSWER FROM ResearchColaborations;
			]"
			create db_query_statement.make (query, db)
			i := 0
			cursor := db_query_statement.execute_new
			cursor.start
			across
				cursor as it
			loop
				i := i + it.item.string_value (1).split (',').count
			end
			if i = 0 then
				l_html := "<p>There is no any collaborations in laboratories</p>"
			else
				l_html := "<p>There are " + i.out + " collaborations in laboratories.</p>"
			end
			create mesg.make
			mesg.set_body (l_html)
			response.send (mesg)
			db.close
		end

	number_students (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			db: SQLITE_DATABASE
			db_query_statement: SQLITE_QUERY_STATEMENT
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			query: READABLE_STRING_8
			i: INTEGER
			mesg: WSF_HTML_PAGE_RESPONSE
			l_html: STRING
		do
			db := db_open
			query := "[
				SELECT ANSWER FROM StudentSupervised;
			]"
			i := 0
			io.put_string (query)
			create db_query_statement.make (query, db)
			cursor := db_query_statement.execute_new
			create l_html.make_empty
			create mesg.make
			from
				cursor.start
			until
				cursor.after
			loop
				i := i + cursor.item.string_value (1).split (',').count
				cursor.forth
			end
			if i = 0 then
				l_html.append ("<p>There are no students in laboratories yet.</p>")
			else
				l_html.append ("<p>There are " + i.out + " students in laboratories.</p>")
			end
			mesg.set_body (l_html)
			response.send (mesg)
			db.close
		end

	unit_info (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			db: SQLITE_DATABASE
			db_query_statement: SQLITE_QUERY_STATEMENT
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			query: READABLE_STRING_8
			start_date: READABLE_STRING_8
			end_date: READABLE_STRING_8
			name_of_unit: READABLE_STRING_8
			mesg: WSF_HTML_PAGE_RESPONSE
			l_html: STRING
		do
			db := db_open
				--
			name_of_unit := ""
			start_date := ""
			end_date := ""
				--
			if attached {WSF_STRING} req.query_parameter ("NameOfUnit") as data_i then
				name_of_unit := data_i.url_encoded_value
			end
			if attached {WSF_STRING} req.query_parameter ("StartOfReportingPeriod") as data_i then
				start_date := data_i.url_encoded_value
			end
			if attached {WSF_STRING} req.query_parameter ("EndOfReportingPeriod") as data_i then
				end_date := data_i.url_encoded_value
			end
				--
			io.put_string ("NEW LINES:")
			io.put_new_line
			io.put_string (name_of_unit)
			io.put_string (start_date)
			io.put_string (end_date)
			io.put_new_line
				--
			query := "[
								SELECT NameOfUnit.ANSWER, NameOfHeadOfUnit.ANSWER, StartOfReportingPeriod.ANSWER,
					EndOfReportingPeriod.ANSWER, CourseTaught.ANSWER, Examinations.ANSWER, StudentSupervised.ANSWER,
					CompletedStudentReports.ANSWER, CompletedPhDTheses.ANSWER, Grants.ANSWER, CourseTaught.ANSWER,
					ResearchProjects.ANSWER, ResearchColaborations.ANSWER,  ConferencePublications.ANSWER,
					JournalPublications.ANSWER, Patents.ANSWER, IPLicensing.ANSWER, BestPaperAwards.ANSWER,
					Membership.ANSWER, Prizes.ANSWER, IndustryColaborations.ANSWER, OtherInformation.ANSWER
				FROM NameOfUnit
					JOIN NameOfHeadOfUnit
						USING (G_ID)
					JOIN StartofReportingPeriod
						USING (G_ID)
					JOIN EndOfReportingPeriod
						USING (G_ID)
					JOIN CourseTaught
						USING (G_ID)
					JOIN Examinations
						USING (G_ID)
					JOIN StudentSupervised
						USING (G_ID)
					JOIN CompletedStudentReports
						USING (G_ID)
					JOIN CompletedPhDTheses
						USING (G_ID)
					JOIN Grants
						USING (G_ID)
					JOIN ResearchProjects
						USING (G_ID)
					JOIN ResearchColaborations
						USING (G_ID)
					JOIN ConferencePublications
						USING (G_ID)
					JOIN JournalPublications
						USING (G_ID)
					JOIN Patents
						USING (G_ID)
					JOIN IPLicensing
						USING (G_ID)
					JOIN BestPaperAwards
						USING (G_ID)
					JOIN Membership
						USING (G_ID)
					JOIN Prizes
						USING (G_ID)
					JOIN IndustryColaborations
						USING (G_ID)
					JOIN OtherInformation
						USING (G_ID)
				WHERE (NameOfUnit.ANSWER = '
			]" + name_of_unit + "') AND (StartOfReportingPeriod.ANSWER > '" + start_date + "') AND (EndOfReportingPeriod.ANSWER < '" + end_date + "');"
			io.put_string (query)
				--
			l_html := "<h1>Info about unit</h1>"
				--
			create db_query_statement.make (query, db)
			cursor := db_query_statement.execute_new
			cursor.start
			across
				cursor as it
			loop
				across
					1 |..| 22 as i
				loop
					l_html.append ("<p>")
					l_html.append (it.item.string_value (i.item.to_natural_32))
					l_html.append ("</p>")
				end
				l_html.append ("<hr/>");
			end
				--
			if not l_html.has_substring ("<p>") then
				l_html.append ("<p>There is no information during that period</p>")
			end
				--
			create mesg.make
			mesg.set_body (l_html)
			response.send (mesg)
			db.close
		end

	publications_over_year (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			db: SQLITE_DATABASE
			db_query_statement: SQLITE_QUERY_STATEMENT
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			query: READABLE_STRING_8
			start_year: INTEGER
			end_year: INTEGER
			mesg: WSF_HTML_PAGE_RESPONSE
			l_html: STRING
		do
			db := db_open
			if attached {WSF_STRING} req.query_parameter ("StartOfReportingPeriod") as data_i then
				start_year := data_i.url_encoded_value.to_integer_32
				end_year := start_year + 1
				query := "[
					SELECT ConferencePublications.ANSWER, JournalPublications.ANSWER
					FROM StartOfReportingPeriod
					JOIN ConferencePublications
					ON ConferencePublications.G_ID = StartOfReportingPeriod.G_ID
					JOIN JournalPublications
					ON JournalPublications.G_ID = StartOfReportingPeriod.G_ID
					WHERE StartOfReportingPeriod.ANSWER between'
				]"
				query := query + data_i.url_encoded_value + "' AND '" + end_year.out + "';"
				create db_query_statement.make (query, db)
				cursor := db_query_statement.execute_new
				create l_html.make_empty
				create mesg.make
				l_html.append ("<h1>Publications over year</h1>")
				from
					cursor.start
				until
					cursor.after
				loop
					l_html.append ("<p>")
					l_html.append (cursor.item.string_value (1) + " " + cursor.item.string_value (2))
					l_html.append ("%N")
					l_html.append ("</p>")
					cursor.forth
				end
				if not l_html.has_substring ("<p>") then
					l_html.append ("<p>There are no publications during that year</p>")
				end
				mesg.set_body (l_html)
				response.send (mesg)
			end
			db.close
		end

	submit (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			db: SQLITE_DATABASE
			db_insert_statement: SQLITE_INSERT_STATEMENT
			query: READABLE_STRING_8
			row_id: INTEGER_64
			db_table_names: ARRAY [STRING]
			db_table_name: STRING
		do
			db := db_open
				--
			query := "INSERT INTO General (NAME) VALUES('response');"
			create db_insert_statement.make (query, db)
			db_insert_statement.execute;
			row_id := db_insert_statement.last_row_id
				--
			db_table_names := <<"NameOfUnit", "NameOfHeadOfUnit", "StartOfReportingPeriod", "EndOfReportingPeriod", "CourseTaught", "Examinations", "StudentSupervised", "CompletedStudentReports", "CompletedPhDTheses", "Grants", "ResearchProjects", "ResearchColaborations", "ConferencePublications", "JournalPublications", "Patents", "IPLicensing", "BestPaperAwards", "Membership", "Prizes", "IndustryColaborations", "OtherInformation">>
			across
				db_table_names as it
			loop
				db_table_name := it.item
				if attached {WSF_STRING} req.query_parameter (db_table_name) as data_i then
					query := "INSERT INTO " + db_table_name + "(ANSWER, G_ID) VALUES ('" + data_i.url_encoded_value + "','" + row_id.out + "');"
					create db_insert_statement.make (query, db)
					db_insert_statement.execute

						-- TEST FEATURE
					query := "UPDATE " + db_table_name + " SET ANSWER = replace(ANSWER, '+', ' ');"
					create db_insert_statement.make (query, db)
					db_insert_statement.execute
					query := "UPDATE " + db_table_name + " SET ANSWER = replace(ANSWER, '%%2C', ',');"
					create db_insert_statement.make (query, db)
					db_insert_statement.execute
				end
			end
			db.close
			res.redirect_now ("/index.html")
		end

	admin_page (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			res.redirect_now ("/admin.html")
		end

	lab_courses (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			db: SQLITE_DATABASE
			db_query_statement: SQLITE_QUERY_STATEMENT
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			query: READABLE_STRING_8
			start_date: READABLE_STRING_8
			end_date: READABLE_STRING_8
			name_of_unit: READABLE_STRING_8
			mesg: WSF_HTML_PAGE_RESPONSE
			l_html: STRING
		do
			db := db_open
				--
			name_of_unit := ""
			start_date := ""
			end_date := ""
				--
			if attached {WSF_STRING} req.query_parameter ("NameOfUnit") as data_i then
				name_of_unit := data_i.url_encoded_value
			end
			if attached {WSF_STRING} req.query_parameter ("StartOfReportingPeriod") as data_i then
				start_date := data_i.url_encoded_value
			end
			if attached {WSF_STRING} req.query_parameter ("EndOfReporingPeriod") as data_i then
				end_date := data_i.url_encoded_value
			end
			query := "[
				SELECT CourseTaught.ANSWER
				FROM CourseTaught
					JOIN NameOfUnit
						ON CourseTaught.G_ID = NameOfUnit.G_ID
					JOIN StartOfReportingPeriod
						ON CourseTaught.G_ID = StartOfReportingPeriod.G_ID
					JOIN EndOfReportingPeriod
						ON CourseTaught.G_ID = EndOfReportingPeriod.G_ID
				WHERE (NameOfUnit.ANSWER='
			]" + name_of_unit + "') AND (StartOfReportingPeriod.ANSWER > '" + start_date + "') AND (EndOfReportingPeriod.ANSWER < '" + end_date + "');"
				--
			l_html := "<h1>Info about courses of the laboratory</h1>"
				--
			create db_query_statement.make (query, db)
			cursor := db_query_statement.execute_new
			cursor.start
			across
				cursor as it
			loop
				l_html.append ("<p>" + it.item.string_value (1) + "</p>")
			end
			if not l_html.has_substring ("<p>") then
				l_html.append ("<p>There is no information during that period</p>")
			end
			create mesg.make
			mesg.set_body (l_html)
			response.send (mesg)
			db.close
		end

end
