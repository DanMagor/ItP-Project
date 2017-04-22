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
			map_uri_template_agent("/api/submit", agent submit, router.methods_get)
			map_uri_template_agent("/api/admin", agent admin_page, router.methods_get)
			map_uri_template_agent("/api/admin/publications", agent publications_over_year, router.methods_get)
			map_uri_template_agent("/api/admin/unit_info", agent unit_info, router.methods_get)
			map_uri_template_agent ("/api/admin/lab_courses", agent lab_courses, router.methods_get)
			map_uri_template_agent ("/api/admin/number_students", agent number_students, router.methods_get)
			map_uri_template_agent ("/api/admin/number_collaborations", agent number_collaborations, router.methods_get)
			map_uri_template_agent ("/api/admin/best_paper", agent best_paper, router.methods_get)
			create fhdl.make_hidden("www")
			fhdl.set_directory_index(<<"index.html">>)
			router.handle("",fhdl,router.methods_GET)
		end


	best_paper(req: WSF_REQUEST; res: WSF_RESPONSE)
	local
		db: SQLITE_DATABASE
		db_query_statement: SQLITE_QUERY_STATEMENT
		db_insert_statement: SQLITE_INSERT_STATEMENT
		cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		query: READABLE_STRING_8
		response_id :STRING
		i : INTEGER
		start_date:READABLE_STRING_8
		end_date:READABLE_STRING_8
		name_of_unit:READABLE_STRING_8
		mesg: WSF_HTML_PAGE_RESPONSE
        l_html: STRING
        do
        name_of_unit := ""
        	if attached {WSF_STRING} req.query_parameter ("NameOfUnit") as data_i then
			name_of_unit := data_i.url_encoded_value
			end
        create db.make_open_read_write ("AnnualForm.db")

        query :="[
  			SELECT BestPaperAwards.ANSWER FROM BestPaperAwards
   			JOIN NameOfUnit
    		ON BestPaperAwards.G_ID = NameOfUnit.G_ID
			WHERE (NameOfUnit.ANSWER =

			]" + name_of_unit +");"

		end

	number_collaborations(req:WSF_REQUEST; res:WSF_RESPONSE)
	local
		db: SQLITE_DATABASE
		db_query_statement: SQLITE_QUERY_STATEMENT
		db_insert_statement: SQLITE_INSERT_STATEMENT
		cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		query: READABLE_STRING_8
		response_id :STRING
		i : INTEGER
		index: INTEGER
		start_date:READABLE_STRING_8
		end_date:READABLE_STRING_8
		name_of_unit:READABLE_STRING_8
		mesg: WSF_HTML_PAGE_RESPONSE
        l_html: STRING
        do
        create db.make_open_read_write ("AnnualForm.db")
        query := "[
  			SELECT ANSWER FROM ResearchColaborations;
		]"
		i:=0
		io.put_string(query)
		create db_query_statement.make (query, db)
		cursor := db_query_statement.execute_new
		create l_html.make_empty
		create mesg.make
		from
			cursor.start
		until
			cursor.after
		loop

			cursor.item.string_value (1).replace_substring_all ("'%'2C", ",")
			i := i + cursor.item.string_value (1).split (',').count

			cursor.forth
		end
		if i=0 then l_html.append ("<p>There is no any collaborations in laboratories</p>") else
			l_html.append ("<p> There are " + i.out + " collaborations in laboratories" )
		end
		mesg.set_body (l_html)
		response.send (mesg)
        end

	number_students(req: WSF_REQUEST; res:WSF_RESPONSE)
		local
		db: SQLITE_DATABASE
		db_query_statement: SQLITE_QUERY_STATEMENT
		db_insert_statement: SQLITE_INSERT_STATEMENT
		cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		query: READABLE_STRING_8
		response_id :STRING
		i : INTEGER
		name_of_unit:READABLE_STRING_8
		start_date:READABLE_STRING_8
		end_date:READABLE_STRING_8
		mesg: WSF_HTML_PAGE_RESPONSE
        l_html: STRING
        do
        create db.make_open_read_write ("AnnualForm.db")
        query := "[
  			SELECT ANSWER FROM StudentSupervised;
		]"
		i:=0
		io.put_string(query)
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
		if i=0 then l_html.append ("<p>There is no any students in laboratories</p>") else
			l_html.append ("<p> There are " + i.out + " students in laboratories" )
		end
		mesg.set_body (l_html)
		response.send (mesg)
        end

	unit_info(req: WSF_REQUEST; res: WSF_RESPONSE)
		local
		db: SQLITE_DATABASE
		db_query_statement: SQLITE_QUERY_STATEMENT
		db_insert_statement: SQLITE_INSERT_STATEMENT
		cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		query: READABLE_STRING_8
		response_id :STRING
		i : INTEGER
		start_date:READABLE_STRING_8
		end_date:READABLE_STRING_8
		name_of_unit:READABLE_STRING_8
		mesg: WSF_HTML_PAGE_RESPONSE
        l_html: STRING
        do
        create db.make_open_read_write ("AnnualForm.db")


		name_of_unit:=""
		start_date:=""
		end_date:=""

		if attached {WSF_STRING} req.query_parameter ("NameOfUnit") as data_i then
			name_of_unit := data_i.url_encoded_value
		end
		if attached {WSF_STRING} req.query_parameter ("StartOfReportingPeriod") as data_i then
			start_date := data_i.url_encoded_value
		end
		if attached {WSF_STRING} req.query_parameter ("EndOfReportingPeriod") as data_i then
			end_date := data_i.url_encoded_value
		end
		io.put_string ("NEW LINES:")
		io.put_new_line
		io.put_string(name_of_unit)
		io.put_string (start_date)
		io.put_string (end_date)
		io.put_new_line
		query := "[
				SELECT NameOfUnit.ANSWER, NameOfHeadOfUnit.ANSWER, StartOfReportingPeriod.ANSWER, 
	EndOfReportingPeriod.ANSWER, CourseTaught.ANSWER, Examinations.ANSWER, StudentSupervised.ANSWER, 
	CompletedStudentReports.ANSWER, CompletedPhDTheses.ANSWER, Grants.ANSWER, CourseTaught.ANSWER,
	ResearchProjects.ANSWER, ResearchColaborations.ANSWER,  ConferencePublications.ANSWER,
	JournalPublications.ANSWER, Patents.ANSWER, IPLicensing.ANSWER, BestPaperAwards.ANSWER,
	Membership.ANSWER, Prizes.ANSWER, IndustryColaborations.ANSWER, OtherInformation.ANSWER
