CREATE TABLE countries (
    isocode VARCHAR(6) PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    alfatwocode VARCHAR(2) UNIQUE,
    alfathreecode VARCHAR(4) UNIQUE
);


CREATE TABLE subdivision_category(
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100)
);


CREATE TABLE states_regions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(6),
    name VARCHAR(60),
    country_id VARCHAR(6),
    code3166 VARCHAR(10),
    subdivision_id INT,
    FOREIGN KEY (country_id) REFERENCES countries(isocode),
    FOREIGN KEY (subdivision_id) REFERENCES subdivision_category(id)
);

CREATE TABLE cities_municipalities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(6),
    name VARCHAR(60),
    state_region_id INT,
    FOREIGN KEY (state_region_id) REFERENCES states_regions(id)
);

CREATE TABLE type_identifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(60),
    suffix VARCHAR(5)
);

CREATE TABLE audiences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(60)
);

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80),
    city_id INT,
    audience_id INT,
    cellphone VARCHAR(20) UNIQUE,
    email VARCHAR(100),
    address VARCHAR(120),
    FOREIGN KEY (city_id) REFERENCES cities_municipalities(id),
    FOREIGN KEY (audience_id) REFERENCES audiences(id)
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) UNIQUE,
    description VARCHAR(60)
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60),
    detail TEXT,
    price DOUBLE,
    category_id INT,
    image VARCHAR(80),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE unit_of_measure (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(60)
);

CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80),
    type_id INT,
    category_id INT,
    city_id INT,
    audience_id INT,
    cellphone VARCHAR(15),
    email VARCHAR(80),
    FOREIGN KEY (type_id) REFERENCES type_identifications(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (city_id) REFERENCES cities_municipalities(id),
    FOREIGN KEY (audience_id) REFERENCES audiences(id)
);

CREATE TABLE company_products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT,
    product_id INT,
    price DOUBLE,
    unitmeasure_id INT,
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (unitmeasure_id) REFERENCES unit_of_measure(id)
);

CREATE TABLE favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    company_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);

CREATE TABLE details_favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    favorite_id INT,
    product_id INT,
    FOREIGN KEY (favorite_id) REFERENCES favorites(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE memberships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    description TEXT
);

CREATE TABLE periods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE membership_periods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    membership_id INT,
    period_id INT,
    price DOUBLE,
    FOREIGN KEY (membership_id) REFERENCES memberships(id),
    FOREIGN KEY (period_id) REFERENCES periods(id)
);

CREATE TABLE benefits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(80),
    detail TEXT
);

CREATE TABLE membership_benefits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    membership_id INT,
    period_id INT,
    audience_id INT,
    benefit_id INT,
    FOREIGN KEY (membership_id) REFERENCES memberships(id),
    FOREIGN KEY (period_id) REFERENCES periods(id),
    FOREIGN KEY (audience_id) REFERENCES audiences(id),
    FOREIGN KEY (benefit_id) REFERENCES benefits(id)
);

CREATE TABLE audience_benefits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    audience_id INT,
    benefit_id INT,
    FOREIGN KEY (audience_id) REFERENCES audiences(id),
    FOREIGN KEY (benefit_id) REFERENCES benefits(id)
);

CREATE TABLE polls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80),
    description TEXT,
    is_active BOOLEAN,
    categorypoll_id INT
);

CREATE TABLE categories_polls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80)
);

CREATE TABLE rates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    company_id INT,
    poll_id INT,
    date_rating DATETIME,
    rating DOUBLE,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (poll_id) REFERENCES polls(id)
);

CREATE TABLE quality_products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    poll_id INT,
    company_id INT,
    date_rating DATETIME,
    rating DOUBLE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (poll_id) REFERENCES polls(id),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);


CREATE TABLE poll_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    poll_id INT,
    question TEXT,
    FOREIGN KEY (poll_id) REFERENCES polls(id)
);


CREATE TABLE poll_responses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    poll_id INT,
    question_id INT,
    customer_id INT,
    response TEXT,
    date_response DATETIME DEFAULT NOW(),
    FOREIGN KEY (poll_id) REFERENCES polls(id),
    FOREIGN KEY (question_id) REFERENCES poll_questions(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_product_id INT,
    precio_anterior DOUBLE,
    precio_nuevo DOUBLE,
    fecha_cambio DATETIME DEFAULT NOW(),
    FOREIGN KEY (company_product_id) REFERENCES company_products(id)
);


1. insercion de paises

INSERT INTO countries(isocode, name, alfatwocode, alfathreecode) VALUES
('276', 'Alemania', 'DE', 'DEU'),
('20', 'Andorra', 'AD', 'AND'),
('24', 'Angola', 'AO', 'AGO'),
('660', 'Anguilla', 'AI', 'AIA'),
('10', 'Antártida', 'AQ', 'ATA'),
('28', 'Antigua y Barbuda', 'AG', 'ATG'),
('682', 'Arabia Saudí', 'SA', 'SAU'),
('12', 'Argelia', 'DZ', 'DZA'),
('32', 'Argentina', 'AR', 'ARG'),
('51', 'Armenia', 'AM', 'ARM'),
('533', 'Aruba', 'AW', 'ABW'),
('36', 'Australia', 'AU', 'AUS'),
('40', 'Austria', 'AT', 'AUT'),
('31', 'Azerbaiyán', 'AZ', 'AZE'),
('44', 'Bahamas', 'BS', 'BHS'),
('50', 'Bangladés', 'BD', 'BGD'),
('52', 'Barbados', 'BB', 'BRB'),
('48', 'Baréin', 'BH', 'BHR'),
('56', 'Belgica', 'BE', 'BEL'),
('84', 'Belice', 'BZ', 'BLZ'),
('204', 'Benin', 'BJ', 'BEN'),
('60', 'Bermudas', 'BM', 'BMU'),
('112', 'Bielorussia', 'BY', 'BLR'),
('104', 'Birmania', 'MM', 'MMR'),
('68', 'Bolivia', 'BO', 'BOL'),
('70', 'Bosnia y Herzegovina', 'BA', 'BIH'),
('72', 'Botsuana', 'BW', 'BWA'),
('76', 'Brasil', 'BR', 'BRA'),
('96', 'Brunéi', 'BN', 'BRN'),
('100', 'Bulgaria', 'BG', 'BGR'),
('854', 'Burkina Faso', 'BF', 'BFA'),
('108', 'Burundi', 'BI', 'BDI'),
('64', 'Bután', 'BT', 'BTN'),
('132', 'Cabo Verde', 'CV', 'CPV'),
('116', 'Camboya', 'KH', 'KHM'),
('120', 'Camerún', 'CM', 'CMR'),
('124', 'Canadá', 'CA', 'CAN'),
('535', 'Caribe Neerlandés', 'BQ', 'BES'),
('634', 'Catar', 'QA', 'QAT'),
('148', 'Chad', 'TD', 'TCD'),
('152', 'Chile', 'CL', 'CHL'),
('156', 'China', 'CN', 'CHN'),
('196', 'Chipre', 'CY', 'CYP'),
('170', 'Colombia', 'CO', 'COL'),
('174', 'Comoras', 'KM', 'COM'),
('408', 'Corea del Norte', 'KP', 'PRK'),
('410', 'Corea del Sur', 'KR', 'KOR'),
('384', 'Costa de Marfil', 'CI', 'CIV'),
('188', 'Costa Rica', 'CR', 'CRI'),
('191', 'Croacia', 'HR', 'HRV'),
('192', 'Cuba', 'CU', 'CUB');


INSERT INTO countries(isocode, name, alfatwocode, alfathreecode) VALUES
('531', 'Curazao', 'CW', 'CUW'),
('208', 'Dinamarca', 'DK', 'DNK'),
('212', 'Dominica', 'DM', 'DMA'),
('218', 'Ecuador', 'EC', 'ECU'),
('818', 'Egipto', 'EG', 'EGY'),
('222', 'El Salvador', 'SV', 'SLV'),
('784', 'Emiratos árabes Unidos', 'AE', 'ARE'),
('232', 'Eritrea', 'ER', 'ERI'),
('703', 'Eslovaquia', 'SK', 'SVK'),
('705', 'Eslovenia', 'SI', 'SVN'),
('724', 'España', 'ES', 'ESP'),
('583', 'Estados Federados de Micronesia', 'FM', 'FSM'),
('840', 'Estados Unidos', 'US', 'USA'),
('233', 'Estonia', 'EE', 'EST'),
('231', 'Etiopía', 'ET', 'ETH'),
('608', 'Filipinas', 'PH', 'PHL'),
('246', 'Finlandia', 'FI', 'FIN'),
('242', 'Fiyi', 'FJ', 'FJI'),
('250', 'Francia', 'FR', 'FRA'),
('266', 'Gabon', 'GA', 'GAB'),
('270', 'Gambia', 'GM', 'GMB'),
('268', 'Georgia', 'GE', 'GEO'),
('288', 'Ghana', 'GH', 'GHA'),
('292', 'Gibraltar', 'GI', 'GIB'),
('308', 'Granada', 'GD', 'GRD'),
('300', 'Grecia', 'GR', 'GRC'),
('304', 'Groenlandia', 'GL', 'GRL'),
('312', 'Guadelupe', 'GP', 'GLP'),
('316', 'Guam', 'GU', 'GUM'),
('320', 'Guatemala', 'GT', 'GTM'),
('254', 'Guayana Francesa', 'GF', 'GUF'),
('831', 'Guernsey', 'GG', 'GGY'),
('324', 'Guinea', 'GN', 'GIN'),
('226', 'Guinea Ecuatorial', 'GQ', 'GNQ'),
('624', 'Guinea-Bissau', 'GW', 'GNB'),
('328', 'Guyana', 'GY', 'GUY'),
('332', 'Haití', 'HT', 'HTI'),
('340', 'Honduras', 'HN', 'HND'),
('344', 'Hong Kong', 'HK', 'HKG'),
('348', 'Hungría', 'HU', 'HUN'),
('352', 'Iceland', 'IS', 'ISL'),
('356', 'India', 'IN', 'IND'),
('360', 'Indonesia', 'ID', 'IDN'),
('368', 'Irak', 'IQ', 'IRQ'),
('364', 'Iran', 'IR', 'IRN'),
('833', 'Isla de Man', 'IM', 'IMN'),
('162', 'Isla de Navidad', 'CX', 'CXR'),
('574', 'Isla Norfolk', 'NF', 'NFK'),
('372', 'Islandia', 'IE', 'IRL'),
('136', 'Islas Caimán', 'KY', 'CYM');


