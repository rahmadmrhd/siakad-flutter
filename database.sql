-- Active: 1700739113891@@127.0.0.1@3307@siakad

DROP DATABASE siakad;

CREATE DATABASE siakad;

USE siakad;

CREATE TABLE
    `user` (
        nim CHAR(10) NOT NULL PRIMARY KEY,
        `password` VARCHAR(50) NOT NULL,
        nama VARCHAR(255) NOT NULL,
        jenis_kelamin CHAR(1) NOT NULL,
        tempat_lahir VARCHAR(100) NOT NULL,
        tanggal_lahir DATE NOT NULL,
        ipk DOUBLE NOT NULL,
        semester TINYINT NOT NULL,
        jurusan VARCHAR(255) NOT NULL,
        token TEXT
    );

INSERT INTO `user`
VALUES (
        '1462200017',
        'rahmad12345',
        'Rahmad Maulana',
        'L',
        'Situbondo',
        '2003-01-08',
        3.65,
        3,
        'Teknik Informatika',
        '01410aee-9f2a-11ee-b32f-4cedfb01a0fa'
    );

CREATE TABLE
    `mata_kuliah` (
        kode VARCHAR(8) NOT NULL PRIMARY KEY,
        nama VARCHAR(100) NOT NULL,
        kelas VARCHAR(3) NOT NULL,
        jadwal TEXT NULL
    );

CREATE TABLE
    `matkul_mhs` (
        nim CHAR(10) NOT NULL,
        kode VARCHAR(8) NOT NULL,
        semester TINYINT NOT NULL,
        progress DOUBLE NOT NULL,
        nilai DOUBLE NOT NULL,
        PRIMARY KEY (nim, kode)
    );

INSERT INTO `mata_kuliah`
VALUES (
        '002102',
        'Pendidikan Patriotisme',
        'W',
        'Jumat, 20:00 - 21:30 ● Ruang L406'
    ), (
        '14620113',
        'Statistik Inferensi',
        'S',
        'Selasa, 19:15 - 21:30 ● Ruang D305'
    ), (
        '14620233',
        'Pengembangan Aplikasi Bergerak',
        'S',
        'Jumat, 17:00 - 19:15 ● Ruang Q304'
    ), (
        '14620133',
        'Kecerdasan Artifisial',
        'S',
        'Kamis, 19:15 - 21:30 ● Ruang Q303'
    ), (
        '14620144',
        'Manajemen Basis Data',
        'S',
        'Senin, 17:45 - 19:15 ● Ruang Q804\nRabu, 17:45 - 19:15 ● Ruang Q804'
    ), (
        '14620154',
        'Sistem Jaringan Komputer',
        'S',
        'Senin, 19:15 - 20:45 ● Ruang Q302\nRabu, 19:15 - 20:45 ● Ruang Q302'
    ), (
        '14620123',
        'Interaksi Manusia Komputer',
        'S',
        'Selasa, 17:00 - 19:15 ● Ruang Q604'
    ), (
        '14620382',
        'Etika Teknologi Informasi',
        'S',
        'Kamis, 17:45 - 19:15 ● Ruang Q302'
    ),
('14620023', 'MATEMATIKA DISKRIT DAN LOGIKA', 'R', NULL),
('14620094', 'MATEMATIKA KOMPUTASI', 'S', NULL),
('14620063', 'GRAF DAN OTOMATA', 'S', NULL),
('14620083', 'ARSITEKTUR DAN ORGANISASI KOMPUTER *', 'R', NULL),
('14620103', 'STRUKTUR DATA DAN ALGORITMA', 'S', NULL),
('000102', 'PENDIDIKAN PANCASILA', 'R', NULL),
('14620074', 'PEMROGRAMAN BERORIENTASI OBJEK FUNGSIONAL', 'S', NULL),
('14620053', 'SISTEM OPERASI', 'R', NULL),
('14620034', 'DASAR-DASAR PEMROGRAMAN*', 'S', NULL),
('14620012', 'PENGANTAR INFORMATIKA', 'R', NULL),
('14620043', 'SISTEM DIGITAL', 'S', NULL),
('000802', 'BAHASA INDONESIA', 'R', NULL),
('000202', 'PENDIDIKAN AGAMA ISLAM', 'S', NULL);

