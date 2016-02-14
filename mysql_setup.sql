/* Create the Database */
CREATE DATABASE database_name_here;

/* Set up grants for the Database */
GRANT ALL PRIVILEGES ON database_name_here.* TO 'mysql_user_here'@'mysql_clientaddr' IDENTIFIED BY 'mysql_password_here';
GRANT ALL PRIVILEGES ON database_name_here.* TO 'mysql_user_here'@'localhost' IDENTIFIED BY 'mysql_password_here';

/* Remove the Test Database */
/* DROP DATABASE test; */

/* Flush PRIVILEGES */
FLUSH PRIVILEGES;