INSERT INTO countries(isocode, name, alfatwocode, alfathreecode) VALUES
('166', 'Islas Cocos', 'CC', 'CCK'),
('184', 'Islas Cook', 'CK', 'COK'),
('234', 'Islas Feroe', 'FO', 'FRO'),
('239', 'Islas Georgias y Sandwich del Sur', 'GS', 'SGS'),
('238', 'Islas Malvinas', 'FK', 'FLK'),
('580', 'Islas Marianas del Norte', 'MP', 'MNP'),
('584', 'Islas Marshall', 'MH', 'MHL'),
('612', 'Islas Pitcairn', 'PN', 'PCN'),
('90', 'Islas Salomón', 'SB', 'SLB'),
('796', 'Islas Turcas y Caicos', 'TC', 'TCA'),
('92', 'Islas Vírgenes Británicas', 'VG', 'VGB'),
('850', 'Islas Vírgenes de los Estados Unidos', 'VI', 'VIR'),
('376', 'Israel', 'IL', 'ISR'),
('380', 'Italia', 'IT', 'ITA'),
('388', 'Jamaica', 'JM', 'JAM'),
('392', 'Japón', 'JP', 'JPN'),
('832', 'Jersey', 'JE', 'JEY'),
('400', 'Jordania', 'JO', 'JOR'),
('398', 'Kazajistán', 'KZ', 'KAZ'),
('404', 'Kenia', 'KE', 'KEN'),
('417', 'Kirguistán', 'KG', 'KGZ'),
('296', 'Kiribati', 'KI', 'KIR'),
('153', 'Kosovo', 'XK', 'XKX'),
('414', 'Kuweit', 'KW', 'KWT'),
('418', 'Laos', 'LA', 'LAO'),
('426', 'Lesoto', 'LS', 'LSO'),
('428', 'Letonia', 'LV', 'LVA'),
('422', 'Libano', 'LB', 'LBN'),
('430', 'Liberia', 'LR', 'LBR'),
('434', 'Libia', 'LY', 'LBY'),
('438', 'Liechtenstein', 'LI', 'LIE'),
('440', 'Lituania', 'LT', 'LTU'),
('442', 'Luxemburgo', 'LU', 'LUX'),
('446', 'Macao', 'MO', 'MAC'),
('807', 'Macedonia', 'MK', 'MKD'),
('450', 'Madagascar', 'MG', 'MDG'),
('458', 'Malasia', 'MY', 'MYS'),
('454', 'Malaui', 'MW', 'MWI'),
('462', 'Maldivas', 'MV', 'MDV'),
('466', 'Mali', 'ML', 'MLI'),
('470', 'Malta', 'MT', 'MLT'),
('504', 'Marruecos', 'MA', 'MAR'),
('474', 'Martinica', 'MQ', 'MTQ'),
('480', 'Mauricio', 'MU', 'MUS'),
('478', 'Mauritania', 'MR', 'MRT'),
('175', 'Mayotte', 'YT', 'MYT'),
('484', 'México', 'MX', 'MEX'),
('498', 'Moldavia', 'MD', 'MDA');


INSERT INTO countries(isocode, name, alfatwocode, alfathreecode) VALUES
('492', 'Monaco', 'MC', 'MCO'),
('496', 'Mongolia', 'MN', 'MNG'),
('499', 'Monténégro', 'ME', 'MNE'),
('500', 'Montserrat', 'MS', 'MSR'),
('508', 'Mozambique', 'MZ', 'MOZ'),
('516', 'Namibia', 'NA', 'NAM'),
('520', 'Nauru', 'NR', 'NRU'),
('524', 'Nepal', 'NP', 'NPL'),
('558', 'Nicaragua', 'NI', 'NIC'),
('562', 'Niger', 'NE', 'NER'),
('566', 'Nigeria', 'NG', 'NGA'),
('570', 'Niue', 'NU', 'NIU'),
('578', 'Noruega', 'NO', 'NOR'),
('540', 'Nueva Caledonia', 'NC', 'NCL'),
('554', 'Nueva Zelanda', 'NZ', 'NZL'),
('512', 'Omán', 'OM', 'OMN'),
('528', 'Países Bajos', 'NL', 'NLD'),
('586', 'Pakistán', 'PK', 'PAK'),
('585', 'Palaos', 'PW', 'PLW'),
('275', 'Palestina', 'PS', 'PSE'),
('591', 'Panama', 'PA', 'PAN'),
('598', 'Papúa Nueva Guinea', 'PG', 'PNG'),
('600', 'Paraguay', 'PY', 'PRY'),
('604', 'Perú', 'PE', 'PER'),
('258', 'Polinesia Francesa', 'PF', 'PYF'),
('616', 'Polonia', 'PL', 'POL'),
('620', 'Portugal', 'PT', 'PRT'),
('630', 'Puerto Rico', 'PR', 'PRI'),
('826', 'Reino Unido', 'GB', 'GBR'),
('732', 'República árabe Saharaui DemocrÁtica', 'EH', 'ESH'),
('140', 'República Centroafricana', 'CF', 'CAF'),
('203', 'República Checa', 'CZ', 'CZE'),
('178', 'República del Congo', 'CG', 'COG'),
('180', 'República DemocrÁtica del Congo', 'CD', 'COD'),
('214', 'República Dominicana', 'DO', 'DOM'),
('638', 'Reunión', 'RE', 'REU'),
('646', 'Ruanda', 'RW', 'RWA'),
('642', 'Rumania', 'RO', 'ROU'),
('643', 'Rusia', 'RU', 'RUS'),
('882', 'Samoa', 'WS', 'WSM'),
('16', 'Samoa Americana', 'AS', 'ASM'),
('652', 'San Bartolomé', 'BL', 'BLM'),
('659', 'San Cristóbal y Nieves', 'KN', 'KNA'),
('674', 'San Marino', 'SM', 'SMR'),
('534', 'San Martín', 'MF', 'MAF'),
('666', 'San Pedro y Miquelón', 'PM', 'SPM'),
('670', 'San Vicente y las Granadinas', 'VC', 'VCT'),
('662', 'Santa Lucía', 'LC', 'LCA');


