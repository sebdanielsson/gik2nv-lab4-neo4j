// --- CONSTRAINTS --- //

// Create unique constraints for id's in each node
CREATE CONSTRAINT book_id_unique IF NOT EXISTS
FOR (book:Book) REQUIRE book.bookID IS UNIQUE;

CREATE CONSTRAINT author_id_unique IF NOT EXISTS
FOR (author:Author) REQUIRE author.authorID IS UNIQUE;

CREATE CONSTRAINT genre_id_unique IF NOT EXISTS
FOR (genre:Genre) REQUIRE genre.genreID IS UNIQUE;

CREATE CONSTRAINT user_id_unique IF NOT EXISTS
FOR (user:User) REQUIRE user.userID IS UNIQUE;

// Require a rating and date for finish reading the book. (Requires enterprise edition)
CREATE CONSTRAINT read_date_exists IF NOT EXISTS
FOR ()-[r:READ]-()
REQUIRE r.dateRead IS NOT NULL;

CREATE CONSTRAINT rating_exists IF NOT EXISTS
FOR ()-[r:READ]-()
REQUIRE r.rating IS NOT NULL;

// --- LABELS --- //

// Create Author nodes
CREATE
       (a1:Author {authorID: 1, name: 'Dame Agatha Christie', gender: 'Female'}),
       (a2:Author {authorID: 2, name: 'George Orwell', gender: 'Male'}),
       (a3:Author {authorID: 3, name: 'J. K. Rowling', gender: 'Female'}),
       (a4:Author {authorID: 4, name: 'F. Scott Fitzgerald', gender: 'Male'});

// Create Book nodes
CREATE
       (b1:Book {bookID: 1, title: 'Murder on the Orient Express', publicationYear: 1934}),
       (b2:Book {bookID: 2, title: '1984', publicationYear: 1949}),
       (b3:Book {bookID: 3, title: 'The Great Gatsby', publicationYear: 1925}),
       (b4:Book {bookID: 4, title: 'Harry Potter and the Philosopher\'s Stone', publicationYear: 1997});

// Create Genre nodes
CREATE
       (g1:Genre {genreID: 1, genreName: 'Crime'}),
       (g2:Genre {genreID: 2, genreName: 'Dystopian'}),
       (g3:Genre {genreID: 3, genreName: 'Fantasy'}),
       (g4:Genre {genreID: 4, genreName: 'Tragedy'});

// Create User nodes
CREATE (u1:User {userID: 1, name: 'Sebastian', birthYear: 1994, gender: 'Male'}),
       (u2:User {userID: 2, name: 'Veronika', birthYear: 1987, gender: 'Female'}),
       (u3:User {userID: 3, name: 'Jesper', birthYear: 1990, gender: 'Male'}),
       (u4:User {userID: 4, name: 'Elon', birthYear: 1971, gender: 'Male'});

// --- RELATIONSHIPS --- //

// WRITTEN_BY relationships
MATCH (b1:Book {title: 'Murder on the Orient Express'})
MATCH (a1:Author {name: 'Dame Agatha Christie'})
MERGE (b1)-[:WRITTEN_BY]->(a1);

MATCH (b2:Book {title: '1984'})
MATCH (a2:Author {name: 'George Orwell'})
MERGE (b2)-[:WRITTEN_BY]->(a2);

MATCH (b3:Book {title: 'The Great Gatsby'})
MATCH (a4:Author {name: 'F. Scott Fitzgerald'})
MERGE (b3)-[:WRITTEN_BY]->(a4);

MATCH (b4:Book {title: 'Harry Potter and the Philosopher\'s Stone'})
MATCH (a3:Author {name: 'J. K. Rowling'})
MERGE (b4)-[:WRITTEN_BY]->(a3);

// BELONGS_TO relationships
MATCH (b1:Book {title: 'Murder on the Orient Express'})
MATCH (g1:Genre {genreName: 'Crime'})
MERGE (b1)-[:BELONGS_TO]->(g1);

MATCH (b2:Book {title: '1984'})
MATCH (g2:Genre {genreName: 'Dystopian'})
MERGE (b2)-[:BELONGS_TO]->(g2);

MATCH (b3:Book {title: 'The Great Gatsby'})
MATCH (g4:Genre {genreName: 'Tragedy'})
MERGE (b3)-[:BELONGS_TO]->(g4);

MATCH (b4:Book {title: 'Harry Potter and the Philosopher\'s Stone'})
MATCH (g3:Genre {genreName: 'Fantasy'})
MERGE (b4)-[:BELONGS_TO]->(g3);

// READ relationships
MATCH (u1:User {name: 'Sebastian'})
MATCH (b1:Book {title: 'Murder on the Orient Express'})
MERGE (u1)-[:READ {dateRead: date('2023-03-10'), rating: 2}]->(b1);

MATCH (u1:User {name: 'Sebastian'})
MATCH (b2:Book {title: '1984'})
MERGE (u1)-[:READ {dateRead: date('2023-08-01'), rating: 5}]->(b2);

MATCH (u2:User {name: 'Veronika'})
MATCH (b3:Book {title: 'The Great Gatsby'})
MERGE (u2)-[:READ {dateRead: date('2023-07-10'), rating: 3}]->(b3);

MATCH (u2:User {name: 'Veronika'})
MATCH (b4:Book {title: 'Harry Potter and the Philosopher\'s Stone'})
MERGE (u2)-[:READ {dateRead: date('2023-05-23'), rating: 1}]->(b4);

MATCH (u3:User {name: 'Jesper'})
MATCH (b1:Book {title: 'Murder on the Orient Express'})
MERGE (u3)-[:READ {dateRead: date('2023-12-20'), rating: 5}]->(b1);

