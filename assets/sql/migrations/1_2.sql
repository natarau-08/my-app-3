CREATE TABLE tag_tracking (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_id INTEGER NOT NULL,
    starting_date TEXT NOT NULL,
    pinned INTEGER NOT NULL,
    `name` TEXT NOT NULL UNIQUE,
    `description` TEXT,
    created_date TEXT NOT NULL,

    FOREIGN KEY(tag_id) REFERENCES tags(id)
);