INSERT INTO countries(isocode, name, alfatwocode, alfathreecode) VALUES
('678', 'Santo Tomé y Príncipe', 'ST', 'STP'),
('686', 'Senegal', 'SN', 'SEN'),
('688', 'Serbia', 'RS', 'SRB'),
('690', 'Seychelles', 'SC', 'SYC'),
('694', 'Sierra Leona', 'SL', 'SLE'),
('702', 'Singapur', 'SG', 'SGP'),
('654', 'Sint Helena, Ascension and Tristan da Cunha', 'SH', 'SHN'),
('663', 'Sint-Maarten', 'SX', 'SXM'),
('760', 'Siria', 'SY', 'SYR'),
('706', 'Somalia', 'SO', 'SOM'),
('144', 'Sri Lanka', 'LK', 'LKA'),
('748', 'eSwatani', 'SZ', 'SWZ'),
('710', 'Sudáfrica', 'ZA', 'ZAF'),
('729', 'Sudán', 'SD', 'SDN'),
('728', 'Sudán del Sur', 'SS', 'SSD'),
('752', 'Suecia', 'SE', 'SWE'),
('756', 'Suiza', 'CH', 'CHE'),
('740', 'Surinam', 'SR', 'SUR'),
('764', 'Tailandia', 'TH', 'THA'),
('158', 'Taiwan', 'TW', 'TWN'),
('834', 'Tanzania', 'TZ', 'TZA'),
('762', 'Tayikistán', 'TJ', 'TJK'),
('86', 'Territorio Británico del Océano índico', 'IO', 'IOT'),
('260', 'Tierras Australes y Antárticas Francesas', 'TF', 'ATF'),
('626', 'Timor Oriental', 'TL', 'TLS'),
('768', 'Togo', 'TG', 'TGO'),
('772', 'Tokelau', 'TK', 'TKL'),
('776', 'Tonga', 'TO', 'TON'),
('780', 'Trinidad y Tobago', 'TT', 'TTO'),
('788', 'Túnez', 'TN', 'TUN'),
('795', 'Turkmenistán', 'TM', 'TKM'),
('792', 'Turquía', 'TR', 'TUR'),
('798', 'Tuvalu', 'TV', 'TUV'),
('804', 'Ucrania', 'UA', 'UKR'),
('800', 'Uganda', 'UG', 'UGA'),
('858', 'Uruguay', 'UY', 'URY'),
('860', 'Uzbekistán', 'UZ', 'UZB'),
('548', 'Vanuatu', 'VU', 'VUT'),
('336', 'Vaticano', 'VA', 'VAT'),
('862', 'Venezuela', 'VE', 'VEN'),
('704', 'Vietnam', 'VN', 'VNM'),
('876', 'Wallis y Futuna', 'WF', 'WLF'),
('887', 'Yemen', 'YE', 'YEM'),
('262', 'Yibuti', 'DJ', 'DJI'),
('894', 'Zambia', 'ZM', 'ZMB'),
('716', 'Zimbabwe', 'ZW', 'ZWE');

2. inserccion de departamentos

INSERT INTO states_regions (id, code, name, country_id, code3166, subdivision_id) VALUES
(91,'AMA', 'Amazonas', '170', 'CO-AMA',1),
(05,'ANT', 'Antioquia', '170', 'CO-ANT',1),
(81,'ARA', 'Arauca', '170', 'CO-ARA',1),
(08,'ATL', 'Atlántico', '170', 'CO-ATL',1),
(13,'BOL', 'Bolívar', '170', 'CO-BOL',1),
(15,'BOY', 'Boyacá', '170', 'CO-BOY',1),
(17,'CAL', 'Caldas', '170', 'CO-CAL',1),
(18,'CAQ', 'Caquetá', '170', 'CO-CAQ',1),
(85,'CAS', 'Casanare', '170', 'CO-CAS',1),
(19,'CAU', 'Cauca', '170', 'CO-CAU',1),
(20,'CES', 'Cesar', '170', 'CO-CES',1),
(27,'CHO', 'Chocó', '170', 'CO-CHO',1),
(25,'CUN', 'Cundinamarca', '170', 'CO-CUN',1),
(23,'COR', 'Córdoba', '170', 'CO-COR',1),
(11,'DC',  'Distrito Capital de Bogotá', '170', '70CO-DC',4),
(94,'GUA', 'Guainía', '170', 'CO-GUA',1),
(95,'GUV', 'Guaviare', '170', 'CO-GUV',1),
(41,'HUI', 'Huila', '170', 'CO-HUI',1),
(44,'LAG', 'La Guajira', '170', 'CO-LAG',1),
(47,'MAG', 'Magdalena', '170', 'CO-MAG',1),
(50,'MET', 'Meta', '170', 'CO-MET',1),
(52,'NAR', 'Nariño', '170', 'CO-NAR',1),
(54,'NSA', 'Norte de Santander', '170', 'CO-NSA',1),
(86,'PUT', 'Putumayo', '170', 'CO-PUT',1),
(63,'QUI', 'Quindío', '170', 'CO-QUI',1),
(66,'RIS', 'Risaralda', '170', 'CO-RIS',1),
(88,'SAP', 'San Andrés, Providencia y Santa Catatalina', '170', 'CO-SAP',1),
(68,'SAN', 'Santander', '170', 'CO-SAN',1),
(70,'SUC', 'Sucre', '170', 'CO-SUC',1),
(73,'TOL', 'Tolima', '170', 'CO-TOL',1),
(76,'VAC', 'Valle del Cauca', '170', 'CO-VAC',1),
(97,'VAU', 'Vaupés', '170', 'CO-VAU',1),
(99,'VID', 'Vichada', '170', 'CO-VID',1);

INSERT INTO states_regions (id, code, name, country_id, code3166, subdivision_id) VALUES
(100, 'AL', 'Alabama', 840, 'US-AL',2),
(101, 'AK', 'Alaska', 840, 'US-AK',2),
(102, 'AS', 'American Samoa', 840, 'US-AS',3),
(103, 'AZ', 'Arizona', 840, 'US-AZ',2),
(104, 'AR', 'Arkansas', 840, 'US-AR',2),
(105, 'CA', 'California', 840, 'US-CA',2),
(106, 'CO', 'Colorado', 840, 'US-CO',2),
(107, 'CT', 'Connecticut', 840, 'US-CT',2),
(108, 'DE', 'Delaware', 840, 'US-DE',2),
(109, 'DC', 'District of Columbia', 840, 'US-DC',4),
(110, 'FL', 'Florida', 840, 'US-FL',2),
(111, 'GA', 'Georgia', 840, 'US-GA',2),
(112, 'GU', 'Guam', 840, 'US-GU',3),
(113, 'HI', 'Hawaii', 840, 'US-HI',2),
(114, 'ID', 'Idaho', 840, 'US-ID',2),
(115, 'IL', 'Illinois', 840, 'US-IL',2),
(116, 'IN', 'Indiana', 840, 'US-IN',2),
(117, 'IA', 'Iowa', 840, 'US-IA',2),
(118, 'KS', 'Kansas', 840, 'US-KS',2),
(119, 'KY', 'Kentucky', 840, 'US-KY',2),
(120, 'LA', 'Louisiana', 840, 'US-LA',2),
(121, 'ME', 'Maine', 840, 'US-ME',2),
(122, 'MD', 'Maryland', 840, 'US-MD',2),
(123, 'MA', 'Massachusetts', 840, 'US-MA',2),
(124, 'MI', 'Michigan', 840, 'US-MI',2),
(125, 'MN', 'Minnesota', 840, 'US-MN',2),
(126, 'MS', 'Mississippi', 840, 'US-MS',2),
(127, 'MO', 'Missouri', 840, 'US-MO',2),
(128, 'MT', 'Montana', 840, 'US-MT',2),
(129, 'NE', 'Nebraska', 840, 'US-NE',2),
(130, 'NV', 'Nevada', 840, 'US-NV',2),
(131, 'NH', 'New Hampshire', 840, 'US-NH',2),
(132, 'NJ', 'New Jersey', 840, 'US-NJ',2),
(133, 'NM', 'New Mexico', 840, 'US-NM',2),
(134, 'NY', 'New York', 840, 'US-NY',2),
(135, 'NC', 'North Carolina', 840, 'US-NC',2),
(136, 'ND', 'North Dakota', 840, 'US-ND',2),
(137, 'MP', 'Northern Mariana Islands', 840, 'US-MP',3),
(138, 'OH', 'Ohio', 840, 'US-OH',2),
(139, 'OK', 'Oklahoma', 840, 'US-OK',2),
(140, 'OR', 'Oregon', 840, 'US-OR',2),
(141, 'PA', 'Pennsylvania', 840, 'US-PA',2),
(142, 'PR', 'Puerto Rico', 840, 'US-PR',3),
(143, 'RI', 'Rhode Island', 840, 'US-RI',2),
(144, 'SC', 'South Carolina', 840, 'US-SC',2),
(145, 'SD', 'South Dakota', 840, 'US-SD',2),
(146, 'TN', 'Tennessee', 840, 'US-TN',2),
(147, 'TX', 'Texas', 840, 'US-TX',2),
(148, 'UM', 'United States Minor Outlying Islands', 840, 'US-UM',3),
(149, 'UT', 'Utah', 840, 'US-UT',2),
(150, 'VT', 'Vermont', 840, 'US-VT',2),
(151, 'VI', 'Virgin Islands, U.S.', 840, 'US-VI',3),
(152, 'VA', 'Virginia', 840, 'US-VA',2),
(153, 'WA', 'Washington', 840, 'US-WA',2),
(154, 'WV', 'West Virginia', 840, 'US-WV',2),
(155, 'WI', 'Wisconsin', 840, 'US-WI',2),
(156, 'WY', 'Wyoming', 840, 'US-WY',2);


3. inserccion de municipios

INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('001', 'MEDELLIN', 5),
('002', 'ABEJORRAL', 5),
('004', 'ABRIAQUI', 5),
('021', 'ALEJANDRIA', 5),
('030', 'AMAGA', 5),
('031', 'AMALFI', 5),
('034', 'ANDES', 5),
('036', 'ANGELOPOLIS', 5),
('038', 'ANGOSTURA', 5),
('040', 'ANORI', 5),
('042', 'SANTAFE DE ANTIOQUITA', 5),
('044', 'ANZA', 5),
('045', 'APARTADO', 5),
('051', 'ARBOLETES', 5),
('055', 'ARGELIA', 5),
('059', 'ARMENIA', 5),
('079', 'BARBOSA', 5),
('086', 'BELMIRA', 5),
('088', 'BELLO', 5),
('091', 'BETANIA', 5),
('093', 'BETULIA', 5),
('101', 'CIUDAD BOLIVAR', 5),
('107', 'BRICEÑO', 5),
('113', 'BURITICA', 5),
('120', 'CACERES', 5),
('125', 'CAICEDO', 5),
('129', 'CALDAS', 5),
('134', 'CAMPAMENTO', 5),
('138', 'CAÑASGORDAS', 5),
('142', 'CARACOLI', 5),
('145', 'CARAMANTA', 5),
('147', 'CAREPA', 5),
('148', 'EL CARMEN DE VIBORAL', 5),
('150', 'CAROLINA', 5),
('154', 'CAUCASIA', 5),
('172', 'CHIGORODO', 5),
('190', 'CISNEROS', 5),
('197', 'COCORNA', 5),
('206', 'CONCEPCION', 5),
('209', 'CONCORDIA', 5);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('212', 'COPACABANA', 5),
('234', 'DABEIBA', 5),
('237', 'DON MATIAS', 5),
('240', 'EBEJICO', 5),
('250', 'EL BAGRE', 5),
('264', 'ENTRERRIOS', 5),
('266', 'ENVIGADO', 5),
('282', 'FREDONIA', 5),
('284', 'FRONTINO', 5),
('306', 'GIRALDO', 5),
('308', 'GIRARDOTA', 5),
('310', 'GOMEZ PLATA', 5),
('313', 'GRANADA', 5),
('315', 'GUADALUPE', 5),
('318', 'GUARNE', 5),
('321', 'GUATAPE', 5),
('347', 'HELICONIA', 5),
('353', 'HISPANIA', 5),
('360', 'ITAGÜI', 5),
('361', 'ITUANGO', 5),
('364', 'JARDIN', 5),
('368', 'JERICO', 5),
('376', 'LA CEJA', 5),
('380', 'LA ESTRELLA', 5),
('390', 'LA PINTADA', 5),
('400', 'LA UNION', 5),
('411', 'LIBORINA', 5),
('425', 'MACEO', 5),
('440', 'MARINILLA', 5),
('467', 'MONTEBELLO', 5),
('475', 'MURINDO', 5),
('480', 'MUTATA', 5),
('483', 'NARIÑO', 5),
('490', 'NECOCLI', 5),
('495', 'NECHI', 5),
('501', 'OLAYA', 5),
('541', 'PEÑOL', 5),
('543', 'PEQUE', 5),
('576', 'PUEBLORRICO', 5),
('579', 'PUERTO BERRIO', 5);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('585', 'PUERTO NARE', 05),
('591', 'PUERTO TRIUNFO', 05),
('604', 'REMEDIOS', 05),
('607', 'RETIRO', 05),
('615', 'RIONEGRO', 05),
('628', 'SABANALARGA', 05),
('631', 'SABANETA', 05),
('642', 'SALGAR', 05),
('647', 'SAN ANDRES', 05),
('649', 'SAN CARLOS', 05),
('652', 'SAN FRANCISCO', 05),
('656', 'SAN JERONIMO', 05),
('658', 'SAN JOSE DE LA MONTANA', 05),
('659', 'SAN JUAN DE URABA', 05),
('660', 'SAN LUIS', 05),
('664', 'SAN PEDRO', 05),
('665', 'SAN PEDRO DE URABA', 05),
('667', 'SAN RAFAEL', 05),
('670', 'SAN ROQUE', 05),
('674', 'SAN VICENTE', 05),
('679', 'SANTA BARBARA', 05),
('686', 'SANTA ROSA DE OSOS', 05),
('690', 'SANTO DOMINGO', 05),
('697', 'EL SANTUARIO', 05),
('736', 'SEGOVIA', 05),
('756', 'SONSON', 05),
('761', 'SOPETRAN', 05),
('789', 'TAMESIS', 05),
('790', 'TARAZA', 05),
('792', 'TARSO', 05),
('809', 'TITIRIBI', 05),
('819', 'TOLEDO', 05),
('837', 'TURBO', 05),
('842', 'URAMITA', 05),
('847', 'URRAO', 05),
('854', 'VALDIVIA', 05),
('856', 'VALPARAISO', 05),
('858', 'VEGACHI', 05),
('861', 'VENECIA', 05),
('873', 'VIGIA DEL FUERTE', 05);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('885', 'YALI', 05),
('887', 'YARUMAL', 05),
('890', 'YOLOMBO', 05),
('893', 'YONDO', 05),
('895', 'ZARAGOZA', 05),
('001', 'BARRANQUILLA', 08),
('078', 'BARANOA', 08),
('137', 'CAMPO DE LA CRUZ', 08),
('141', 'CANDELARIA', 08),
('296', 'GALAPA', 08),
('372', 'JUAN DE ACOSTA', 08),
('421', 'LURUACO', 08),
('433', 'MALAMBO', 08),
('436', 'MANATI', 08),
('520', 'PALMAR DE VARELA', 08),
('549', 'PIOJO', 08),
('558', 'POLONUEVO', 08),
('560', 'PONEDERA', 08),
('573', 'PUERTO COLOMBIA', 08),
('606', 'REPELON', 08),
('634', 'SABANAGRANDE', 08),
('638', 'SABANALARGA', 08),
('675', 'SANTA LUCIA', 08),
('685', 'SANTO TOMAS', 08),
('758', 'SOLEDAD', 08),
('770', 'SUAN', 08),
('832', 'TUBARA', 08),
('849', 'USIACURI', 08),
('001', 'BOGOTA D.C.', 11),
('001', 'CARTAGENA', 13),
('006', 'ACHI', 13),
('030', 'ALTOS DEL ROSARIO', 13),
('042', 'ARENAL', 13),
('052', 'ARJONA', 13),
('062', 'ARROYOHONDO', 13),
('074', 'BARRANCO DE LOBA', 13),
('140', 'CALAMAR', 13),
('160', 'CANTAGALLO', 13),
('188', 'CICUCO', 13),
('212', 'CORDOBA', 13);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('222', 'CLEMENCIA', 13),
('244', 'EL CARMEN DE BOLIVAR', 13),
('248', 'EL GUAMO', 13),
('268', 'EL PENON', 13),
('300', 'HATILLO DE LOBA', 13),
('430', 'MAGANGUE', 13),
('433', 'MAHATES', 13),
('440', 'MARGARITA', 13),
('442', 'MARIA LA BAJA', 13),
('458', 'MONTECRISTO', 13),
('468', 'MOMPOS', 13),
('473', 'MORALES', 13),
('549', 'PINILLOS', 13),
('580', 'REGIDOR', 13),
('600', 'RIO VIEJO', 13),
('620', 'SAN CRISTOBAL', 13),
('647', 'SAN ESTANISLAO', 13),
('650', 'SAN FERNANDO', 13),
('654', 'SAN JACINTO', 13),
('655', 'SAN JACINTO DEL CAUCA', 13),
('657', 'SAN JUAN NEPOMUCENO', 13),
('667', 'SAN MARTIN DE LOBA', 13),
('670', 'SAN PABLO', 13),
('673', 'SANTA CATALINA', 13),
('683', 'SANTA ROSA', 13),
('688', 'SANTA ROSA DEL SUR', 13),
('744', 'SIMITI', 13),
('760', 'SOPLAVIENTO', 13),
('780', 'TALAIGUA NUEVO', 13),
('810', 'TIQUISIO', 13),
('836', 'TURBACO', 13),
('838', 'TURBANA', 13),
('873', 'VILLANUEVA', 13),
('894', 'ZAMBRANO', 13),
('001', 'TUNJA', 15),
('022', 'ALMEIDA', 15),
('047', 'AQUITANIA', 15),
('051', 'ARCABUCO', 15),
('087', 'BELEN', 15),
('090', 'BERBEO', 15);

INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('092', 'BETEITIVA', 15),
('097', 'BOAVITA', 15),
('104', 'BOYACA', 15),
('106', 'BRICENO', 15),
('109', 'BUENAVISTA', 15),
('114', 'BUSBANZA', 15),
('131', 'CALDAS', 15),
('135', 'CAMPOHERMOSO', 15),
('162', 'CERINZA', 15),
('172', 'CHINAVITA', 15),
('176', 'CHIQUINQUIRA', 15),
('180', 'CHISCAS', 15),
('183', 'CHITA', 15),
('185', 'CHITARAQUE', 15),
('187', 'CHIVATA', 15),
('189', 'CIENEGA', 15),
('204', 'COMBITA', 15),
('212', 'COPER', 15),
('215', 'CORRALES', 15),
('218', 'COVARACHIA', 15),
('223', 'CUBARA', 15),
('224', 'CUCAITA', 15),
('226', 'CUITIVA', 15),
('232', 'CHIQUIZA', 15),
('236', 'CHIVOR', 15),
('238', 'DUITAMA', 15),
('244', 'EL COCUY', 15),
('248', 'EL ESPINO', 15),
('272', 'FIRAVITOBA', 15),
('276', 'FLORESTA', 15),
('293', 'GACHANTIVA', 15),
('296', 'GAMEZA', 15),
('299', 'GARAGOA', 15),
('317', 'GUACAMAYAS', 15),
('322', 'GUATEQUE', 15),
('325', 'GUAYATA', 15),
('332', 'GUICAN', 15),
('362', 'IZA', 15),
('367', 'JENESANO', 15),
('368', 'JERICO', 15);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('377', 'LABRANZAGRANDE', 15),
('380', 'LA CAPILLA', 15),
('401', 'LA VICTORIA', 15),
('403', 'LA UVITA', 15),
('407', 'VILLA DE LEYVA', 15),
('425', 'MACANAL', 15),
('442', 'MARIPI', 15),
('455', 'MIRAFLORES', 15),
('464', 'MONGUA', 15),
('466', 'MONGUI', 15),
('469', 'MONIQUIRA', 15),
('476', 'MOTAVITA', 15),
('480', 'MUZO', 15),
('491', 'NOBSA', 15),
('494', 'NUEVO COLON', 15),
('500', 'OICATA', 15),
('507', 'OTANCHE', 15),
('511', 'PACHAVITA', 15),
('514', 'PAEZ', 15),
('516', 'PAIPA', 15),
('518', 'PAJARITO', 15),
('522', 'PANQUEBA', 15),
('531', 'PAUNA', 15),
('533', 'PAYA', 15),
('537', 'PAZ DE RIO', 15),
('542', 'PESCA', 15),
('550', 'PISBA', 15),
('572', 'PUERTO BOYACA', 15),
('580', 'QUIPAMA', 15),
('599', 'RAMIRIQUI', 15),
('600', 'RAQUIRA', 15),
('621', 'RONDON', 15),
('632', 'SABOYA', 15),
('638', 'SACHICA', 15),
('646', 'SAMACA', 15),
('660', 'SAN EDUARDO', 15),
('664', 'SAN JOSE DE PARE', 15),
('667', 'SAN LUIS DE GACENO', 15),
('673', 'SAN MATEO', 15),
('676', 'SAN MIGUEL DE SEMA', 15);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('681', 'SAN PABLO DE BORBUR', 15),
('686', 'SANTANA', 15),
('690', 'SANTA MARIA', 15),
('693', 'SANTA ROSA DE VITERBO', 15),
('696', 'SANTA SOFIA', 15),
('720', 'SATIVANORTE', 15),
('723', 'SATIVASUR', 15),
('740', 'SIACHOQUE', 15),
('753', 'SOATA', 15),
('755', 'SOCOTA', 15),
('757', 'SOCHA', 15),
('759', 'SOGAMOSO', 15),
('761', 'SOMONDOCO', 15),
('762', 'SORA', 15),
('763', 'SOTAQUIRA', 15),
('764', 'SORACA', 15),
('774', 'SUSACON', 15),
('776', 'SUTAMARCHAN', 15),
('778', 'SUTATENZA', 15),
('790', 'TASCO', 15),
('798', 'TENZA', 15),
('804', 'TIBANA', 15),
('806', 'TIBASOSA', 15),
('808', 'TINJACA', 15),
('810', 'TIPACOQUE', 15),
('814', 'TOCA', 15),
('816', 'TOGUI', 15),
('820', 'TOPAGA', 15),
('822', 'TOTA', 15),
('832', 'TUNUNGUA', 15),
('835', 'TURMEQUE', 15),
('837', 'TUTA', 15),
('839', 'TUTAZA', 15),
('842', 'UMBITA', 15),
('861', 'VENTAQUEMADA', 15),
('879', 'VIRACACHA', 15),
('897', 'ZETAQUIRA', 15),
('001', 'MANIZALES', 17),
('013', 'AGUADAS', 17),
('042', 'ANSERMA', 17);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('050', 'ARANZAZU', 17),
('088', 'BELALCAZAR', 17),
('174', 'CHINCHINA', 17),
('272', 'FILADELFIA', 17),
('380', 'LA DORADA', 17),
('388', 'LA MERCED', 17),
('433', 'MANZANARES', 17),
('442', 'MARMATO', 17),
('444', 'MARQUETALIA', 17),
('446', 'MARULANDA', 17),
('486', 'NEIRA', 17),
('495', 'NORCASIA', 17),
('513', 'PACORA', 17),
('524', 'PALESTINA', 17),
('541', 'PENSILVANIA', 17),
('614', 'RIOSUCIO', 17),
('616', 'RISARALDA', 17),
('653', 'SALAMINA', 17),
('662', 'SAMANA', 17),
('665', 'SAN JOSE', 17),
('777', 'SUPIA', 17),
('867', 'VICTORIA', 17),
('873', 'VILLAMARIA', 17),
('877', 'VITERBO', 17),
('001', 'FLORENCIA', 18),
('029', 'ALBANIA', 18),
('094', 'BELEN DE LOS ANDAQUIES', 18),
('150', 'CARTAGENA DEL CHAIRA', 18),
('205', 'CURILLO', 18),
('247', 'EL DONCELLO', 18),
('256', 'EL PAUJIL', 18),
('410', 'LA MONTAÑITA', 18),
('460', 'MILAN', 18),
('479', 'MORELIA', 18),
('592', 'PUERTO RICO', 18),
('610', 'SAN JOSE DE LA FRAGUA', 18),
('753', 'SAN VICENTE DEL CAGUAN', 18),
('756', 'SOLANO', 18),
('785', 'SOLITA', 18),
('860', 'VALPARAISO', 18);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('001', 'POPAYAN', 19),
('022', 'ALMAGUER', 19),
('050', 'ARGELIA', 19),
('075', 'BALBOA', 19),
('100', 'BOLIVAR', 19),
('110', 'BUENOS AIRES', 19),
('130', 'CAJIBIO', 19),
('137', 'CALDONO', 19),
('142', 'CALOTO', 19),
('212', 'CORINTO', 19),
('256', 'EL TAMBO', 19),
('290', 'FLORENCIA', 19),
('298', 'GUACHENE', 19),
('300', 'GUAPI', 19),
('318', 'INZA', 19),
('355', 'JAMBALO', 19),
('370', 'LA SIERRA', 19),
('373', 'LA VEGA', 19),
('405', 'LOPEZ', 19),
('470', 'MERCADERES', 19),
('473', 'MIRANDA', 19),
('513', 'PADILLA', 19),
('517', 'PAEZ', 19),
('532', 'PATIA', 19),
('533', 'PIAMONTE', 19),
('548', 'PIENDAMO', 19),
('573', 'PUERTO TEJADA', 19),
('585', 'PURACE', 19),
('592', 'ROSAS', 19),
('610', 'SAN SEBASTIAN', 19),
('620', 'SANTANDER DE QUILICHAO', 19),
('660', 'SANTA ROSA', 19),
('743', 'SILVIA', 19),
('760', 'SOTARA', 19),
('780', 'SUAREZ', 19),
('785', 'SUCRE', 19),
('807', 'TIMBIO', 19),
('809', 'TIMBIQUI', 19),
('821', 'TORIBIO', 19),
('824', 'TOTORO', 19),
('850', 'VILLARICA', 19);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('001', 'VALLEDUPAR', 20),
('011', 'AGUACHICA', 20),
('013', 'AGUSTIN CODAZZI', 20),
('032', 'ASTREA', 20),
('045', 'BECERRIL', 20),
('060', 'BOSCONIA', 20),
('175', 'CHIMICHAGUA', 20),
('178', 'CHIRIGUANA', 20),
('228', 'CURUMANI', 20),
('238', 'EL COPEY', 20),
('250', 'EL PASO', 20),
('295', 'GAMARRA', 20),
('310', 'GONZALEZ', 20),
('383', 'LA GLORIA', 20),
('400', 'LA JAGUA DE IBIRICO', 20),
('473', 'MANAURE BALCON DEL CESAR', 20),
('570', 'PAILITAS', 20),
('615', 'PELAYA', 20),
('660', 'PUEBLO BELLO', 20),
('670', 'RIO DE ORO', 20),
('700', 'LA PAZ (ROBLES)', 20),
('743', 'SAN ALBERTO', 20),
('745', 'SAN DIEGO', 20),
('750', 'SAN MARTIN', 20),
('770', 'TAMALAMEQUE', 20),
('001', 'MONTERIA', 23),
('068', 'AYAPEL', 23),
('079', 'BUENAVISTA', 23),
('090', 'CANALETE', 23),
('162', 'CERETE', 23),
('168', 'CHIMA', 23),
('182', 'CHINU', 23),
('189', 'CIENAGA DE ORO', 23),
('300', 'COTORRA', 23),
('350', 'LA APARTADA', 23),
('417', 'LORICA', 23),
('419', 'LOS CORDOBAS', 23),
('464', 'MOMIL', 23),
('466', 'MONTELIBANO', 23),
('500', 'MOÑITOS', 23),
('555', 'PLANETA RICA', 23),
('570', 'PUEBLO NUEVO', 23),
('574', 'PUERTO ESCONDIDO', 23),
('580', 'PUERTO LIBERTADOR', 23);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('586', 'PURISIMA', 23),
('660', 'SAHAGUN', 23),
('670', 'SAN ANDRES DE SOTAVENTO', 23),
('672', 'SAN ANTERO', 23),
('675', 'SAN BERNARDO DEL VIENTO', 23),
('678', 'SAN CARLOS', 23),
('686', 'SAN JOSE DE URE', 23),
('690', 'SAN PELAYO', 23),
('807', 'TIERRALTA', 23),
('855', 'VALENCIA', 23),
('001', 'AGUA DE DIOS', 25),
('019', 'ALBAN', 25),
('035', 'ANAPOIMA', 25),
('040', 'ANOLAIMA', 25),
('053', 'ARBELAEZ', 25),
('086', 'BELTRAN', 25),
('095', 'BITUIMA', 25),
('099', 'BOJACA', 25),
('120', 'CABRERA', 25),
('123', 'CACHIPAY', 25),
('126', 'CAJICA', 25),
('148', 'CAPARRAPI', 25),
('151', 'CAQUEZA', 25),
('154', 'CARMEN DE CARUPA', 25),
('168', 'CHAGUANI', 25),
('169', 'CHIA', 25),
('172', 'CHIPAQUE', 25),
('174', 'CHOACHI', 25),
('176', 'CHOCONTA', 25),
('206', 'COGUA', 25),
('214', 'COTA', 25),
('224', 'CUCUNUBA', 25),
('245', 'EL COLEGIO', 25),
('258', 'EL PEÑON', 25),
('260', 'EL ROSAL', 25),
('269', 'FACATATIVA', 25),
('279', 'FOMEQUE', 25),
('281', 'FOSCA', 25),
('286', 'FUNZA', 25),
('288', 'FUQUENE', 25),
('290', 'FUSAGASUGA', 25),
('293', 'GACHALA', 25),
('295', 'GACHANCIPA', 25),
('297', 'GACHETA', 25),
('299', 'GAMA', 25),
('307', 'GIRARDOT', 25),
('312', 'GRANADA', 25);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('317', 'GUACHETA', 25),
('320', 'GUADUAS', 25),
('322', 'GUASCA', 25),
('324', 'GUATAQUI', 25),
('326', 'GUATAVITA', 25),
('328', 'GUAYABAL DE SIQUIMA', 25),
('335', 'GUAYABETAL', 25),
('339', 'GUTIERREZ', 25),
('349', 'JERUSALEN', 25),
('352', 'JUNIN', 25),
('354', 'LA CALERA', 25),
('356', 'LA MESA', 25),
('358', 'LA PALMA', 25),
('360', 'LA PEÑA', 25),
('362', 'LA VEGA', 25),
('364', 'LENGUAZAQUE', 25),
('368', 'MACHETA', 25),
('370', 'MADRID', 25),
('372', 'MANTA', 25),
('377', 'MEDINA', 25),
('386', 'MOSQUERA', 25),
('394', 'NARIÑO', 25),
('398', 'NEMOCON', 25),
('400', 'NILO', 25),
('403', 'NIMAIMA', 25),
('405', 'NOCAIMA', 25),
('407', 'VENECIA (OSPINA PEREZ)', 25),
('426', 'PACHO', 25),
('430', 'PAIME', 25),
('436', 'PANDI', 25),
('438', 'PARATEBUENO', 25),
('444', 'PASCA', 25),
('460', 'PUERTO SALGAR', 25),
('473', 'PULI', 25),
('475', 'QUEBRADANEGRA', 25),
('477', 'QUETAME', 25),
('479', 'QUIPILE', 25),
('483', 'APULO (RAFAEL REYES)', 25),
('485', 'RICAURTE', 25),
('488', 'SAN ANTONIO DEL TEQUENDAMA', 25),
('489', 'SAN BERNARDO', 25),
('491', 'SAN CAYETANO', 25),
('494', 'SAN FRANCISCO', 25),
('500', 'SAN JUAN DE RIOSECO', 25),
('507', 'SASAIMA', 25);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('510', 'SESQUILE', 25),
('512', 'SIBATE', 25),
('514', 'SILVANIA', 25),
('516', 'SIMIJACA', 25),
('518', 'SOACHA', 25),
('520', 'SOPO', 25),
('522', 'SUBACHOQUE', 25),
('524', 'SUESCA', 25),
('526', 'SUPATA', 25),
('528', 'SUSA', 25),
('530', 'SUTATAUSA', 25),
('532', 'TABIO', 25),
('534', 'TAUSA', 25),
('536', 'TENA', 25),
('538', 'TENJO', 25),
('540', 'TIBACUY', 25),
('542', 'TIBIRITA', 25),
('546', 'TOCAIMA', 25),
('548', 'TOCANCIPA', 25),
('550', 'TOPAIPI', 25),
('554', 'UBALA', 25),
('556', 'UBAQUE', 25),
('560', 'UBATE', 25),
('562', 'UNE', 25),
('564', 'UTICA', 25),
('566', 'VERGARA', 25),
('568', 'VIANI', 25),
('570', 'VILLAGOMEZ', 25),
('572', 'VILLAPINZON', 25),
('574', 'VILLETA', 25),
('576', 'VIOTA', 25),
('578', 'YACOPI', 25),
('580', 'ZIPACON', 25),
('582', 'ZIPAQUIRA', 25),
('001', 'FLORENCIA', 18),
('141', 'ALBANIA', 18),
('221', 'BELEN DE LOS ANDAQUIES', 18),
('450', 'CARTAGENA DEL CHAIRA', 18),
('568', 'CURILLO', 18),
('615', 'EL DONCELLO', 18),
('660', 'EL PAUJIL', 18),
('745', 'LA MONTAÑITA', 18),
('798', 'MILAN', 18),
('833', 'MORELIA', 18),
('860', 'PUERTO RICO', 18),
('885', 'SAN JOSE DEL FRAGUA', 18),
('910', 'SAN VICENTE DEL CAGUAN', 18),
('940', 'SOLANO', 18),
('945', 'SOLITA', 18),
('950', 'VALPARAISO', 18);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('001', 'YOPAL', 85),
('010', 'AGUAZUL', 85),
('015', 'CHAMEZA', 85),
('125', 'HATO COROZAL', 85),
('136', 'LA SALINA', 85),
('139', 'MANI', 85),
('162', 'MONTERREY', 85),
('225', 'NUNCHIA', 85),
('230', 'OROCUE', 85),
('250', 'PAZ DE ARIPORO', 85),
('263', 'PORE', 85),
('279', 'RECETOR', 85),
('300', 'SABANALARGA', 85),
('315', 'SACAMA', 85),
('325', 'SAN LUIS DE PALENQUE', 85),
('400', 'TAMARA', 85),
('410', 'TAURAMENA', 85),
('430', 'TRINIDAD', 85),
('440', 'VILLANUEVA', 85),
('001', 'MOCOA', 86),
('219', 'COLON', 86),
('320', 'ORITO', 86),
('568', 'PUERTO ASIS', 86),
('569', 'PUERTO CAICEDO', 86),
('571', 'PUERTO GUZMAN', 86),
('573', 'LEGUIZAMO', 86),
('749', 'SIBUNDOY', 86),
('755', 'SAN FRANCISCO', 86),
('757', 'SAN MIGUEL', 86),
('760', 'SANTIAGO', 86),
('865', 'VALLE DEL GUAMUEZ', 86),
('885', 'VILLAGARZON', 86),
('001', 'SAN ANDRES', 88),
('564', 'PROVIDENCIA', 88);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('001', 'BUCARAMANGA', 68),
('013', 'AGUADA', 68),
('020', 'ALBANIA', 68),
('051', 'ARATOCA', 68),
('077', 'BARBOSA', 68),
('079', 'BARICHARA', 68),
('081', 'BARRANCABERMEJA', 68),
('092', 'BETULIA', 68),
('101', 'BOLIVAR', 68),
('121', 'CABRERA', 68),
('132', 'CALIFORNIA', 68),
('147', 'CAPITANEJO', 68),
('152', 'CARCASI', 68),
('160', 'CEPITA', 68),
('162', 'CERRITO', 68),
('167', 'CHARALA', 68),
('169', 'CHARTA', 68),
('176', 'CHIMA', 68),
('179', 'CHIPATA', 68),
('190', 'CIMITARRA', 68),
('207', 'CONCEPCION', 68),
('209', 'CONFINES', 68),
('211', 'CONTRATACION', 68),
('217', 'COROMORO', 68),
('229', 'CURITI', 68),
('235', 'EL CARMEN DE CHUCURI', 68),
('245', 'EL GUACAMAYO', 68),
('250', 'EL PEÑON', 68),
('255', 'EL PLAYON', 68),
('264', 'ENCINO', 68),
('266', 'ENCISO', 68),
('271', 'FLORIAN', 68),
('276', 'FLORIDABLANCA', 68),
('296', 'GALAN', 68),
('298', 'GAMBITA', 68),
('307', 'GIRON', 68),
('318', 'GUACA', 68),
('320', 'GUADALUPE', 68),
('322', 'GUAPOTA', 68),
('324', 'GUAVATA', 68),
('327', 'GsME', 68);  


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('344', 'HATO', 68),
('349', 'JESUS MARIA', 68),
('352', 'JORDAN', 68),
('368', 'LA BELLEZA', 68),
('370', 'LA PAZ', 68),
('377', 'LANDAZURI', 68),
('385', 'LEBRIJA', 68),
('397', 'LOS SANTOS', 68),
('406', 'MACARAVITA', 68),
('418', 'MALAGA', 68),
('425', 'MATANZA', 68),
('432', 'MOGOTES', 68),
('433', 'MOLAGAVITA', 68),
('444', 'OCAMONTE', 68),
('445', 'OIBA', 68),
('447', 'ONZAGA', 68),
('464', 'PALMAR', 68),
('468', 'PALMAS DEL SOCORRO', 68),
('476', 'PARAMO', 68),
('480', 'PIEDECUESTA', 68),
('491', 'PINCHOTE', 68),
('494', 'PUENTE NACIONAL', 68),
('498', 'PUERTO PARRA', 68),
('500', 'PUERTO WILCHES', 68),
('502', 'RIONEGRO', 68),
('522', 'SABANA DE TORRES', 68),
('535', 'SAN ANDRES', 68),
('540', 'SAN BENITO', 68),
('543', 'SAN GIL', 68),
('549', 'SAN JOAQUIN', 68),
('552', 'SAN JOSE DE MIRANDA', 68),
('554', 'SAN MIGUEL', 68),
('556', 'SAN VICENTE DE CHUCURI', 68),
('568', 'SANTA BARBARA', 68),
('573', 'SANTA HELENA DEL OPON', 68),
('594', 'SIMACOTA', 68),
('612', 'SOCORRO', 68),
('622', 'SUAITA', 68),
('647', 'TONA', 68),
('650', 'VALLE DE SAN JOSE', 68),
('655', 'VELEZ', 68),
('669', 'VILLANUEVA', 68),
('673', 'ZAPATOCA', 68);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('001', 'SINCELEJO', 70),
('110', 'BUENAVISTA', 70),
('124', 'CAIMITO', 70),
('204', 'COLOSO', 70),
('215', 'COROZAL', 70),
('221', 'COVEÑAS', 70),
('230', 'CHALAN', 70),
('233', 'EL ROBLE', 70),
('235', 'GALERAS', 70),
('265', 'GUARANDA', 70),
('400', 'LA UNION', 70),
('418', 'LOS PALMITOS', 70),
('429', 'MAJAGUAL', 70),
('473', 'MORROA', 70),
('508', 'OVEJAS', 70),
('523', 'PALMITO', 70),
('670', 'SAMPUES', 70),
('678', 'SAN BENITO ABAD', 70),
('702', 'SAN JUAN DE BETULIA', 70),
('708', 'SAN MARCOS', 70),
('713', 'SAN ONOFRE', 70),
('717', 'SAN PEDRO', 70),
('742', 'SINCE', 70),
('771', 'SUCRE', 70),
('820', 'TOLU', 70),
('823', 'TOLUVIEJO', 70),
('001', 'IBAGUE', 73),
('024', 'ALPUJARRA', 73),
('026', 'ALVARADO', 73),
('030', 'AMBALEMA', 73),
('043', 'ANZOATEGUI', 73),
('055', 'ARMERO', 73),
('067', 'ATACO', 73),
('124', 'CARMEN DE APICALA', 73),
('128', 'CASABIANCA', 73),
('152', 'CHAPARRAL', 73),
('168', 'COELLO', 73),
('200', 'COYAIMA', 73),
('217', 'CUNDAY', 73),
('226', 'DOLORES', 73),
('236', 'ESPINAL', 73),
('268', 'FALAN', 73),
('270', 'FLANDES', 73),
('275', 'FRESNO', 73),
('283', 'GUAMO', 73);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('319', 'HERVEO', 73),
('347', 'HONDA', 73),
('349', 'ICONONZO', 73),
('352', 'LÉRIDA', 73),
('355', 'LÍBANO', 73),
('360', 'SAN SEBASTIÁN DE MARIQUITA', 73),
('370', 'MELGAR', 73),
('372', 'MURILLO', 73),
('408', 'NATAGAIMA', 73),
('420', 'ORTEGA', 73),
('443', 'PALOCABILDO', 73),
('449', 'PIEDRAS', 73),
('461', 'PLANADAS', 73),
('467', 'PRADO', 73),
('491', 'PURIFICACIÓN', 73),
('500', 'RIOBLANCO', 73),
('520', 'RONCESVALLES', 73),
('523', 'ROVIRA', 73),
('550', 'SALDAÑA', 73),
('574', 'SAN ANTONIO', 73),
('585', 'SAN LUIS', 73),
('592', 'SANTA ISABEL', 73),
('594', 'SUÁREZ', 73),
('616', 'VALLE DE SAN JUAN', 73),
('622', 'VENADILLO', 73),
('624', 'VILLAHERMOSA', 73),
('627', 'VILLARRICA', 73),
('001', 'CALI', 76),
('020', 'ALCALÁ', 76),
('036', 'ANDALUCÍA', 76),
('041', 'ANSERMANUEVO', 76),
('054', 'ARGELIA', 76),
('100', 'BOLÍVAR', 76),
('109', 'BUENAVENTURA', 76),
('111', 'GUADALAJARA DE BUGA', 76),
('113', 'BUGALAGRANDE', 76),
('122', 'CAICEDONIA', 76),
('126', 'CALIMA (DARIÉN)', 76),
('130', 'CANDELARIA', 76),
('147', 'CARTAGO', 76),
('233', 'DAGUA', 76),
('243', 'EL ÁGUILA', 76),
('246', 'EL CAIRO', 76),
('248', 'EL CERRITO', 76);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('250', 'EL DOVIO', 76),
('275', 'FLORIDA', 76),
('306', 'GINEBRA', 76),
('318', 'GUACARÍ', 76),
('364', 'JAMUNDÍ', 76),
('377', 'LA CUMBRE', 76),
('400', 'LA UNIÓN', 76),
('403', 'LA VICTORIA', 76),
('497', 'OBANDO', 76),
('520', 'PALMIRA', 76),
('563', 'PRADERA', 76),
('606', 'RESTREPO', 76),
('616', 'ROLDANILLO', 76),
('670', 'SAN PEDRO', 76),
('676', 'SEVILLA', 76),
('701', 'TORO', 76),
('704', 'TRUJILLO', 76),
('706', 'TULUÁ', 76),
('708', 'ULLOA', 76),
('711', 'VERSALLES', 76),
('713', 'VIJES', 76),
('760', 'YOTOCO', 76),
('761', 'YUMBO', 76),
('763', 'ZARZAL', 76),
('001', 'ARAUCA', 81),
('065', 'ARAUQUITA', 81),
('220', 'CRAVO NORTE', 81),
('300', 'FORTUL', 81),
('591', 'PUERTO RONDÓN', 81),
('736', 'SARAVENA', 81),
('794', 'TAME', 81),
('001', 'YOPAL', 85),
('010', 'AGUAZUL', 85),
('015', 'CHÁMEZA', 85),
('125', 'HATO COROZAL', 85),
('136', 'LA SALINA', 85),
('139', 'MANÍ', 85),
('162', 'MONTERREY', 85),
('225', 'NUNCHÍA', 85),
('230', 'OROCUÉ', 85),
('250', 'PAZ DE ARIPORO', 85),
('263', 'PORE', 85),
('279', 'RECETOR', 85),
('300', 'SABANALARGA', 85);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('315', 'SÁCAMA', 85),
('325', 'SAN LUIS DE PALENQUE', 85),
('400', 'TÁMARA', 85),
('410', 'TAURAMENA', 85),
('430', 'TRINIDAD', 85),
('440', 'VILLANUEVA', 85),
('001', 'MOCOA', 86),
('219', 'COLÓN', 86),
('320', 'ORITO', 86),
('568', 'PUERTO ASÍS', 86),
('569', 'PUERTO CAICEDO', 86),
('573', 'PUERTO GUZMÁN', 86),
('749', 'SAN FRANCISCO', 86),
('755', 'SAN MIGUEL', 86),
('757', 'SANTIAGO', 86),
('760', 'SIBUNDOY', 86),
('865', 'VALLE DEL GUAMUEZ', 86),
('885', 'VILLAGARZÓN', 86),
('001', 'SAN ANDRÉS', 88),
('564', 'PROVIDENCIA', 88),
('001', 'LETICIA', 91),
('263', 'PUERTO ALEGRÍA', 91),
('405', 'PUERTO ARICA', 91),
('407', 'PUERTO NARIÑO', 91),
('430', 'LA CHORRERA', 91),
('460', 'LA PEDRERA', 91),
('530', 'LA VICTORIA', 91),
('536', 'MIRITI - PARANÁ', 91),
('540', 'PUERTO SANTANDER', 91),
('669', 'TARAPACÁ', 91),
('777', 'PUERTO COLOMBIA', 91),
('001', 'INÍRIDA', 94),
('343', 'BARRANCO MINAS', 94),
('883', 'MAPIRIPANA', 94),
('884', 'SAN FELIPE', 94),
('885', 'PUERTO COLOMBIA', 94),
('886', 'LA GUADALUPE', 94),
('887', 'CACAHUAL', 94),
('888', 'PANA PANA', 94),
('889', 'MORICHAL', 94),
('001', 'SAN JOSÉ DEL GUAVIARE', 95),
('015', 'CALAMAR', 95);