INSERT INTO `matkul_mhs`
VALUES (
        '1462200017',
        '002102',
        3,
        0.65,
        88
    ), (
        '1462200017',
        '14620113',
        3,
        0.7,
        85
    ), ('1462200017', '14620233',
    3, 1, 90), (
        '1462200017',
        '14620133',
        3,
        0.45,
        70
    ), (
        '1462200017',
        '14620144',
        3,
        0.95,
        75
    ), (
        '1462200017',
        '14620154',
        3,
        0.75,
        55
    ), (
        '1462200017',
        '14620123',
        3,
        0.70,
        68
    ), (
        '1462200017',
        '14620382',
        3,
        0.80,
        82
    ),
('1462200017', '14620023', 1, 1, 90),
('1462200017', '14620094', 2, 1, 65),
('1462200017', '14620063', 2, 1, 75),
('1462200017', '14620083', 2, 1, 89),
('1462200017', '14620103', 2, 1, 85),
('1462200017', '000102'  , 1, 1, 84),
('1462200017', '14620074', 2, 1, 82),
('1462200017', '14620053', 1, 1, 80),
('1462200017', '14620034', 1, 1, 90),
('1462200017', '14620012', 1, 1, 85),
('1462200017', '14620043', 1, 1, 88),
('1462200017', '000802'  , 1, 1, 76),
('1462200017', '000202'  , 1, 1, 84);

DROP FUNCTION IF EXISTS login;

DELIMITER $$;

CREATE FUNCTION `login` (`nim` VARCHAR(10), `password` VARCHAR(50)) RETURNS TEXT
READS SQL DATA
BEGIN
    DECLARE `count` INT DEFAULT 0;
    DECLARE new_token TEXT DEFAULT UUID();
    SELECT COUNT(*) INTO `count`
    FROM `user`
    WHERE
        `user`.nim = nim
        AND `user`.password = `password`;
    IF `count` = 0 THEN RETURN NULL;
    ELSE
    UPDATE `user`
    SET `user`.`token` = new_token
    WHERE
        `user`.nim = nim
        AND `user`.password = `password`;
    RETURN new_token;
    END IF;
END $$;
DELIMITER;

DROP FUNCTION IF EXISTS logout;

DELIMITER $$;

CREATE FUNCTION `logout` (`token` TEXT) RETURNS TEXT
READS SQL DATA
BEGIN
    DECLARE `count` INT DEFAULT 0;
    SELECT COUNT(*) INTO `count`
    FROM `user`
    WHERE `user`.token = token;
    IF `count` = 0 THEN RETURN 'failed';
    ELSE
    UPDATE `user`
    SET `user`.`token` = NULL
    WHERE
        `user`.`nim` = `nim`
        AND `user`.password = `password`;
    RETURN 'success';
    END IF;
END $$;

DELIMITER;

-- SELECT * FROM USER;


CREATE OR REPLACE VIEW `nilai_mhs` AS SELECT matkul.`kode`, matkul.`nama`, `n`.`semester`, `n`.`nilai`,
CASE 
  WHEN `n`.`nilai` > 100 THEN 'Not Valid'
  WHEN `n`.`nilai` >= 85 THEN 'A'
  WHEN `n`.`nilai` >= 80 THEN 'A-'
  WHEN `n`.`nilai` >= 75 THEN 'AB'
  WHEN `n`.`nilai` >= 70 THEN 'B+'
  WHEN `n`.`nilai` >= 65 THEN 'B'
  WHEN `n`.`nilai` >= 60 THEN 'B-'
  WHEN `n`.`nilai` >= 55 THEN 'BC'
  WHEN `n`.`nilai` >= 50 THEN 'C+'
  WHEN `n`.`nilai` >= 45 THEN 'C'
  WHEN `n`.`nilai` >= 40 THEN 'C-'
  WHEN `n`.`nilai` >= 35 THEN 'CD'
  WHEN `n`.`nilai` >= 30 THEN 'D'
  WHEN `n`.`nilai` >= 0 THEN 'E'
  ELSE 'Not Valid'
END as 'predikat',
`u`.token
FROM `user` AS u
    LEFT JOIN `matkul_mhs` AS `n` ON `u`.`nim` = `n`.`nim`
    LEFT JOIN `mata_kuliah` AS `matkul` ON `n`.`kode` = `matkul`.`kode`;

SELECT * FROM `nilai_mhs` WHERE
    token = '01410aee-9f2a-11ee-b32f-4cedfb01a0fa';

