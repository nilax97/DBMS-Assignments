INSERT INTO student VALUES ('1', 'Mehak');
INSERT INTO student VALUES ('2', 'Sagar');
INSERT INTO student VALUES ('3', 'Nilaksh');
INSERT INTO student VALUES ('4', 'Preet');
INSERT INTO student VALUES ('5', 'Goyal');
INSERT INTO student VALUES ('6', 'Agarwal');
INSERT INTO student VALUES ('7', 'Dhaliwal');

INSERT INTO course VALUES ('100', 'One Hundred');
INSERT INTO course VALUES ('200', 'Two Hundred');
INSERT INTO course VALUES ('300', 'Three Hundred');
INSERT INTO course VALUES ('400', 'Four Hundred');
INSERT INTO course VALUES ('500', 'Five Hundred');
INSERT INTO course VALUES ('600', 'Six Hundred');

INSERT INTO teacher VALUES ('11', 'Sayan');
INSERT INTO teacher VALUES ('12', 'Saroj');
INSERT INTO teacher VALUES ('13', 'Sak');
INSERT INTO teacher VALUES ('14', 'Ragesh');
INSERT INTO teacher VALUES ('15', 'Kalra');
INSERT INTO teacher VALUES ('16', 'Panda');
INSERT INTO teacher VALUES ('17', 'Subodh');

INSERT INTO section VALUES ('A', '100');
INSERT INTO section VALUES ('B', '100');
INSERT INTO section VALUES ('C', '100');
INSERT INTO section VALUES ('D', '100');
INSERT INTO section VALUES ('A', '200');
INSERT INTO section VALUES ('B', '200');
INSERT INTO section VALUES ('C', '300');
INSERT INTO section VALUES ('D', '400');
INSERT INTO section VALUES ('C', '500');
INSERT INTO section VALUES ('B', '600');
INSERT INTO section VALUES ('A', '600');
INSERT INTO section VALUES ('C', '600');

INSERT INTO registers VALUES ('1', '100');
INSERT INTO registers VALUES ('1', '200');
INSERT INTO registers VALUES ('2', '100');
INSERT INTO registers VALUES ('1', '500');
INSERT INTO registers VALUES ('2', '600');
INSERT INTO registers VALUES ('3', '100');
INSERT INTO registers VALUES ('4', '200');
INSERT INTO registers VALUES ('5', '100');
INSERT INTO registers VALUES ('6', '500');
INSERT INTO registers VALUES ('7', '600');
INSERT INTO registers VALUES ('7', '200');
INSERT INTO registers VALUES ('3', '200');
INSERT INTO registers VALUES ('6', '100');
INSERT INTO registers VALUES ('4', '500');
INSERT INTO registers VALUES ('1', '600');
INSERT INTO registers VALUES ('4', '100');

INSERT INTO teaches VALUES ('100', '11');
INSERT INTO teaches VALUES ('200', '12');
INSERT INTO teaches VALUES ('300', '13');
INSERT INTO teaches VALUES ('400', '12');
INSERT INTO teaches VALUES ('500', '11');
INSERT INTO teaches VALUES ('600', '14');
INSERT INTO teaches VALUES ('100', '14');
INSERT INTO teaches VALUES ('200', '15');
INSERT INTO teaches VALUES ('300', '16');
INSERT INTO teaches VALUES ('400', '17');
INSERT INTO teaches VALUES ('500', '16');
INSERT INTO teaches VALUES ('600', '15');

SELECT course_id FROM section WHERE section_number = 'A';
SELECT name FROM student WHERE student_id = '5';
SELECT teacher.name, course.name , section.section_number FROM teacher, course, teaches, section WHERE teacher.teacher_id = teaches.teacher_id AND teaches.course_id = section.course_id AND teaches.course_id = course.course_id;
SELECT teacher.name, course.name , section.section_number FROM teacher, course, teaches, section WHERE teacher.teacher_id = teaches.teacher_id AND teaches.course_id = section.course_id AND teaches.course_id = course.course_id AND section_number='A';

UPDATE section SET section_number = 'B' WHERE course_id = '500';

DELETE FROM teacher WHERE teacher_id = '16';
DELETE FROM teacher WHERE teacher_id = '17';

DELETE FROM student WHERE student_id = '7';
DELETE FROM student WHERE student_id = '6';

SELECT * FROM course;
SELECT * FROM registers;
SELECT * FROM section;
SELECT * FROM student;
SELECT * FROM teaches;
SELECT * FROM teacher;