INSERT INTO cities_municipalities (code, name, state_region_id) VALUES
('025', 'EL RETORNO', 95),
('200', 'MIRAFLORES', 95),
('001', 'MITÚ', 97),
('161', 'CARURÚ', 97),
('511', 'PACOA', 97),
('666', 'TARAIRA', 97),
('777', 'PAPUNAUA', 97),
('889', 'YAVARATÉ', 97),
('001', 'PUERTO CARREÑO', 99),
('524', 'LA PRIMAVERA', 99),
('624', 'SANTA ROSALÍA', 99),
('773', 'CUMARIBO', 99);

4. tipos de identificacion

INSERT INTO type_identifications (description, suffix)
VALUES ('Cédula de ciudadanía', 'CC'),
       ('NIT', 'NI');

5. Audiencias

INSERT INTO audiences (description) VALUES 
('Consumidor final'),      
('Mayorista'),            
('Restaurante'),
('Empresarial'),
('Jóvenes'),
('Adultos'),
('Adultos Mayores');


6. Clientes

INSERT INTO customers (name, city_id, audience_id, cellphone, email, address) VALUES 
('Luisa Arciniegas', 742, 1, '57-73001234567', 'ana@example.com',  'Cra 10 #20‑30'),
('Luis Moreno', 121, 2, '57-43009876543', 'carlos@example.com', 'Cl 5 #7‑15'),
('Panaderia Delicias', 742, 3, '57-73015550000', 'contacto@delicias.co', 'Av 80 #45‑10'),

