drop table if EXISTS bootcamps,description,descriptions, teachers, students, modules, mod_bootcamps
;

CREATE TABLE bootcamps (
	bootcamp_id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	description TEXT,
	price float,
	start_date date,
	end_date date 

);

ALTER TABLE bootcamps
ALTER column name SET NOT NULL;


----------------------------------------------------------------------

CREATE TABLE teachers (
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	surname VARCHAR(255),
	email VARCHAR(255),
	phone VARCHAR(20)


);

ALTER TABLE teachers
ADD CONSTRAINT unique_email unique (email);
ALTER TABLE teachers
ADD CONSTRAINT unique_phone unique (phone);


ALTER TABLE teachers
ALTER column name SET NOT NULL;
ALTER TABLE teachers
ALTER column surname SET NOT NULL;
ALTER TABLE teachers
ALTER column email SET NOT NULL;
ALTER TABLE teachers
ALTER column phone SET NOT NULL;

----------------------------------------------------------------------

CREATE TABLE students (
	student_id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	surname VARCHAR(255),
	email VARCHAR(255),
	phone VARCHAR (20)

);

ALTER TABLE students
ADD CONSTRAINT unique_email unique (email);
ALTER TABLE students
ADD CONSTRAINT unique_phone unique (phone);


ALTER TABLE students
ALTER column name SET NOT NULL;
ALTER TABLE students
ALTER column surname SET NOT NULL;
ALTER TABLE students
ALTER column email SET NOT NULL;
ALTER TABLE students
ALTER column phone SET NOT NULL;



----------------------------------------------------------------------



CREATE TABLE descriptions (
	description_id SERIAL PRIMARY KEY,
	description TEXT,
	start_date date,
	end_date date 

);

----------------------------------------------------------------------

CREATE TABLE modules (
	module_id SERIAL PRIMARY KEY,
	description_id INT,
	teacher_id INT,
	student_id INT,
FOREIGN KEY (description_id) REFERENCES DESCRIPTIONS (description_id),
FOREIGN KEY (teacher_id) REFERENCES TEACHERS (teacher_id),
FOREIGN KEY (student_id) REFERENCES STUDENTS (student_id)

);
----------------------------------------------------------------------


CREATE TABLE mod_bootcamps (
	boot_mod_id SERIAL PRIMARY KEY,
	module_id INT,
	bootcamp_id INT,

FOREIGN KEY (module_id) REFERENCES MODULES (module_id),
FOREIGN KEY (bootcamp_id) REFERENCES BOOTCAMPS (bootcamp_id),
UNIQUE (module_id, bootcamp_id)
);
