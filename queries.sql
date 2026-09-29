set linesize 1000
set pagesize 1000

CREATE TABLE Publisher (
    publisher_id NUMBER PRIMARY KEY,
    name VARCHAR2(100)
);

CREATE TABLE Category (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(50)
);

CREATE TABLE Author (
    author_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50)
);

CREATE TABLE Book (
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(150),
    publisher_id NUMBER,
    category_id NUMBER,
    price NUMBER(8,2),
    FOREIGN KEY (publisher_id) REFERENCES Publisher(publisher_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE BookAuthor (
    book_id NUMBER,
    author_id NUMBER,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (author_id) REFERENCES Author(author_id)
);

CREATE TABLE Copys (
    Copys_id NUMBER PRIMARY KEY,
    book_id NUMBER,
    barcode VARCHAR2(20),
    status VARCHAR2(20),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

CREATE TABLE Member (
    member_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    membership_type VARCHAR2(20)
);

CREATE TABLE Staff (
    staff_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    role VARCHAR2(30)
);

CREATE TABLE Borrow (
    borrow_id NUMBER PRIMARY KEY,
    Copys_id NUMBER,
    member_id NUMBER,
    staff_id NUMBER,
    borrow_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (Copys_id) REFERENCES Copys(Copys_id),
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

INSERT INTO Publisher VALUES (1, 'Red Door');
INSERT INTO Publisher VALUES (2, 'Vhoot bx');
INSERT INTO Publisher VALUES (3, 'Academy of Education');

INSERT INTO Category VALUES (1, 'Fiction');
INSERT INTO Category VALUES (2, 'Technology');
INSERT INTO Category VALUES (3, 'Poetry');

INSERT INTO Author VALUES (1, 'George', 'Faan');
INSERT INTO Author VALUES (2, 'Kazi Nazrul', 'Islam');
INSERT INTO Author VALUES (3, 'Martin', 'fin');

INSERT INTO Book VALUES (1, '1984', 1, 1, 500);
INSERT INTO Book VALUES (2, 'Head First Design Patterns', 2, 2, 1200);
INSERT INTO Book VALUES (3, 'Bidrohi', 3, 3, 300);
INSERT INTO Book VALUES (4, 'Clean Architecture', 2, 2, 1500);
INSERT INTO Book VALUES (5, 'Animal Farm', 1, 1, 1400);

INSERT INTO BookAuthor VALUES (1, 1);
INSERT INTO BookAuthor VALUES (5, 1);
INSERT INTO BookAuthor VALUES (2, 3);
INSERT INTO BookAuthor VALUES (3, 2);
INSERT INTO BookAuthor VALUES (4, 3);

INSERT INTO Copys VALUES (1, 1, 'BC-1', 'AVAILABLE');
INSERT INTO Copys VALUES (2, 1, 'BC-2', 'BORROWED');
INSERT INTO Copys VALUES (3, 2, 'BC-3', 'AVAILABLE');
INSERT INTO Copys VALUES (4, 3, 'BC-4', 'AVAILABLE');
INSERT INTO Copys VALUES (5, 4, 'BC-5', 'BORROWED');
INSERT INTO Copys VALUES (6, 4, 'BC-6', 'AVAILABLE');

INSERT INTO Member VALUES (101, 'Ayesha', 'STUDENT');
INSERT INTO Member VALUES (102, 'Rahim', 'STANDARD');
INSERT INTO Member VALUES (103, 'Karim', 'FACULTY');
INSERT INTO Member VALUES (104, 'Nusrat', 'STUDENT');

INSERT INTO Staff VALUES (1, 'Sultan', 'HEAD LIBRARIAN');

-- Borrow
INSERT INTO Borrow VALUES (1, 2, 101, 1, DATE '2026-09-19', DATE '2026-09-25', NULL);
INSERT INTO Borrow VALUES (2, 5, 103, 1, DATE '2026-09-26', DATE '2026-10-10', NULL);
INSERT INTO Borrow VALUES (3, 3, 102, 1, DATE '2026-09-09', DATE '2026-09-23', DATE '2026-09-21');

--INNER JOIN
SELECT b.title, a.first_name, a.last_name
FROM Book b
INNER JOIN BookAuthor ba ON b.book_id = ba.book_id
INNER JOIN Author a ON ba.author_id = a.author_id;

-- LEFT JOIN
SELECT b.title, bc.Copys_id
FROM Book b
LEFT JOIN Copys bc
ON b.book_id = bc.book_id;

-- RIGHT JOIN
SELECT b.title, bc.Copys_id
FROM Copys bc
RIGHT JOIN Book b ON bc.book_id = b.book_id;

-- FULL JOIN
SELECT b.title, c.category_name
FROM Book b
FULL JOIN Category c
ON b.category_id = c.category_id;

-- 5. Every currently borrowed book
SELECT b.title, m.name AS member_name, s.name AS staff_name, br.due_date
FROM Borrow br
JOIN Copys bc ON br.Copys_id = bc.Copys_id
JOIN Book b ON bc.book_id = b.book_id
JOIN Member m ON br.member_id = m.member_id
JOIN Staff s ON br.staff_id = s.staff_id
WHERE br.return_date IS NULL;

-- 6. Overdue books only
SELECT b.title, m.name AS member_name, br.due_date
FROM Borrow br
JOIN Copys bc ON br.Copys_id = bc.Copys_id
JOIN Book b ON bc.book_id = b.book_id
JOIN Member m ON br.member_id = m.member_id
WHERE br.return_date IS NULL
AND br.due_date < DATE '2026-09-29';

-- 7. Members who have never borrowed anything
SELECT m.name
FROM Member m
LEFT JOIN Borrow br ON m.member_id = br.member_id
WHERE br.borrow_id IS NULL;


SELECT COUNT(*) FROM Book;

SELECT SUM(price) FROM Book;

SELECT AVG(price) FROM Book;

SELECT MAX(price) FROM Book;

SELECT MIN(price) FROM Book;

SELECT category_id, AVG(price) FROM Book GROUP BY category_id;

SELECT category_id, AVG(price) FROM Book GROUP BY category_id HAVING AVG(price) > 500;

-- Create View
CREATE VIEW Book_Author_View AS
SELECT b.title, a.first_name, a.last_name
FROM Book b
JOIN BookAuthor ba ON b.book_id = ba.book_id
JOIN Author a ON ba.author_id = a.author_id;

-- Use View
SELECT * FROM Book_Author_View;

SELECT * FROM Book WHERE category_id IN (1, 2);

SELECT * FROM Book WHERE price > SOME (
    SELECT price FROM Book WHERE category_id = 1
);

SELECT * FROM Book WHERE price > some (
    SELECT price FROM Book WHERE category_id = 2
);

SELECT * FROM Book WHERE price > ALL (
    SELECT price FROM Book WHERE category_id = 3
);

SELECT title FROM Book b WHERE EXISTS (
    SELECT * FROM Copys bc WHERE bc.book_id = b.book_id
);

-- LIKE (%)
SELECT * FROM Book WHERE title LIKE '%Design%';

-- LIKE (_)
SELECT * FROM Author WHERE first_name LIKE '_a%';


-- PL/SQL
BEGIN
    DBMS_OUTPUT.PUT_LINE('Welcome to the Library Management System');
END;
/


-- IF-ELSE
BEGIN
    IF 1200 >= 1000 THEN
        DBMS_OUTPUT.PUT_LINE('Expensive book');
    ELSIF 1200 >= 500 THEN
        DBMS_OUTPUT.PUT_LINE('Moderate book');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cheap book');
    END IF;
END;
/

-- FOR Loop
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('Book Copys number ' || i);
    END LOOP;
END;
/

--  WHILE Loop
BEGIN
    WHILE 1=1 LOOP
        DBMS_OUTPUT.PUT_LINE('Library is open');
        EXIT;
    END LOOP;
END;
/