('jose figueredo ', 345, 1, '3000000001', 'josef@example.com', 'Dir 1'),
('jose solano ',456, 1, '3000000002', 'joseso@example.com', 'Dir 2'),
('jose rivera ',745, 1, '3000000003', 'joseri@example.com', 'Dir 3'),
('camilo corzo  ', 750, 1, '3000000004', 'camilocor@example.com', 'Dir 4'),
('camilo benavides  ', 769, 1, '3000000005', 'camiloben@example.com', 'Dir 5'),
('luis parra ', 780, 1, '3000000006', 'luispa@example.com', 'Dir 6'),
('jose  parra', 790, 1, '3000000007', 'josepa@example.com', 'Dir 7'),
('carlos pinilla ', 1000, 1, '3000000008', 'carlospi@example.com', 'Dir 8'),
('maicol sanches  ', 560, 1, '3000000009', 'maicolsan@example.com', 'Dir 9'),
('pedro parra ', 320, 1, '3000000010', 'pedropar@example.com', 'Dir 10'),
('arnulfo lopes ', 690, 1, '3000000011', 'arnulfolo@example.com', 'Dir 11');

7. Categorias y unidades

INSERT INTO categories (name, description)
VALUES ('Bebidas', 'Licores y refrescos'),
       ('Lácteos',  'Derivados de la leche');

