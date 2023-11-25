-- SQLBook: Code
INSERT INTO `user` VALUES
('komninos', '123456789', 'A', 'K', 69458969),
('eleni', '123456789', 'E', 'S', 69857496),
('gounaridis', '123456789', 'T', 'G', 6945285),
('koutsomitr', '123456789', 'V', 'K', 69896547),
('lydia', '123456789', 'L', 'D', 69896471),
('artemis', '123456789', 'A', 'P', 69857412),
('marios', '123456789', 'M', 'R', 69758241);

INSERT INTO `admin` VALUES
('komninos', ST_GeomFromText('POINT(38.2904 21.7957)'));

INSERT INTO `rescuer` VALUES
('gounaridis', 'Ferrari 420', ST_GeomFromText('POINT(40.8000 22.0000)'), 'komninos'),
('eleni', 'Ford Puma', ST_GeomFromText('POINT(37.2000 19.5874)'), 'komninos'),
('koutsomitr', 'Hundai', ST_GeomFromText('POINT(41.2000 20.5874)'), 'komninos');

INSERT INTO `citizen` VALUES
('marios', ST_GeomFromText('POINT(38.3006 21.7796)')),
('lydia', ST_GeomFromText('POINT(38.3011 21.7821)')),
('artemis', ST_GeomFromText('POINT(38.2946 21.7862)'));

INSERT INTO `category` VALUES
(NULL, 'meat'),
(NULL, 'diary'),
(NULL, 'beverages'),
(NULL, 'hygiene');

INSERT INTO `has_category` VALUES
('komninos', 1),
('komninos', 2),
('komninos', 3),
('komninos', 4);

INSERT INTO `product` VALUES
(NULL, 'beef', '', 1),
(NULL, 'milk', '', 2),
(NULL, 'water', '', 3),
(NULL, 'soap', '', 4),
(NULL, 'kfc', '', 1);

INSERT INTO `cargo` VALUES
('Ferrari 420', 1, 10),
('Ferrari 420', 3, 5),
('Ferrari 420', 2, 15),
('Ferrari 420', 5, 20),
('Ford Puma', 1, 6),
('Ford Puma', 4, 18),
('Ford Puma', 5, 5),
('Hundai', 3, 25),
('Hundai', 4, 500);

INSERT INTO `base_inventory` VALUES
(1, 10, 'komninos'),
(2, 20, 'komninos'),
(3, 80, 'komninos'),
(4, 65, 'komninos');

INSERT INTO `task` VALUES
(NULL, 'gounaridis', 'YES', 'NO', current_timestamp(), NULL, NULL),
(NULL, 'eleni', 'YES', 'NO', current_timestamp(), NULL, NULL),
(NULL, 'gounaridis', 'YES', 'NO', current_timestamp(), NULL, NULL),
(NULL, 'koutsomitr', 'YES', 'NO', current_timestamp(), NULL, NULL),
(NULL, NULL, 'NO', 'NO', current_timestamp(), NULL, NULL);

INSERT INTO `offer` VALUES
(1, 'lydia', 1, 10),
(2, 'lydia', 5, 20),
(3, 'artemis', 3, 5);

INSERT INTO `request` VALUES
(4, 'marios', 4, 5),
(5, 'marios', 5, 8);
