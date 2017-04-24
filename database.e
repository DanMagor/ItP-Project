note
	description: "Summary description for {DATABASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATABASE
create
	make



feature

	db: SQLITE_DATABASE
	make
		local

			db_insert_statement: SQLITE_INSERT_STATEMENT
			query: READABLE_STRING_8

		do

			create db.make_create_read_write ("AnnualForm.db")
			create db.make_open_read_write ("AnnualForm.db")

			query := "[
			CREATE TABLE IF NOT EXISTS
				General (ID integer PRIMARY KEY AUTOINCREMENT, NAME text NOT NULL);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS 
			NameOfUnit(R_ID integer PRIMARY KEY AUTOINCREMENT, 
			G_ID integer, ANSWER text NOT NULL, 
			FOREIGN KEY(G_ID) REFERENCES General (ID));
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS NameOfHeadOfUnit
			(R_ID integer PRIMARY KEY AUTOINCREMENT, G_ID integer, 
			ANSWER text NOT NULL,
			FOREIGN KEY(G_ID) REFERENCES General (ID));
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS StartOfReportingPeriod
			(R_ID integer PRIMARY KEY AUTOINCREMENT, G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID));
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS EndOfReportingPeriod
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID));
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS CourseTaught
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text NOT NULL,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS Examinations
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text NOT NULL,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query :="[
			CREATE TABLE IF NOT EXISTS StudentSupervised
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text NOT NULL,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS CompletedStudentReports
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text NOT NULL,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS CompletedPhDTheses
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text NOT NULL,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS Grants
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text NOT NULL,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query:= "[
			CREATE TABLE IF NOT EXISTS ResearchProjects
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text NOT NULL,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query:= "[
			CREATE TABLE IF NOT EXISTS ResearchColaborations
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS ConferencePublications
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS JournalPublications
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS Patents
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"

			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS IPLicensing
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS BestPaperAwards
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS Membership
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS Prizes
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS IndustryColaborations
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"

			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			query := "[
			CREATE TABLE IF NOT EXISTS OtherInformation
			(R_ID integer PRIMARY KEY AUTOINCREMENT,
			G_ID integer,
			ANSWER text,
			FOREIGN KEY(G_ID) REFERENCES General (ID)
			);
			]"
			create db_insert_statement.make (query,db)
			db_insert_statement.execute

			db.close

		ensure
			db_is_empty: db /= void
			db_is_open: db.is_closed
			end

end