FROM NameOfUnit 
	JOIN NameOfHeadOfUnit
		ON NameOfHeadOfUnit.G_ID = NameOfUnit.G_ID
	JOIN StartofReportingPeriod
		ON StartofReportingPeriod.G_ID = NameOfUnit.G_ID
	JOIN EndOfReportingPeriod
		ON EndOfReportingPeriod.G_ID = NameOfUnit.G_ID
	JOIN CourseTaught
		ON CourseTaught.G_ID = NameOfUnit.G_ID
	JOIN Examinations
		ON Examinations.G_ID = NameOfUnit.G_ID
	JOIN StudentSupervised
		ON StudentSupervised.G_ID = NameOfUnit.G_ID
	JOIN CompletedStudentReports
		ON CompletedStudentReports.G_ID = NameOfUnit.G_ID
	JOIN CompletedPhDTheses
		ON CompletedPhDTheses.G_ID = NameOfUnit.G_ID
	JOIN Grants
		ON Grants.G_ID = NameOfUnit.G_ID
	JOIN ResearchProjects
		ON ResearchProjects.G_ID = NameOfUnit.G_ID
	JOIN ResearchColaborations
		ON ResearchColaborations.G_ID = NameOfUnit.G_ID
	JOIN ConferencePublications
		ON ConferencePublications.G_ID = NameOfUnit.G_ID
	JOIN JournalPublications
		ON JournalPublications.G_ID = NameOfUnit.G_ID
	JOIN Patents
		ON Patents.G_ID = NameOfUnit.G_ID
	JOIN IPLicensing
		ON IPLicensing.G_ID = NameOfUnit.G_ID
	JOIN BestPaperAwards
		ON BestPaperAwards.G_ID = NameOfUnit.G_ID
	JOIN Membership
		ON Membership.G_ID = NameOfUnit.G_ID
	JOIN Prizes
		ON Prizes.G_ID = NameOfUnit.G_ID
	JOIN IndustryColaborations
		ON IndustryColaborations.G_ID = NameOfUnit.G_ID
	JOIN OtherInformation
		ON OtherInformation.G_ID = NameOfUnit.G_ID
