-- SQLBook: Code
INSERT INTO `base` VALUES
('PATRA_BASE1', ST_GeomFromText('POINT(38.2441 21.7346)'));

INSERT INTO `user` VALUES
('stavros_paraskevopoulos', '123456789', 'Stavros', 'Paraskevopoulos', 6945896985),
('natassa_politi', '123456789', 'Natassa', 'Politi', 6996851234),
('foivos_rigopoulos', '123456789', 'Foivos', 'Rigopoulos', 6987962153),
('niki_petratou', '123456789', 'Niki', 'Petratou', 6974125637),
('sotiris_pavlopoulos', '123456789', 'Sotiris', 'Pavlopoulos', 6996453207),
('antonis_sarafis', '123456789', 'Antonis', 'Sarafis', 6901025698),
('marios_raftopoulos', '123456789', 'Marios', 'Raftopoulos', 6990304058),
('vasia_alexiou', '123456789', 'Vasia', 'Alexiou', 6945805123),
('lydia_loukakou', '123456789', 'Lydia', 'Loukakou', 6975960148),
('nikos_kalogeropoulos', '123456789', 'Nikos', 'Kalogeropoulos', 6996453218),
('alexandros_apostolou', '123456789', 'Alexandros', 'Apostolou', 6985843201),
('thanos_kostopoulos', '123456789', 'Thanos', 'Kostopoulos', 6996430188),
('panagiota_milona', '123456789', 'Panagiota', 'Milona', 6996323544);

INSERT INTO `admin` VALUES
('stavros_paraskevopoulos', 'PATRA_BASE1');

INSERT INTO `rescuer` VALUES
('natassa_politi', 'AXY8965', ST_GeomFromText('POINT(38.2496 21.7415)'), 'PATRA_BASE1'),
('foivos_rigopoulos', 'KTL8963', ST_GeomFromText('POINT(38.2474 21.7406)'), 'PATRA_BASE1'),
('niki_petratou', 'RTK7541', ST_GeomFromText('POINT(38.2555 21.7438)'), 'PATRA_BASE1'),
('sotiris_pavlopoulos', 'GTD8563', ST_GeomFromText('POINT(38.2416 21.7356)'), 'PATRA_BASE1'),
('antonis_sarafis', 'PLE8456', ST_GeomFromText('POINT(38.2401 21.7292)'), 'PATRA_BASE1');

INSERT INTO `citizen` VALUES
('marios_raftopoulos', ST_GeomFromText('POINT(38.2516 21.7422)')),
('vasia_alexiou', ST_GeomFromText('POINT(38.2549 21.7404)')),
('lydia_loukakou', ST_GeomFromText('POINT(38.2397 21.7402)')),
('nikos_kalogeropoulos', ST_GeomFromText('POINT(38.2432 21.7282)')),
('alexandros_apostolou', ST_GeomFromText('POINT(38.2418 21.7435)')),
('thanos_kostopoulos', ST_GeomFromText('POINT(38.2569 21.7451)')),
('panagiota_milona', ST_GeomFromText('POINT(38.2497 21.7373)'));

/*INSERT INTO `cargo` VALUES
('AXY8965', 1, 10),
('AXY8965', 3, 5),
('AXY8965', 2, 15),
('KTL8963', 5, 20),
('KTL8963', 1, 6),
('RTK7541', 4, 18),
('RTK7541', 5, 5),
('RTK7541', 3, 25),
('RTK7541', 2, 15),
('GTD8563', 1, 20),
('GTD8563', 4, 25),
('PLE8456', 2, 10),
('PLE8456', 3, 5);

INSERT INTO `base_inventory` VALUES
(1, 10, 'PATRA_BASE1'),
(2, 20, 'PATRA_BASE1'),
(3, 80, 'PATRA_BASE1'),
(4, 65, 'PATRA_BASE1'),
(5, 30, 'PATRA_BASE1'),
(8, 25, 'PATRA_BASE1'),
(10, 20, 'PATRA_BASE1'),
(17, 100, 'PATRA_BASE1'),
(22, 60, 'PATRA_BASE1'),
(27, 5, 'PATRA_BASE1'),
(31, 70, 'PATRA_BASE1'),
(35, 80, 'PATRA_BASE1'),
(40, 35, 'PATRA_BASE1'),
(44, 6, 'PATRA_BASE1'),
(46, 20, 'PATRA_BASE1'),
(58, 70, 'PATRA_BASE1'),
(60, 46, 'PATRA_BASE1'),
(63, 38, 'PATRA_BASE1'),
(66, 32, 'PATRA_BASE1'),
(68, 52, 'PATRA_BASE1'),
(70, 45, 'PATRA_BASE1'),
(71, 40, 'PATRA_BASE1'),
(75, 40, 'PATRA_BASE1'),
(80, 26, 'PATRA_BASE1'),
(82, 72, 'PATRA_BASE1'),
(88, 54, 'PATRA_BASE1'),
(89, 15, 'PATRA_BASE1'),
(90, 40, 'PATRA_BASE1'),
(95, 38, 'PATRA_BASE1'),
(100, 65, 'PATRA_BASE1'),
(102, 2, 'PATRA_BASE1'),
(105, 120, 'PATRA_BASE1'),
(107, 20, 'PATRA_BASE1');

INSERT INTO `task` VALUES
(NULL, 'natassa_politi', 'YES', 'NO', current_timestamp(), current_timestamp(), NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, 'foivos_rigopoulos', 'YES', 'NO', current_timestamp(), current_timestamp(), NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, 'niki_petratou', 'YES', 'NO', current_timestamp(), current_timestamp(), NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, 'natassa_politi', 'YES', 'NO', current_timestamp(), current_timestamp(), NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL);

INSERT INTO `request` VALUES
(1, 'marios_raftopoulos', 1, 5),
(2, 'marios_raftopoulos', 5, 3),
(3, 'marios_raftopoulos', 35, 7),
(4, 'vasia_alexiou', 40, 10),
(5, 'vasia_alexiou', 46, 8),
(6, 'lydia_loukakou', 68, 6),
(7, 'lydia_loukakou', 80, 3),
(8, 'nikos_kalogeropoulos', 95, 9);

INSERT INTO `offer` VALUES
(9, 'alexandros_apostolou', 32, 10),
(10, 'alexandros_apostolou', 1, 15),
(11, 'alexandros_apostolou', 35, 8),
(12, 'thanos_kostopoulos', 83, 3),
(13, 'thanos_kostopoulos', 40, 10),
(14, 'panagiota_milona', 99, 20),
(15, 'panagiota_milona', 107, 20);*/
