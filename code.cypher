// Create unique constraints for id's in each node
CREATE CONSTRAINT book_id_unique IF NOT EXISTS
FOR (book:Book) REQUIRE book.bookID IS UNIQUE;

CREATE CONSTRAINT author_id_unique IF NOT EXISTS
FOR (author:Author) REQUIRE author.authorID IS UNIQUE;

CREATE CONSTRAINT genre_id_unique IF NOT EXISTS
FOR (genre:Genre) REQUIRE genre.genreID IS UNIQUE;

CREATE CONSTRAINT user_id_unique IF NOT EXISTS
FOR (user:User) REQUIRE user.userID IS UNIQUE;

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

// WRITTEN_BY relationships
MATCH (b1:Book {title: 'Murder on the Orient Express'}), (a1:Author {name: 'Dame Agatha Christie'})
MERGE (b1)-[:WRITTEN_BY]->(a1);

MATCH (b2:Book {title: '1984'}), (a2:Author {name: 'George Orwell'})
MERGE (b2)-[:WRITTEN_BY]->(a2);

MATCH (b3:Book {title: 'The Great Gatsby'}), (a4:Author {name: 'F. Scott Fitzgerald'})
MERGE (b3)-[:WRITTEN_BY]->(a4);

MATCH (b4:Book {title: 'Harry Potter and the Philosopher\'s Stone'}), (a3:Author {name: 'J. K. Rowling'})
MERGE (b4)-[:WRITTEN_BY]->(a3);

// BELONGS_TO relationships
MATCH (b1:Book {title: 'Murder on the Orient Express'}), (g1:Genre {genreName: 'Crime'})
MERGE (b1)-[:BELONGS_TO]->(g1);

MATCH (b2:Book {title: '1984'}), (g2:Genre {genreName: 'Dystopian'})
MERGE (b2)-[:BELONGS_TO]->(g2);

MATCH (b3:Book {title: 'The Great Gatsby'}), (g4:Genre {genreName: 'Tragedy'})
MERGE (b3)-[:BELONGS_TO]->(g4);

MATCH (b4:Book {title: 'Harry Potter and the Philosopher\'s Stone'}), (g3:Genre {genreName: 'Fantasy'})
MERGE (b4)-[:BELONGS_TO]->(g3);

// READ relationships
MATCH (u1:User {name: 'Sebastian'}), (b1:Book {title: 'Murder on the Orient Express'}), (b2:Book {title: '1984'})
MERGE (u1)-[:READ]->(b1)
MERGE (u1)-[:READ]->(b2);

MATCH (u2:User {name: 'Veronika'}), (b3:Book {title: 'The Great Gatsby'}), (b4:Book {title: 'Harry Potter and the Philosopher\'s Stone'})
MERGE (u2)-[:READ]->(b3)
MERGE (u2)-[:READ]->(b4);

MATCH (u3:User {name: 'Jesper'}), (b1:Book {title: 'Murder on the Orient Express'}), (b3:Book {title: 'The Great Gatsby'})
MERGE (u3)-[:READ]->(b1)
MERGE (u3)-[:READ]->(b3);

MATCH (u4:User {name: 'Elon'}), (b2:Book {title: '1984'}), (b4:Book {title: 'Harry Potter and the Philosopher\'s Stone'})
MERGE (u4)-[:READ]->(b2)
MERGE (u4)-[:READ]->(b4);

// FRIENDS_WITH relationships
MATCH (u1:User {name: 'Sebastian'}), (u2:User {name: 'Veronika'}), (u3:User {name: 'Jesper'})
MERGE (u1)-[:FRIENDS_WITH]->(u2)
MERGE (u1)-[:FRIENDS_WITH]->(u3);

MATCH (u2:User {name: 'Veronika'}), (u4:User {name: 'Elon'})
MERGE (u2)-[:FRIENDS_WITH]->(u4);

MATCH (u3:User {name: 'Jesper'}), (u4:User {name: 'Elon'})
MERGE (u3)-[:FRIENDS_WITH]->(u4);

// Show all nodes and relationships
MATCH (n) RETURN n;

// Delete all nodes and relationships
// MATCH (n) DETACH DELETE n;