WHERE (NameOfUnit.ANSWER = '
]" +  name_of_unit + "') AND (StartOfReportingPeriod.ANSWER > '" + start_date +"') AND (EndOfReportingPeriod.ANSWER < '" + end_date +"');"
		io.put_string(query)
		create db_query_statement.make (query, db)
		cursor := db_query_statement.execute_new
		create l_html.make_empty
		create mesg.make
		l_html.append ("<h1>Info about unit:</h1>")

		from
			cursor.start
		until
			cursor.after
		loop
			l_html.append("<p>")
			from
			i:= 1
			until
			i>22
			loop
			l_html.append(cursor.item.string_value(i.to_natural_32))
			l_html.append("%N")
			l_html.append ("</p>")
			i:=i+1
			end
			cursor.forth
		end
		if not l_html.has_substring ("<p>") then l_html.append ("<p>There is no information during that period</p>")
		end
		mesg.set_body (l_html)
		response.send (mesg)
	end

	publications_over_year(req: WSF_REQUEST; res: WSF_RESPONSE)
	local
		db: SQLITE_DATABASE
		db_query_statement: SQLITE_QUERY_STATEMENT
		db_insert_statement: SQLITE_INSERT_STATEMENT
		cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		query: READABLE_STRING_8
		i: INTEGER
		response_id :STRING
		db_table_names: ARRAY[STRING]
		start_year:INTEGER
		end_year:INTEGER
		end_year_str:READABLE_STRING_8
		column:NATURAL_32

		mesg: WSF_HTML_PAGE_RESPONSE
        l_html: STRING


	do
		create db.make_open_read_write ("AnnualForm.db")
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
		l_html.append ("<h1>Publications over year:</h1>")

		from
			cursor.start
		until
			cursor.after
		loop
			l_html.append("<p>")
			l_html.append(cursor.item.string_value (1)+" " + cursor.item.string_value (2) )
			l_html.append("%N")
			l_html.append ("</p>")
			cursor.forth
		end
		if not l_html.has_substring ("<p>") then l_html.append ("<p>There are no publications during that year</p>")
		end
		mesg.set_body (l_html)
		response.send (mesg)
		end
		end

	submit(req: WSF_REQUEST; res:WSF_RESPONSE)
	local
		db: SQLITE_DATABASE
		db_query_statement: SQLITE_QUERY_STATEMENT
		db_insert_statement: SQLITE_INSERT_STATEMENT
		cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		query: READABLE_STRING_8
		i: INTEGER
		response_id :INTEGER
		db_table_names: ARRAY[STRING]
	do
		db_table_names := <<"NameOfUnit","NameOfHeadOfUnit","StartOfReportingPeriod",
		"EndOfReportingPeriod","CourseTaught","Examinations","StudentSupervised",
		"CompletedStudentReports","CompletedPhDTheses","Grants","ResearchProjects","ResearchColaborations",
		"ConferencePublications","JournalPublications","Patents","IPLicensing","BestPaperAwards","Membership","Prizes",
		"IndustryColaborations","OtherInformation">>
		create db.make_open_read_write ("AnnualForm.db")
		query := "INSERT INTO General (NAME) VALUES('response');"
		create db_insert_statement.make (query, db)
		db_insert_statement.execute;
		query := "SELECT MAX(ID) FROM General;"
		create db_query_statement.make (query, db)
		cursor := db_query_statement.execute_new
		response_id := cursor.item.integer_value (1)
		from
			i:=1
		until
			i > db_table_names.count
		loop
			if attached {WSF_STRING} req.query_parameter (db_table_names.at (i)) as data_i then
				query := "INSERT INTO " + db_table_names.at(i) + "(ANSWER, G_ID) VALUES ('" +
				data_i.url_encoded_value + "','" + response_id.out + "');"
				io.put_string (query)
				io.put_new_line
				create db_insert_statement.make (query, db)
				db_insert_statement.execute
				--TEST FEATURE
				query := "UPDATE " + db_table_names.at(i) +" SET ANSWER = replace(ANSWER, '+', ' ');"
				create db_insert_statement.make (query, db)
				db_insert_statement.execute
				query := "UPDATE " + db_table_names.at(i) +" SET ANSWER = replace(ANSWER, '%%2C', ',');"
				create db_insert_statement.make (query, db)
				db_insert_statement.execute

			end
			i := i+1
		end

		db.close

		res.redirect_now("/index.html")
	end




	admin_page(req: WSF_REQUEST; res:WSF_RESPONSE)
	do
		res.redirect_now ("/admin.html")
	end

	lab_courses(req: WSF_REQUEST; res:WSF_RESPONSE)
	local
		db: SQLITE_DATABASE
		db_query_statement: SQLITE_QUERY_STATEMENT
		db_insert_statement: SQLITE_INSERT_STATEMENT
		cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		query: READABLE_STRING_8
		response_id :STRING
		i : INTEGER
		start_date:READABLE_STRING_8
		end_date:READABLE_STRING_8
		name_of_unit:READABLE_STRING_8
		mesg: WSF_HTML_PAGE_RESPONSE
        l_html: STRING
	do
		create db.make_open_read_write ("AnnualForm.db")
		name_of_unit:=""
		start_date:=""
		end_date:=""

		if attached {WSF_STRING} req.query_parameter ("NameOfUnit") as data_i then
			name_of_unit := data_i.url_encoded_value
		end
		if attached {WSF_STRING} req.query_parameter ("StartOfReportingPeriod") as data_i then
			start_date := data_i.url_encoded_value
		end
		if attached {WSF_STRING} req.query_parameter ("EndOfReporingPeriod") as data_i then
			end_date := data_i.url_encoded_value
		end
		query:= "[