INSERT INTO unit_of_measure (description)
VALUES ('Litro'),
       ('Kilogramo'),
       ('Unidad');

8. Productos

ALTER TABLE products ADD COLUMN updated_at DATETIME DEFAULT NOW() ON UPDATE NOW();
ALTER TABLE products ADD COLUMN unit_id INT;
ALTER TABLE products ADD CONSTRAINT fk_unit_id FOREIGN KEY (unit_id) REFERENCES unit_of_measure(id);

INSERT INTO products (name, detail, price, category_id, image) VALUES 
('Jugo de Naranja', 'Natural 1 L', 4.50, 1, NULL),
('Leche Entera',     'Bolsa 1 L', 1.10, 2, NULL),
('Queso Fresco',     'Paquete 500 g', 3.90, 2, NULL),
('Queso crema', 'Muy popular', 9.99, 1, 'img.jpg'),
('cuajada','muy rica',10.0,1),
('jugo de mandarina','refrescante',10.0,1);


9. Empresas

ALTER TABLE companies ADD COLUMN updated_at DATETIME;

INSERT INTO companies (name, type_id, category_id, city_id, audience_id, cellphone, email)
VALUES 
('Distribuidora ABC', 2, 1, 742, 2, '3020001111', 'ventas@abc.com'),
('Lácteos La Granja', 2, 2, 760, 2, '3020002222', 'contacto@lagranja.co'),
('Empresa SinCalificación', 1, 1, 450, 1, '3000000000', 'sinrate@ejemplo.com');

10. Asosiacion de productos a empresas

INSERT INTO company_products (company_id, product_id, price, unitmeasure_id)
VALUES 
(3, 1, 4.20, 1),
(4, 2, 1.05, 1),
(4, 3, 3.75, 2),
(3, 1, 10.00, 1),
(4, 4, 12.00, 1),
(4, 5, 13.44, 1),
(4, 6, 14.00, 1),
(4, 1, 12.00, 1);

11. Encuestas y calificaciones

INSERT INTO polls (name, description, is_active, categorypoll_id)
VALUES ('Satisfacción General', 'Encuesta 2025', 1, NULL);

ALTER TABLE rates ADD COLUMN product_id INT, ADD FOREIGN KEY (product_id) REFERENCES products(id);

INSERT INTO rates (customer_id, company_id, poll_id, date_rating, rating, product_id)
VALUES 
(4, 4, 1, NOW() - INTERVAL 10 DAY, 4.5, 1),
(5, 3, 1, NOW() - INTERVAL 5 DAY, 4.0, 2);

INSERT INTO quality_products (product_id, customer_id, poll_id, company_id, date_rating, rating)
VALUES 
(1, 4, 1, 3, NOW() - INTERVAL 10 DAY, 4.7),
(2, 5, 1, 4, NOW() - INTERVAL 5  DAY, 4.2);


12. Favoritos

INSERT INTO favorites (customer_id, company_id)
VALUES (6, 3), (4, 4);

INSERT INTO details_favorites (favorite_id, product_id)
VALUES (1, 1), (2, 2), (2, 3);

-- Masivo para clientes nuevos:
INSERT INTO favorites (customer_id, company_id)
SELECT id, 3 FROM customers;

-- Relación masiva:
INSERT INTO details_favorites (favorite_id, product_id)
SELECT f.id, 4 FROM favorites f;

INSERT INTO details_favorites (favorite_id, product_id)
VALUES (24, 1), (24, 2);


13. Membresias y beneficios

INSERT INTO memberships (name, description)
VALUES 
('Gold',  'Plan Gold'),
('Plan Básico', 'Acceso limitado sin beneficios'),
('Plan Premium', 'Acceso completo con beneficios');

INSERT INTO periods (name) VALUES ('Anual'), ('Mensual');

INSERT INTO membership_periods (membership_id, period_id, price)
VALUES (1, 1, 199.00);

ALTER TABLE membership_periods 
ADD COLUMN fecha_inicio DATE,
ADD COLUMN fecha_fin DATE,
ADD COLUMN pago_confirmado BOOLEAN,
ADD COLUMN start_date DATE,
ADD COLUMN end_date DATE,
ADD COLUMN status VARCHAR(20) DEFAULT 'ACTIVA';

INSERT INTO membership_periods (membership_id, period_id, price, fecha_inicio, fecha_fin, pago_confirmado) VALUES 
(2, 2, 31.63, '2025-05-22', '2025-06-21', TRUE),
(1, 2, 47.49, '2025-06-20', '2025-07-20', TRUE),
(2, 2, 15.01, '2025-05-18', '2025-06-17', TRUE),
(1, 2, 14.75, '2025-06-09', '2025-07-09', FALSE),
(3, 2, 27.8,  '2025-06-04', '2025-07-04', TRUE),
(2, 2, 35.07, '2025-05-22', '2025-06-21', TRUE);

14. Beneficios por membresia y audiencia

INSERT INTO benefits (description, detail) VALUES 
('Descuento 10 %', 'Aplica sobre todos los productos'),
('Descuento del 10%', 'Aplica a todos los productos'),
('Envío gratis', 'Solo para ciudades principales'),
('Atención preferencial', 'Acceso rápido a soporte');

INSERT INTO membership_benefits (membership_id, period_id, audience_id, benefit_id)
VALUES 
(1, 1, 1, 1),
(2, 1, 1, 1);

INSERT INTO audience_benefits(audience_id, benefit_id)
VALUES (8, 1), (9, 2), (10, 3), (9, 1), (8, 2);

15. Respuestas a encuestas

INSERT INTO poll_responses (poll_id, question_id, customer_id, response)
VALUES 
(1, 1, 4, 'Muy satisfecho'),
(1, 2, 5, 'Excelente'),
(1, 3, 6, 'Sí, la recomendaría');


