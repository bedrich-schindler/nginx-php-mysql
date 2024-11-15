CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'pass';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'pass';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'pass';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
