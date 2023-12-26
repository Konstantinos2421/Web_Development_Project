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
('lydia_loukakou', ST_GeomFromText('POINT(38.2403 21.1361)')),
('nikos_kalogeropoulos', ST_GeomFromText('POINT(38.2432 21.7282)')),
('alexandros_apostolou', ST_GeomFromText('POINT(38.2418 21.7435)')),
('thanos_kostopoulos', ST_GeomFromText('POINT(38.2569 21.7451)')),
('panagiota_milona', ST_GeomFromText('POINT(38.2497 21.7373)'));

INSERT INTO `category` VALUES
(NULL, 'meat'),
(NULL, 'diary'),
(NULL, 'beverages'),
(NULL, 'hygiene');

INSERT INTO `has_category` VALUES
('PATRA_BASE1', 1),
('PATRA_BASE1', 2),
('PATRA_BASE1', 3),
('PATRA_BASE1', 4);

INSERT INTO `product` VALUES
(NULL, 'beef', '', 1),
(NULL, 'milk', '', 2),
(NULL, 'water', '', 3),
(NULL, 'soap', '', 4),
(NULL, 'kfc', '', 1);

INSERT INTO `cargo` VALUES
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
(4, 65, 'PATRA_BASE1');

INSERT INTO `task` VALUES
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, 'natassa_politi', 'YES', 'NO', current_timestamp(), current_timestamp(), NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, 'foivos_rigopoulos', 'YES', 'NO', current_timestamp(), current_timestamp(), NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),

(NULL, 'niki_petratou', 'YES', 'NO', current_timestamp(), current_timestamp(), NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL);

INSERT INTO `request` VALUES
(1, 'marios_raftopoulos', 1, 5),
(2, 'marios_raftopoulos', 5, 10),
(3, 'vasia_alexiou', 2, 3),
(4, 'lydia_loukakou', 3, 15),
(5, 'nikos_kalogeropoulos', 4, 5);

INSERT INTO `offer` VALUES
(6, 'alexandros_apostolou', 1, 10),
(7, 'alexandros_apostolou', 2, 20),
(8, 'thanos_kostopoulos', 3, 20),
(9, 'panagiota_milona', 4, 25);
