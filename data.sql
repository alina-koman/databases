SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS kindergartens;
CREATE SCHEMA IF NOT EXISTS kindergartens DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kindergartens;

CREATE TABLE IF NOT EXISTS addresses (
  address_id INT NOT NULL AUTO_INCREMENT,
  city VARCHAR(100) NOT NULL,
  district VARCHAR(100) NULL DEFAULT NULL,
  street VARCHAR(150) NULL DEFAULT NULL,
  building VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (address_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS kindergartens (
  kindergarten_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  address_id INT NOT NULL,
  phone VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (kindergarten_id),
  INDEX fk_kindergarten_address_idx (address_id ASC) VISIBLE,
  CONSTRAINT fk_kindergarten_address
    FOREIGN KEY (address_id)
    REFERENCES addresses (address_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS positions (
  position_id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  PRIMARY KEY (position_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS employees (
  employee_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  email VARCHAR(255) NULL,
  phone_number VARCHAR(30) NULL,
  hire_date DATE NOT NULL,
  fire_date DATE NULL DEFAULT NULL,
  kindergarten_id INT NOT NULL,
  PRIMARY KEY (employee_id),
  UNIQUE INDEX uq_email_idx (email ASC) VISIBLE,
  INDEX fk_employee_kindergarten_idx (kindergarten_id ASC) VISIBLE,
  CONSTRAINT fk_employee_kindergarten
    FOREIGN KEY (kindergarten_id)
    REFERENCES kindergartens (kindergarten_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS employee_positions (
  employee_id INT NOT NULL,
  position_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NULL,
  PRIMARY KEY (employee_id, position_id, start_date),
  CONSTRAINT fk_emp_pos_employee
    FOREIGN KEY (employee_id)
    REFERENCES employees (employee_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_emp_pos_position
    FOREIGN KEY (position_id)
    REFERENCES positions (position_id)
    ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS salaries (
  employee_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NULL DEFAULT NULL,
  PRIMARY KEY (employee_id, start_date),
  CONSTRAINT fk_salary_employee
    FOREIGN KEY (employee_id)
    REFERENCES employees (employee_id)
    ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS bonuses (
  bonus_id INT NOT NULL AUTO_INCREMENT,
  employee_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  bonus_date DATE NOT NULL,
  PRIMARY KEY (bonus_id),
  CONSTRAINT fk_bonus_employee
    FOREIGN KEY (employee_id)
    REFERENCES employees (employee_id)
    ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS children (
  child_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  birth_date DATE NOT NULL,
  PRIMARY KEY (child_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS parents (
  parent_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  phone_number VARCHAR(30) NOT NULL,
  email VARCHAR(255) NULL,
  PRIMARY KEY (parent_id),
  UNIQUE INDEX uq_parent_phone_idx (phone_number ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS child_parents (
  child_id INT NOT NULL,
  parent_id INT NOT NULL,
  relation_type VARCHAR(50) NULL DEFAULT 'Батько/Мати',
  PRIMARY KEY (child_id, parent_id),
  CONSTRAINT fk_child_parents_child
    FOREIGN KEY (child_id)
    REFERENCES children (child_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_child_parents_parent
    FOREIGN KEY (parent_id)
    REFERENCES parents (parent_id)
    ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS child_groups (
  group_id INT NOT NULL AUTO_INCREMENT,
  kindergarten_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  PRIMARY KEY (group_id),
  CONSTRAINT fk_group_kindergarten
    FOREIGN KEY (kindergarten_id)
    REFERENCES kindergartens (kindergarten_id)
    ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS child_enrollment (
  child_id INT NOT NULL,
  group_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NULL DEFAULT NULL,
  from_kindergarten_id INT NULL DEFAULT NULL,
  transfer_date DATE NULL DEFAULT NULL,
  PRIMARY KEY (child_id, group_id, start_date),
  CONSTRAINT fk_enrollment_child
    FOREIGN KEY (child_id)
    REFERENCES children (child_id),
  CONSTRAINT fk_enrollment_group
    FOREIGN KEY (group_id)
    REFERENCES child_groups (group_id),
  CONSTRAINT fk_enrollment_from_kindergarten
    FOREIGN KEY (from_kindergarten_id)
    REFERENCES kindergartens (kindergarten_id)
) ENGINE = InnoDB;


INSERT INTO addresses (city, district, street, building) VALUES
('Львів', 'Шевченківський', 'вул. Промислова', '50/52'),
('Львів', 'Галицький', 'вул. Зелена', '10'),
('Львів', 'Шевченківський', 'вул. Мазепи', '15'),
('Київ', 'Печерський', 'бул. Лесі Українки', '24'),
('Львів', 'Франківський', 'вул. Наукова', '7А'),
('Львів', 'Сихівський', 'просп. Червоної Калини', '60'),
('Харків', 'Київський', 'вул. Пушкінська', '79'),
('Львів', 'Залізничний', 'вул. Городоцька', '300'),
('Львів', 'Шевченківський', 'просп. Чорновола', '45А');

INSERT INTO kindergartens (name, address_id, phone) VALUES
('ДНЗ №1 "Сонечко"', 1, '032-293-01-02'),
('ДНЗ №5 "Дзвіночок"', 2, '032-276-55-11'),
('ДНЗ №12 "Калинка"', 3, '032-252-18-20'),
('ДНЗ №101 "Веселка"', 5, '032-245-67-89'),
('НВК "Школа-садок "Провесінь"', 6, '032-222-33-44'),
('Київський ДНЗ №7 "Зірочка"', 4, '044-123-45-67'),
('Харківський ДНЗ №3 "Теремок"', 7, '057-700-50-60'),
('ДНЗ №25 "Лісова казка"', 8, '032-292-88-44'),
('ДНЗ №155 "Барвінок"', 9, '032-244-11-22');

INSERT INTO child_groups (kindergarten_id, name) VALUES
(1, 'Ясельна'), (1, 'Молодша А'), (1, 'Молодша Б'), (1, 'Середня'), (1, 'Старша А'), (1, 'Старша Б'),
(2, 'Молодша'), (2, 'Старша'),
(3, 'Змішана'),
(4, 'Група "Бджілки"'), (4, 'Група "Метелики"'),
(5, '1-А клас (шкільний)'), (5, 'Старша група "Ромашка"'),
(6, 'Ясла "Капітошка"'), (6, 'Середня група'),
(7, 'Ясельна група'), (7, 'Молодша група'), (7, 'Старша група'),
(8, 'Група "Гномики"'), (8, 'Група "Совенята"'), (8, 'Група "Їжачки"'),
(9, 'Група "Дзвіночки"'), (9, 'Група "Соняшники"'), (9, 'Група "Капітошки"'), (9, 'Група "Чому-сики"'), (9, 'Група "Пізнайки"'), (9, 'Група "Знайки"');

INSERT INTO positions (title) VALUES
('Завідувач'), ('Вихователь'), ('Няня'),
('Музичний керівник'), ('Кухар'), ('Медсестра'),
('Психолог'), ('Логопед'), ('Завгосп'), ('Двірник');

INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, fire_date, kindergarten_id) VALUES
('Олена', 'Петренко', 'o.petrenko@sonce.ua', '0501112233', '2018-08-20', NULL, 1),
('Ірина', 'Іванова', 'i.ivanova@sonce.ua', '0502223344', '2020-09-01', NULL, 1),
('Марія', 'Сидоренко', 'm.sydorenko@dzvin.ua', '0673334455', '2019-03-15', NULL, 2),
('Василь', 'Коваль', 'v.koval@sonce.ua', '0934445566', '2021-01-10', NULL, 1),
('Ганна', 'Шевченко', 'a.shevchenko@sonce.ua', '0505556677', '2022-05-20', NULL, 1),
('Тетяна', 'Григоренко', 't.hryhorenko@dzvin.ua', '0676667788', '2017-05-10', NULL, 2),
('Оксана', 'Лисенко', 'o.lysenko@sonce.ua', '0507778899', '2021-08-25', NULL, 1),
('Сергій', 'Вовк', 's.vovk@dzvin.ua', '0678889900', '2023-02-01', NULL, 2),
('Вікторія', 'Мельник', 'v.melnyk@veselka.ua', '0939990011', '2020-11-11', NULL, 4),
('Андрій', 'Павленко', 'a.pavlenko@veselka.ua', '0930001122', '2019-01-15', '2024-06-30', 4),
('Юлія', 'Захарченко', 'y.zakharchenko@zirochka.kiev.ua', '0441112233', '2022-09-01', NULL, 6),
('Наталія', 'Бондар', 'n.bondar@kazka.lviv.ua', '0502223344', '2019-08-15', NULL, 8),
('Ігор', 'Савченко', 'i.savchenko@kazka.lviv.ua', '0673334455', '2023-09-01', NULL, 8),
('Світлана', 'Романюк', 's.romaniuk@sonce.ua', '0504445566', '2021-04-12', NULL, 1),
('Ольга', 'Попова', 'o.popova@teremok.kh.ua', '0575556677', '2022-10-03', NULL, 7),
('Денис', 'Мороз', 'd.moroz@kazka.lviv.ua', '0936667788', '2024-01-20', NULL, 8);

INSERT INTO employee_positions (employee_id, position_id, start_date) VALUES
(1, 1, '2018-08-20'),
(2, 2, '2020-09-01'),
(3, 2, '2019-03-15'),
(4, 3, '2021-01-10'),
(5, 2, '2022-05-20'),
(6, 1, '2017-05-10'),
(7, 4, '2021-08-25'),
(7, 2, '2023-01-01'),
(8, 5, '2023-02-01'),
(9, 2, '2020-11-11'),
(10, 2, '2019-01-15'),
(11, 2, '2022-09-01'),
(12, 1, '2019-08-15'),
(13, 2, '2023-09-01'),
(14, 6, '2021-04-12'),
(15, 2, '2022-10-03'),
(16, 3, '2024-01-20');

INSERT INTO salaries (employee_id, amount, start_date, end_date) VALUES
(1, 15000.00, '2022-01-01', NULL), (2, 9000.00, '2022-01-01', NULL), (3, 9200.00, '2022-01-01', NULL),
(4, 7500.00, '2022-01-01', NULL), (5, 9100.00, '2022-01-01', NULL), (6, 14500.00, '2021-01-01', NULL),
(7, 8500.00, '2021-09-01', NULL), (8, 8000.00, '2023-02-01', NULL), (9, 9300.00, '2022-01-01', NULL),
(10, 8800.00, '2022-01-01', '2024-06-30'), (11, 10500.00, '2022-09-01', NULL), (12, 14800.00, '2021-01-01', NULL),
(13, 9050.00, '2023-09-01', NULL), (14, 10200.00, '2021-05-01', NULL), (15, 9800.00, '2022-10-03', NULL),
(16, 7600.00, '2024-02-01', NULL);

INSERT INTO bonuses (employee_id, amount, bonus_date) VALUES
(2, 1000.00, '2025-10-15'), (3, 1200.00, '2025-10-15'), (1, 2000.00, '2025-09-30'),
(5, 900.00, '2025-10-15'), (9, 1100.00, '2025-10-10'), (6, 1500.00, '2025-08-20'),
(12, 1800.00, '2025-09-30'), (14, 1000.00, '2025-10-15');

INSERT INTO children (first_name, last_name, birth_date) VALUES
('Іван', 'Мельник', '2020-05-10'), ('Анна', 'Кравчук', '2021-01-20'), ('Петро', 'Поліщук', '2020-11-30'),
('Софія', 'Гончаренко', '2021-02-15'), ('Максим', 'Ткаченко', '2022-01-05'), ('Дарина', 'Ко-валенко', '2021-07-18'),
('Олександр', 'Бондаренко', '2020-09-01'), ('Єва', 'Швець', '2022-03-22'), ('Тимофій', 'Мар-ченко', '2021-12-11'),
('Владислав', 'Шевчук', '2022-05-19'), ('Вікторія', 'Пономаренко', '2021-04-02'), ('Ар-тем', 'Василенко', '2020-10-10'),
('Марія', 'Ковальчук', '2022-08-30'), ('Дмитро', 'Семенюк', '2021-06-25');

INSERT INTO parents (first_name, last_name, phone_number, email) VALUES
('Андрій', 'Мельник', '0501234567', 'a.melnyk@gmail.com'),
('Олена', 'Мельник', '0501234568', 'o.melnyk@gmail.com'),
('Сергій', 'Кравчук', '0671112233', 's.kravchuk@ukr.net'),
('Віктор', 'Поліщук', '0932223344', 'v.polishchuk@gmail.com'),
('Ірина', 'Поліщук', '0932223345', 'i.polishchuk@gmail.com'),
('Тетяна', 'Гончаренко', '0503334455', 't.honcharenko@gmail.com'),
('Олег', 'Ткаченко', '0504445566', 'o.tkachenko@gmail.com'),
('Ольга', 'Бондаренко', '0675556677', 'o.bondarenko@ukr.net'),
('Олександр', 'Василенко', '0936667788', 'o.vasylenko@gmail.com'),
('Марина', 'Василенко', '0936667789', 'm.vasylenko@gmail.com');

INSERT INTO child_parents (child_id, parent_id, relation_type) VALUES
(1, 1, 'Батько'), (1, 2, 'Мати'),
(2, 3, 'Батько'),
(3, 4, 'Батько'), (3, 5, 'Мати'),
(4, 6, 'Мати'),
(5, 7, 'Батько'),
(7, 8, 'Мати'),
(12, 9, 'Батько'), (12, 10, 'Мати');

INSERT INTO child_enrollment (child_id, group_id, start_date, end_date, from_kindergarten_id, transfer_date) VALUES
(1, 2, '2023-09-01', NULL, NULL, NULL),
(2, 7, '2024-09-01', NULL, NULL, NULL),
(3, 7, '2023-09-01', '2025-08-31', NULL, NULL),
(3, 4, '2025-09-01', NULL, 2, '2025-09-01'),
(4, 10, '2024-09-01', NULL, NULL, NULL),
(5, 1, '2025-09-01', NULL, NULL, NULL),
(6, 11, '2025-09-01', NULL, NULL, NULL),
(7, 8, '2023-09-01', '2024-08-31', NULL, NULL),
(7, 5, '2024-09-01', NULL, 2, '2024-09-01'),
(8, 14, '2025-09-01', NULL, NULL, NULL),
(9, 8, '2025-09-01', NULL, NULL, NULL),
(10, 19, '2025-09-01', NULL, NULL, NULL),
(11, 20, '2024-09-01', NULL, NULL, NULL),
(12, 16, '2023-09-01', '2025-08-31', NULL, NULL),
(12, 21, '2025-09-01', NULL, 7, '2025-09-01'),
(13, 1, '2025-09-10', NULL, NULL, NULL),
(14, 17, '2024-09-01', NULL, NULL, NULL);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;