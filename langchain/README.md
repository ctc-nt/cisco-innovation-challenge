
# QA API
## description

This code provides Web API for answering questions based on text-based knowledge.

It assume that the knowledge files are put under `../knowledge` directory.

## pre requirement

To use Chroma, sqlite3 >= 3.35.0 is required.
If you need to build it by yourself, download source from [here](https://www.sqlite.org/download.html) and follow the instruction.

Run the following code to confirm the sqlite3 version:
```
import sqlite3
print(sqlite3.sqlite_version)
```