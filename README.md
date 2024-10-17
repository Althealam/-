# Database Technology Course Project — Book Borrowing System

## Overview
This repository contains the source code for a **Book Borrowing System**, developed as a final project for my **Database Technology** course during my undergraduate studies. The system implements a library book borrowing system using SQL, featuring various stored functions, views, and triggers to handle borrowing records, overdue calculations, and borrowing limits.

## Project Structure
The project is composed of the following files:

- **`table.sql`**: SQL script to create the necessary database tables for managing borrowers, books, and borrowing records.
- **`function.sql`**: Contains stored functions and procedures to handle book borrowing and returning, overdue calculations, and user limits.

## Data Tables
The system uses three main tables:
1. **Borrower**: Stores borrower information such as ID, name, category (teacher or student), number of books borrowed, and phone number.
2. **Book**: Stores book details including ID, title, category, and whether the book is currently borrowed.
3. **Borrowing Information**: Stores borrowing records with fields such as borrower ID, book ID, borrow date, calculated due date, and actual return date.

## Features
1. **Overdue Borrowing View**: Displays all overdue borrowings, including borrower name, category, book title, borrow date, due date, and overdue duration.
2. **Borrow Book Procedure**: Adds a new record to the borrowing information table each time a book is borrowed.
3. **Return Book Procedure**: Updates the relevant borrowing record when a book is returned.
4. **Find Borrower by Book**: A function that retrieves the borrower's name using the book ID, allowing queries for borrowed books by specific users, such as 'Zhang San'.
5. **Calculate Borrowing Limit**: A function to calculate how many more books a borrower can borrow. The limit is 5 books for students and 10 for teachers.
6. **Overdue Duration Function**: Queries how long a book has been overdue, and sorts overdue books by duration, showing the book title, borrower, and overdue length.
7. **Check Overdue Books**: A function to retrieve the number of overdue books for each borrower and display borrowers with overdue books and their counts.
8. **Fine Calculation**: A cursor-based function that calculates overdue fines based on the length of the overdue period, where the fine is ¥1 for up to 30 days, ¥3 for up to 90 days, and ¥5 for over 90 days. It displays the borrower’s name, fine amount, and contact information.
9. **Update Borrow Count Trigger**: A trigger that updates the number of books borrowed in the borrower table whenever a book is borrowed or returned.
10. **Borrowing Limit Trigger**: A trigger that prevents borrowers from borrowing more books once they reach their borrowing limit.

## How to Use
1. First, run `table.sql` to create the required tables in your database.
2. Then, execute `function.sql` to create the views, stored procedures, functions, and triggers for managing the book borrowing system.

## Contact
For further inquiries, feel free to reach out