SELECT CourseTaught.ANSWER 
FROM CourseTaught
	JOIN NameOfUnit
		ON CourseTaught.G_ID = NameOfUnit.G_ID
	JOIN StartOfReportingPeriod
		ON CourseTaught.G_ID = StartOfReportingPeriod.G_ID
	JOIN EndOfReportingPeriod
		ON CourseTaught.G_ID = EndOfReportingPeriod.G_ID
WHERE (NameOfUnit.ANSWER='
]" +  name_of_unit + "') AND (StartOfReportingPeriod.ANSWER > '" + start_date +"') AND (EndOfReportingPeriod.ANSWER < '" + end_date +"');"
	io.put_string (query)
	create db_query_statement.make (query, db)
			cursor := db_query_statement.execute_new
			create l_html.make_empty
			create mesg.make
			l_html.append ("<h1>Info about courses of the laboratory:</h1>")

			from
				cursor.start
			until
				cursor.after
			loop
				l_html.append("<p>")
				l_html.append(cursor.item.string_value(1))
				l_html.append("%N")
				l_html.append ("</p>")
				cursor.forth
			end
			if not l_html.has_substring ("<p>") then l_html.append ("<p>There is no information during that period</p>")
			end
			mesg.set_body (l_html)
			response.send (mesg)
	end
end
