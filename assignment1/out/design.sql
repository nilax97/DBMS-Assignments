CREATE TABLE student (
  student_id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE course (
  course_id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255)
);

-- ALTER TABLE course
--     ADD CONSTRAINT check_sec FOREIGN KEY (section_number, course_id) REFERENCES section(section_number, course_id) DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE section (
  section_number VARCHAR(255) NOT NULL,
  course_id VARCHAR(255) NOT NULL,
  CONSTRAINT section_sec_co_id_PK PRIMARY KEY (section_number, course_id),
  CONSTRAINT section_course_id_FK FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE cascade,
  CONSTRAINT chk_Section CHECK (section_number IN ('A', 'B', 'C', 'D'))
);


CREATE TABLE teacher (
  teacher_id VARCHAR(255) PRIMARY KEY,
  name       VARCHAR(255)
);

CREATE TABLE teaches (
  course_id VARCHAR(255) NOT NULL,
  teacher_id VARCHAR(255) NOT NULL,
  CONSTRAINT teaches_PK PRIMARY KEY (course_id, teacher_id),
  CONSTRAINT teaches_course_id_FK FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE cascade,
  CONSTRAINT teaches_teacher_id_FK FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id) ON DELETE cascade
);



CREATE TABLE registers (
  student_id VARCHAR(255) NOT NULL,
  course_id VARCHAR(255) NOT NULL,
  CONSTRAINT registers_st_co_id_PK PRIMARY KEY (student_id, course_id),
  CONSTRAINT registers_student_id_FK FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE cascade,
  CONSTRAINT teaches_course_id_FK FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE cascade
);