MATCH (u3:User {name: 'Jesper'})
MATCH (b3:Book {title: 'The Great Gatsby'})
MERGE (u3)-[:READ {dateRead: date('2023-09-14'), rating: 4}]->(b3);

MATCH (u4:User {name: 'Elon'})
MATCH (b2:Book {title: '1984'})
MERGE (u4)-[:READ {dateRead: date('2023-01-29'), rating: 5}]->(b2);

MATCH (u4:User {name: 'Elon'})
MATCH (b4:Book {title: 'Harry Potter and the Philosopher\'s Stone'})
MERGE (u4)-[:READ {dateRead: date('2023-10-10'), rating: 4}]->(b4);

// FRIENDS_WITH relationships
MATCH (u1:User {name: 'Sebastian'})
MATCH (u2:User {name: 'Veronika'})
MERGE (u1)-[:FRIENDS_WITH]->(u2);

MATCH (u1:User {name: 'Sebastian'})
MATCH (u3:User {name: 'Jesper'})
MERGE (u1)-[:FRIENDS_WITH]->(u3);

MATCH (u2:User {name: 'Veronika'})
MATCH (u4:User {name: 'Elon'})
MERGE (u2)-[:FRIENDS_WITH]->(u4);

MATCH (u3:User {name: 'Jesper'})
MATCH (u4:User {name: 'Elon'})
MERGE (u3)-[:FRIENDS_WITH]->(u4);

// --- QUERIES --- //

// Q1: Books read by Sebastian
MATCH (u:User)-[r:READ]->(b:Book)
WHERE u.name = 'Sebastian'
RETURN b.title, r.dateRead, r.rating
ORDER BY r.dateRead DESC;

// Q2: Books written by Dame Agatha Christie
MATCH (b:Book)-[:WRITTEN_BY]->(a:Author)
WHERE a.name = 'Dame Agatha Christie'
OPTIONAL MATCH (b)<-[r:READ]-()
RETURN b.title, b.publicationYear, AVG(r.rating) AS meanRating, COUNT(r) AS readers
ORDER BY b.publicationYear;

// Q3A: Top 10 trending books with males last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (b:Book)<-[r:READ]-(u:User)
WHERE u.gender = 'Male' AND r.dateRead >= lastMonthDate
RETURN b.title, COUNT(r) AS maleReaders, 'Male' AS gender
ORDER BY maleReaders DESC
LIMIT 10;

// Q3B: Top 10 trending books with females last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (b:Book)<-[r:READ]-(u:User)
WHERE u.gender = 'Female' AND r.dateRead >= lastMonthDate
RETURN b.title, COUNT(r) AS femaleReaders, 'Female' AS gender
ORDER BY femaleReaders DESC
LIMIT 10;

// Q4A: Top 10 top-rated books by males from the last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (b:Book)<-[r:READ]-(u:User)
WHERE u.gender = 'Male' AND r.dateRead >= lastMonthDate
RETURN b.title, AVG(r.rating) AS avgMaleRating, 'Male' AS gender
ORDER BY avgMaleRating DESC
LIMIT 10;

// Q4B: Top 10 top-rated books by females from the last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (b:Book)<-[r:READ]-(u:User)
WHERE u.gender = 'Female' AND r.dateRead >= lastMonthDate
RETURN b.title, AVG(r.rating) AS avgFemaleRating, 'Female' AS gender
ORDER BY avgFemaleRating DESC
LIMIT 10;

// Q5: Top 10 trending books in the Fantasy genre from the last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (b:Book)-[:BELONGS_TO]->(g:Genre), (u:User)-[r:READ]->(b)
WHERE g.genreName = 'Fantasy' AND r.dateRead >= lastMonthDate
RETURN b.title, COUNT(r) AS readers
ORDER BY readers DESC
LIMIT 10;

// Q6: Top 10 top-rated books in the Fantasy genre from the last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (b:Book)-[:BELONGS_TO]->(g:Genre), (u:User)-[r:READ]->(b)
WHERE g.genreName = 'Fantasy' AND r.dateRead >= lastMonthDate
RETURN b.title, AVG(r.rating) AS avgRating
ORDER BY avgRating DESC
LIMIT 10;

// Q7: Top 10 trending books among millennials from the last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (u:User)-[r:READ]->(b:Book)
WHERE date(r.dateRead) >= lastMonthDate
  AND u.birthYear >= 1981 AND u.birthYear <= 1996

RETURN b.title, count(r) AS reads
ORDER BY reads DESC
LIMIT 10;

// Q8: Top 10 top-rated books among millennials from the last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (u:User)-[r:READ]->(b:Book)
WHERE date(r.dateRead) >= lastMonthDate
  AND u.birthYear >= 1981 AND u.birthYear <= 1996

RETURN b.title, AVG(r.rating) AS avgRating
ORDER BY avgRating DESC
LIMIT 10;

// Q9: Top 10 trending books among a user's friends from the last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (u:User)-[:FRIENDS_WITH]->(f:User)-[r:READ]->(b:Book)
WHERE u.name = 'Sebastian' AND r.dateRead >= lastMonthDate
RETURN b.title, COUNT(f) AS friendsReads
ORDER BY friendsReads DESC
LIMIT 10;

// Q10: Top 10 top-rated books among a user's friends from the last month
WITH date() - duration('P1M') AS lastMonthDate

MATCH (u:User)-[:FRIENDS_WITH]->(f:User)-[r:READ]->(b:Book)
WHERE u.name = 'Sebastian' AND r.dateRead >= lastMonthDate
RETURN b.title, AVG(r.rating) AS avgRating
ORDER BY avgRating DESC
LIMIT 10;
