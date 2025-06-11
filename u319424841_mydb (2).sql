-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 11-06-2025 a las 18:39:16
-- Versión del servidor: 10.11.10-MariaDB-log
-- Versión de PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u319424841_mydb`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'Usuario que solicita el turno',
  `agent_id` int(11) DEFAULT NULL COMMENT 'Agente (admin) asignado al turno',
  `appointment_datetime` datetime NOT NULL COMMENT 'Fecha y hora exacta del turno',
  `subject` varchar(255) NOT NULL,
  `notes` text DEFAULT NULL COMMENT 'Notas adicionales del usuario',
  `status` enum('PENDIENTE','CONFIRMADO','CANCELADO','COMPLETADO') NOT NULL DEFAULT 'PENDIENTE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Turnos para consultas con agentes de viaje';

--
-- Volcado de datos para la tabla `appointments`
--

INSERT INTO `appointments` (`id`, `user_id`, `agent_id`, `appointment_datetime`, `subject`, `notes`, `status`, `created_at`) VALUES
(1, 4, 1, '2025-07-15 10:00:00', 'Consulta sobre viaje a Europa', NULL, 'CONFIRMADO', '2025-06-11 00:10:58'),
(2, 5, 2, '2025-07-18 15:30:00', 'Planificación Luna de Miel', NULL, 'PENDIENTE', '2025-06-11 00:10:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `blog_posts`
--

CREATE TABLE `blog_posts` (
  `id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(270) NOT NULL,
  `content` text NOT NULL,
  `cover_image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `blog_posts`
--

INSERT INTO `blog_posts` (`id`, `author_id`, `title`, `slug`, `content`, `cover_image_url`, `created_at`, `updated_at`) VALUES
(1, 1, '5 Consejos para tu primer viaje a Europa', '5-consejos-europa', 'Europa es un continente lleno de historia, cultura y diversidad...', NULL, '2025-06-11 00:10:58', '2025-06-11 00:10:58'),
(2, 2, 'La Magia de la Patagonia Argentina', 'magia-patagonia-argentina', 'Desde el Glaciar Perito Moreno hasta los Siete Lagos, la Patagonia te dejará sin aliento...', NULL, '2025-06-11 00:10:58', '2025-06-11 00:10:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `blog_post_tags`
--

CREATE TABLE `blog_post_tags` (
  `post_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `blog_tags`
--

CREATE TABLE `blog_tags` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_type` varchar(50) NOT NULL,
  `departure_id` int(11) DEFAULT NULL,
  `product_table` varchar(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `price_at_add` decimal(10,2) NOT NULL,
  `product_options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Opciones adicionales del producto (departure_id, etc)' CHECK (json_valid(`product_options`)),
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Carrito de compras persistente';

--
-- Volcado de datos para la tabla `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `item_id`, `item_type`, `departure_id`, `product_table`, `product_id`, `quantity`, `price_at_add`, `product_options`, `added_at`) VALUES
(5, 7, 5, 'PACKAGE', 20, '', 0, 1, 420000.00, NULL, '2025-06-11 18:29:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `car_rentals`
--

CREATE TABLE `car_rentals` (
  `id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `model` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `pickup_location_id` int(11) NOT NULL,
  `transmission` enum('MANUAL','AUTOMATIC') DEFAULT 'MANUAL',
  `seats` int(11) DEFAULT 4
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Información detallada de alquiler de autos';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `slug` varchar(110) NOT NULL COMMENT 'URL amigable para SEO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `slug`) VALUES
(1, 'Destacados', NULL, 'destacados'),
(2, 'Escapadas', NULL, 'escapadas'),
(3, 'Playas del Mundo', NULL, 'playas-del-mundo'),
(4, 'Circuitos Europeos', NULL, 'circuitos-europeos'),
(5, 'Gastronomía', NULL, 'gastronomia');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `flights`
--

CREATE TABLE `flights` (
  `id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL COMMENT 'Aerolínea',
  `flight_number` varchar(20) NOT NULL,
  `origin_id` int(11) NOT NULL,
  `destination_id` int(11) NOT NULL,
  `departure_time` datetime NOT NULL,
  `arrival_time` datetime NOT NULL,
  `price_economy` decimal(10,2) DEFAULT NULL,
  `price_business` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Información de vuelos individuales';

--
-- Volcado de datos para la tabla `flights`
--

INSERT INTO `flights` (`id`, `supplier_id`, `flight_number`, `origin_id`, `destination_id`, `departure_time`, `arrival_time`, `price_economy`, `price_business`) VALUES
(1, 1, 'AR2460', 1, 7, '2025-07-10 08:00:00', '2025-07-10 10:00:00', 120000.00, NULL),
(2, 1, 'AR2465', 7, 1, '2025-07-13 15:00:00', '2025-07-13 16:40:00', 120000.00, NULL),
(3, 1, 'AR1680', 1, 4, '2025-07-15 09:00:00', '2025-07-15 11:30:00', 180000.00, NULL),
(4, 1, 'AR1689', 4, 1, '2025-07-21 18:00:00', '2025-07-21 20:30:00', 180000.00, NULL),
(5, 1, 'AR1682', 1, 4, '2025-08-15 09:00:00', '2025-08-15 11:30:00', 200000.00, NULL),
(6, 1, 'AR1691', 4, 1, '2025-08-21 18:00:00', '2025-08-21 20:30:00', 200000.00, NULL),
(7, 2, 'LA4014', 1, 3, '2025-07-20 23:50:00', '2025-07-21 06:20:00', 450000.00, NULL),
(8, 2, 'LA4015', 3, 1, '2025-07-29 08:20:00', '2025-07-29 18:30:00', 450000.00, NULL),
(9, 2, 'LA4016', 1, 3, '2025-08-20 23:50:00', '2025-08-21 06:20:00', 500000.00, NULL),
(10, 2, 'LA4017', 3, 1, '2025-08-29 08:20:00', '2025-08-29 18:30:00', 500000.00, NULL),
(11, 3, 'IB6842', 1, 2, '2025-09-01 20:45:00', '2025-09-02 12:50:00', 650000.00, NULL),
(12, 3, 'IB3232', 2, 5, '2025-09-06 15:30:00', '2025-09-06 18:00:00', 150000.00, NULL),
(13, 3, 'IB6845', 5, 1, '2025-09-12 13:30:00', '2025-09-13 00:15:00', 650000.00, NULL),
(14, 1, 'AR1720', 1, 8, '2025-07-10 07:00:00', '2025-07-10 09:00:00', 120000.00, NULL),
(15, 1, 'AR1725', 8, 1, '2025-07-14 19:00:00', '2025-07-14 21:00:00', 120000.00, NULL),
(16, 1, 'AR1870', 1, 9, '2025-08-05 05:30:00', '2025-08-05 09:20:00', 220000.00, NULL),
(17, 1, 'AR1871', 9, 1, '2025-08-10 20:00:00', '2025-08-10 23:45:00', 220000.00, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hotels`
--

CREATE TABLE `hotels` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `location_id` int(11) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `rating` tinyint(1) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Información detallada de hoteles';

--
-- Volcado de datos para la tabla `hotels`
--

INSERT INTO `hotels` (`id`, `name`, `description`, `location_id`, `supplier_id`, `rating`, `address`) VALUES
(1, 'Hilton Buenos Aires', NULL, 1, 4, 5, 'Macacha Güemes 351, CABA'),
(2, 'Riu Palace Las Americas', NULL, 3, NULL, 5, 'Blvd. Kukulcan, Km 8.5, Zona Hotelera'),
(3, 'Hotel Llao Llao', NULL, 4, NULL, 5, 'Av. Ezequiel Bustillo Km. 25, Bariloche'),
(4, 'The Westin Palace, Madrid', NULL, 2, 5, 5, 'Plaza de las Cortes, 7, Madrid'),
(5, 'Park Hyatt Mendoza', NULL, 7, NULL, 5, 'Chile 1124, Mendoza'),
(6, 'Hotel de Russie', 'Elegante hotel 5 estrellas ubicado entre Piazza del Popolo y la escalinata de Plaza España', 5, 5, 5, 'Via del Babuino 9, Roma'),
(7, 'Hotel Meliá Iguazú', 'Hotel de lujo ubicado dentro del Parque Nacional Iguazú con vista directa a las cataratas', 8, NULL, 5, 'Parque Nacional Iguazú, Misiones'),
(8, 'Los Cauquenes Resort & Spa', 'Resort de lujo frente al Canal Beagle con spa y gastronomía de primer nivel', 9, NULL, 5, 'Reinamora 3462, Ushuaia');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `itineraries`
--

CREATE TABLE `itineraries` (
  `id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `day_number` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Plan día por día para los paquetes turísticos';

--
-- Volcado de datos para la tabla `itineraries`
--

INSERT INTO `itineraries` (`id`, `package_id`, `day_number`, `title`, `description`) VALUES
(1, 1, 1, 'Llegada y Circuito Chico', 'Recepción en el aeropuerto y traslado al hotel. Por la tarde, excursión por el famoso Circuito Chico.'),
(2, 1, 2, 'Cerro Catedral', 'Día completo de ski y actividades de nieve en el Cerro Catedral.'),
(3, 1, 3, 'Navegación a Isla Victoria', 'Excursión lacustre a la Isla Victoria y Bosque de Arrayanes.'),
(4, 3, 1, 'Llegada a Madrid', 'Vuelo nocturno con destino a Madrid. Noche a bordo.'),
(5, 3, 2, 'City Tour en Madrid', 'Llegada al aeropuerto de Barajas. Traslado al hotel The Westin Palace. Tarde libre para descansar o dar un primer paseo por la Gran Vía.'),
(6, 3, 6, 'Vuelo a Roma y Coliseo', 'Traslado al aeropuerto para volar a Roma. Por la tarde, visita al majestuoso Coliseo Romano.'),
(7, 4, 2, 'Tour de Bodegas - Maipú', 'Desayuno en el hotel. Excursión de día completo visitando las prestigiosas bodegas de Maipú. Incluye degustación de vinos premium, almuerzo maridaje y visita a viñedos. Regreso al hotel por la tarde.'),
(8, 4, 3, 'Alta Montaña y Aconcagua', 'Desayuno en el hotel. Excursión de día completo a la Cordillera de los Andes. Visitaremos Potrerillos, Uspallata, Puente del Inca y el Parque Provincial Aconcagua con vista al cerro más alto de América. Almuerzo incluido.'),
(9, 4, 4, 'Tiempo libre y regreso', 'Desayuno en el hotel. Mañana libre para actividades opcionales o compras. Check-out y traslado al aeropuerto para tomar el vuelo de regreso a Buenos Aires.'),
(10, 2, 1, 'Llegada a Cancún', 'Arribo al aeropuerto internacional de Cancún. Recepción y traslado al hotel Riu Palace Las Americas. Check-in y día libre para disfrutar de las instalaciones del resort.'),
(11, 2, 2, 'Día de Playa y Resort', 'Día completo para disfrutar de las playas de arena blanca y las múltiples piscinas del resort. Todas las comidas y bebidas incluidas.'),
(12, 2, 3, 'Excursión Opcional a Chichén Itzá', 'Día libre o excursión opcional (no incluida) a Chichén Itzá, una de las 7 maravillas del mundo moderno.'),
(13, 2, 5, 'Actividades Acuáticas', 'Disfruta de deportes acuáticos no motorizados incluidos: kayak, snorkel, paddleboard. Clases de aqua aeróbicos en la piscina.'),
(14, 2, 10, 'Check out y Regreso', 'Desayuno buffet. Check-out y traslado al aeropuerto para tomar el vuelo de regreso a Buenos Aires.'),
(15, 3, 3, 'Tour por Toledo', 'Excursión de día completo a Toledo, la ciudad de las tres culturas. Visita guiada por el casco histórico, la Catedral y el barrio judío.'),
(16, 3, 4, 'Museos de Madrid', 'Mañana: Visita guiada al Museo del Prado. Tarde libre para visitar el Parque del Retiro o realizar compras.'),
(17, 3, 5, 'Madrid Gastronómico', 'Tour gastronómico por los mercados tradicionales. Degustación de tapas en el Mercado de San Miguel. Tarde libre.'),
(18, 3, 7, 'Vaticano y Capilla Sixtina', 'Tour guiado por los Museos Vaticanos, la Capilla Sixtina y la Basílica de San Pedro. Tarde: Piazza Navona y Panteón.'),
(19, 3, 8, 'Roma Imperial', 'Visita al Foro Romano y Palatino con guía experto. Tarde libre para compras en Via del Corso.'),
(20, 3, 9, 'Tívoli y Villa Adriana', 'Excursión a Tívoli para visitar Villa Adriana y Villa d Este, patrimonio de la UNESCO.'),
(21, 3, 10, 'Trastevere y tiempo libre', 'Mañana: Paseo por el pintoresco barrio de Trastevere. Tarde libre para últimas compras o visitas.'),
(22, 3, 11, 'Último día en Roma', 'Día libre. Sugerimos visitar Castel Sant Angelo o simplemente disfrutar de un último gelato en Piazza di Spagna.'),
(23, 3, 12, 'Regreso a Buenos Aires', 'Traslado al aeropuerto de Fiumicino para tomar el vuelo de regreso. Llegada a Buenos Aires por la noche.'),
(24, 5, 1, 'Llegada a Iguazú', 'Vuelo por la mañana. Recepción en el aeropuerto y traslado al hotel. Tarde libre para descansar o visitar el Hito de las Tres Fronteras.'),
(25, 5, 2, 'Cataratas Lado Argentino', 'Día completo recorriendo el lado argentino. Circuitos Superior e Inferior. Tren Ecológico hasta la Garganta del Diablo. Sendero Macuco opcional.'),
(26, 5, 3, 'Cataratas Lado Brasileño y Gran Aventura', 'Mañana: Vista panorámica desde el lado brasileño. Tarde: Aventura en lancha bajo las cataratas (Gran Aventura).'),
(27, 5, 4, 'Ruinas de San Ignacio', 'Excursión a las Ruinas Jesuíticas de San Ignacio, Patrimonio de la Humanidad. Visita a las Minas de Wanda.'),
(28, 5, 5, 'Regreso a Buenos Aires', 'Mañana libre. Check out y traslado al aeropuerto. Vuelo de regreso por la tarde.'),
(29, 6, 1, 'Llegada al Fin del Mundo', 'Arribo a Ushuaia. Traslado al hotel con vista al Canal Beagle. Tarde libre para recorrer la ciudad más austral del mundo.'),
(30, 6, 2, 'Navegación Canal Beagle', 'Navegación por el mítico Canal Beagle. Avistaje de lobos marinos, cormoranes y el emblemático Faro Les Eclaireurs. Isla Martillo con pingüinos (en temporada).'),
(31, 6, 3, 'Parque Nacional y Tren del Fin del Mundo', 'Excursión al Parque Nacional Tierra del Fuego. Viaje en el histórico Tren del Fin del Mundo. Bahía Lapataia, el fin de la Ruta 3.'),
(32, 6, 4, 'Lagos Escondido y Fagnano', 'Travesía 4x4 atravesando los Andes Fueguinos. Visita a los lagos Escondido y Fagnano. Almuerzo típico patagónico incluido.'),
(33, 6, 5, 'Día libre', 'Día libre. Opcionales: sobrevuelo en helicóptero, trekking al Glaciar Martial o visita al Museo del Presidio.'),
(34, 6, 6, 'Regreso', 'Tiempo libre hasta el horario del traslado al aeropuerto. Vuelo de regreso a Buenos Aires.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `city` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `airport_code` varchar(10) DEFAULT NULL COMMENT 'Código IATA del aeropuerto'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Ubicaciones geográficas (ciudades, países, aeropuertos)';

--
-- Volcado de datos para la tabla `locations`
--

INSERT INTO `locations` (`id`, `city`, `country`, `airport_code`) VALUES
(1, 'Buenos Aires', 'Argentina', 'EZE'),
(2, 'Madrid', 'España', 'MAD'),
(3, 'Cancún', 'México', 'CUN'),
(4, 'Bariloche', 'Argentina', 'BRC'),
(5, 'Roma', 'Italia', 'FCO'),
(6, 'París', 'Francia', 'CDG'),
(7, 'Mendoza', 'Argentina', 'MDZ'),
(8, 'Puerto Iguazú', 'Argentina', 'IGR'),
(9, 'Ushuaia', 'Argentina', 'USH');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'Usuario que recibe la notificación',
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `link_url` varchar(255) DEFAULT NULL COMMENT 'URL para redirigir al hacer clic',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `related_table` varchar(50) DEFAULT NULL COMMENT 'Ej: "appointments", "orders"',
  `related_id` int(11) DEFAULT NULL COMMENT 'ID en la tabla relacionada'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Notificaciones para los usuarios (recordatorios, etc.)';

--
-- Volcado de datos para la tabla `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `link_url`, `is_read`, `created_at`, `related_table`, `related_id`) VALUES
(1, 4, 'Recordatorio de Turno', 'No olvides tu turno con nuestro agente mañana a las 10:00 AM.', NULL, 0, '2025-06-11 00:10:58', 'appointments', 1),
(2, 3, 'Confirmación de Compra', 'Tu compra del paquete \"Ruta del Vino\" ha sido recibida y está pendiente de pago.', NULL, 0, '2025-06-11 00:10:58', 'orders', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Cabecera de las órdenes de compra';

--
-- Volcado de datos para la tabla `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `order_date`, `total_amount`) VALUES
(1, 3, '2025-06-11 00:10:58', 550000.00),
(2, 4, '2025-06-11 00:10:58', 1500000.00),
(3, 3, '2025-06-11 00:10:58', 380000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_table` varchar(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `price_at_purchase` decimal(10,2) NOT NULL,
  `product_summary` text DEFAULT NULL COMMENT 'Snapshot en JSON del producto al comprar'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Detalle de productos por cada orden';

--
-- Volcado de datos para la tabla `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_table`, `product_id`, `quantity`, `price_at_purchase`, `product_summary`) VALUES
(1, 1, 'packages', 1, 2, 275000.00, '{\"name\": \"Escapada a Bariloche\", \"duration\": 7}'),
(2, 2, 'packages', 2, 2, 750000.00, '{\"name\": \"Todo Incluido en Cancún\", \"duration\": 10}'),
(3, 3, 'packages', 4, 1, 380000.00, '{\"name\": \"Ruta del Vino en Mendoza\", \"duration\": 4}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `order_passengers`
--

CREATE TABLE `order_passengers` (
  `id` int(11) NOT NULL,
  `order_item_id` int(11) NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `document_type` varchar(50) DEFAULT NULL,
  `document_number` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Información de los pasajeros de una orden';

--
-- Volcado de datos para la tabla `order_passengers`
--

INSERT INTO `order_passengers` (`id`, `order_item_id`, `full_name`, `document_type`, `document_number`) VALUES
(1, 1, 'Juan Pérez', NULL, NULL),
(2, 1, 'María González', NULL, NULL),
(3, 2, 'Ana García', NULL, NULL),
(4, 2, 'Pedro Rodríguez', NULL, NULL),
(5, 3, 'Juan Pérez', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `packages`
--

CREATE TABLE `packages` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `duration_days` int(11) NOT NULL,
  `base_price` decimal(10,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `departure_city` varchar(100) DEFAULT NULL,
  `destination_city` varchar(100) DEFAULT NULL,
  `includes_description` text DEFAULT NULL COMMENT 'Descripción detallada de lo que incluye'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Paquetes turísticos compuestos por otros productos';

--
-- Volcado de datos para la tabla `packages`
--

INSERT INTO `packages` (`id`, `name`, `description`, `image_url`, `duration_days`, `base_price`, `is_active`, `departure_city`, `destination_city`, `includes_description`) VALUES
(1, 'Escapada a Bariloche', 'Disfruta de la nieve y los lagos del sur argentino. Un viaje inolvidable.', 'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=2070&auto=format&fit=crop', 7, 550000.00, 1, 'Buenos Aires', 'Bariloche', 'Aéreos Buenos Aires/Bariloche/Buenos Aires|Incluye Equipaje Carry On 8kg + 1 Pieza de 23 kg en bodega|Traslados de llegada y de salida|Alojamiento con desayuno incluido|Excursión Circuito Chico|Asistencia al viajero'),
(2, 'Todo Incluido en Cancún', 'Relájate en las playas del caribe mexicano con todo incluido. Lujo y confort.', 'https://images.unsplash.com/photo-1512936738193-a44a4282a5c3?q=80&w=2070&auto=format&fit=crop', 10, 1500000.00, 1, 'Buenos Aires', 'Cancún', 'Vuelos directos Buenos Aires/Cancún/Buenos Aires|Equipaje en bodega de 23kg incluido|Traslados aeropuerto - hotel - aeropuerto|Alojamiento ALL INCLUSIVE|Bebidas ilimitadas|Todas las comidas incluidas|Entretenimiento diurno y nocturno|Asistencia al viajero internacional'),
(3, 'Europa Clásica: Madrid y Roma', 'Descubre la historia y la cultura de dos capitales europeas imperdibles.', 'https://images.unsplash.com/photo-1527838832700-5059252407fa?q=80&w=1996&auto=format&fit=crop', 12, 2100000.00, 1, 'Buenos Aires', 'Madrid y Roma', 'Vuelos internacionales con Iberia|Vuelo interno Madrid-Roma incluido|Equipaje en bodega 23kg|Hoteles 4 estrellas con desayuno|City tours en Madrid y Roma con guía en español|Traslados aeropuerto-hotel-aeropuerto|Asistencia al viajero internacional'),
(4, 'Ruta del Vino en Mendoza', 'Una experiencia sensorial para los amantes del buen vino y la gastronomía.', 'https://images.unsplash.com/photo-1587000098522-812f8896e8df?q=80&w=1935&auto=format&fit=crop', 4, 380000.00, 1, 'Buenos Aires', 'Mendoza', 'Aéreos Buenos Aires/Mendoza/Buenos Aires|Incluye Equipaje Carry On 8kg + 1 Pieza de 15 kg en bodega|Traslados de llegada y de salida|Alojamiento con desayuno|Asistencia al viajero'),
(5, 'Cataratas del Iguazú - Maravilla Natural', 'Descubre una de las 7 maravillas naturales del mundo. Visita los lados argentino y brasileño de las cataratas, navega hasta la Garganta del Diablo y disfruta de la selva misionera.', 'https://images.unsplash.com/photo-1563784462041-5f97ac9523dd?q=80&w=2074', 5, 420000.00, 1, 'Buenos Aires', 'Puerto Iguazú', 'Vuelos Buenos Aires/Iguazú/Buenos Aires|Equipaje en bodega incluido|Traslados aeropuerto-hotel-aeropuerto|4 noches de alojamiento con desayuno|Excursión Cataratas lado Argentino|Excursión Cataratas lado Brasileño|Paseo en lancha Gran Aventura|Entrada a los parques nacionales|Asistencia al viajero'),
(6, 'Ushuaia - Fin del Mundo', 'Viaja al fin del mundo y descubre paisajes únicos. Navega el Canal Beagle, conoce la Isla Martillo con sus pingüinos y recorre el Parque Nacional Tierra del Fuego.', 'https://images.unsplash.com/photo-1559827291-7ea7a7c6d5c3?q=80&w=2074', 6, 680000.00, 1, 'Buenos Aires', 'Ushuaia', 'Vuelos Buenos Aires/Ushuaia/Buenos Aires|Equipaje en bodega 23kg|Traslados in/out|5 noches con desayuno|Navegación Canal Beagle con Isla de Lobos|Parque Nacional Tierra del Fuego con Tren del Fin del Mundo|Excursión a Lagos Escondido y Fagnano|Asistencia al viajero');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `package_categories`
--

CREATE TABLE `package_categories` (
  `package_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `package_categories`
--

INSERT INTO `package_categories` (`package_id`, `category_id`) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 1),
(3, 2),
(3, 4),
(4, 2),
(4, 5),
(5, 1),
(5, 2),
(6, 1),
(6, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `package_departures`
--

CREATE TABLE `package_departures` (
  `id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `departure_date` date NOT NULL,
  `return_date` date NOT NULL,
  `price_per_person` decimal(10,2) NOT NULL,
  `available_seats` int(11) DEFAULT 20,
  `status` enum('DISPONIBLE','AGOTADO','CANCELADO') DEFAULT 'DISPONIBLE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `package_departures`
--

INSERT INTO `package_departures` (`id`, `package_id`, `departure_date`, `return_date`, `price_per_person`, `available_seats`, `status`) VALUES
(1, 4, '2025-07-10', '2025-07-13', 380000.00, 20, 'DISPONIBLE'),
(2, 4, '2025-08-10', '2025-08-13', 420000.00, 20, 'DISPONIBLE'),
(3, 4, '2025-09-10', '2025-09-13', 420000.00, 20, 'DISPONIBLE'),
(4, 4, '2025-10-10', '2025-10-13', 400000.00, 20, 'DISPONIBLE'),
(5, 4, '2025-11-10', '2025-11-13', 400000.00, 20, 'DISPONIBLE'),
(6, 4, '2025-12-10', '2025-12-13', 400000.00, 20, 'DISPONIBLE'),
(7, 4, '2025-12-14', '2025-12-17', 400000.00, 20, 'DISPONIBLE'),
(8, 1, '2025-07-15', '2025-07-21', 550000.00, 20, 'DISPONIBLE'),
(9, 1, '2025-08-15', '2025-08-21', 620000.00, 20, 'DISPONIBLE'),
(10, 1, '2025-09-15', '2025-09-21', 580000.00, 20, 'DISPONIBLE'),
(11, 1, '2025-10-15', '2025-10-21', 550000.00, 20, 'DISPONIBLE'),
(12, 2, '2025-07-20', '2025-07-29', 1500000.00, 20, 'DISPONIBLE'),
(13, 2, '2025-08-20', '2025-08-29', 1650000.00, 20, 'DISPONIBLE'),
(14, 2, '2025-09-20', '2025-09-29', 1450000.00, 20, 'DISPONIBLE'),
(15, 2, '2025-10-20', '2025-10-29', 1500000.00, 20, 'DISPONIBLE'),
(16, 2, '2025-11-20', '2025-11-29', 1400000.00, 20, 'DISPONIBLE'),
(17, 3, '2025-09-01', '2025-09-12', 2100000.00, 20, 'DISPONIBLE'),
(18, 3, '2025-10-01', '2025-10-12', 2200000.00, 20, 'DISPONIBLE'),
(19, 3, '2025-11-01', '2025-11-12', 2000000.00, 20, 'DISPONIBLE'),
(20, 5, '2025-07-10', '2025-07-14', 420000.00, 20, 'DISPONIBLE'),
(21, 5, '2025-08-10', '2025-08-14', 450000.00, 20, 'DISPONIBLE'),
(22, 5, '2025-09-10', '2025-09-14', 440000.00, 20, 'DISPONIBLE'),
(23, 5, '2025-10-10', '2025-10-14', 420000.00, 20, 'DISPONIBLE'),
(24, 6, '2025-08-05', '2025-08-10', 680000.00, 20, 'DISPONIBLE'),
(25, 6, '2025-09-05', '2025-09-10', 720000.00, 20, 'DISPONIBLE'),
(26, 6, '2025-10-05', '2025-10-10', 700000.00, 20, 'DISPONIBLE'),
(27, 6, '2025-11-05', '2025-11-10', 680000.00, 20, 'DISPONIBLE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `package_items`
--

CREATE TABLE `package_items` (
  `package_id` int(11) NOT NULL,
  `item_type` enum('FLIGHT','HOTEL','CAR_RENTAL','ACTIVITY') NOT NULL,
  `item_id` int(11) NOT NULL COMMENT 'ID del producto (vuelo, hotel, etc.)',
  `description` varchar(255) DEFAULT NULL COMMENT 'Ej: "Noche en habitación doble", "Vuelo de ida"',
  `day_number` int(11) DEFAULT NULL COMMENT 'Día del viaje cuando se usa este item',
  `departure_time` time DEFAULT NULL COMMENT 'Hora de salida para vuelos',
  `arrival_time` time DEFAULT NULL COMMENT 'Hora de llegada para vuelos',
  `notes` text DEFAULT NULL COMMENT 'Notas adicionales del item'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Define qué productos componen un paquete';

--
-- Volcado de datos para la tabla `package_items`
--

INSERT INTO `package_items` (`package_id`, `item_type`, `item_id`, `description`, `day_number`, `departure_time`, `arrival_time`, `notes`) VALUES
(1, 'FLIGHT', 3, 'Vuelo de ida Buenos Aires - Bariloche', 1, NULL, NULL, NULL),
(1, 'FLIGHT', 4, 'Vuelo de vuelta Bariloche - Buenos Aires', 7, NULL, NULL, NULL),
(1, 'HOTEL', 3, 'Hotel Llao Llao - 6 noches con desayuno', 1, NULL, NULL, NULL),
(2, 'FLIGHT', 7, 'Vuelo directo Buenos Aires - Cancún', 1, NULL, NULL, NULL),
(2, 'FLIGHT', 8, 'Vuelo directo Cancún - Buenos Aires', 10, NULL, NULL, NULL),
(2, 'HOTEL', 2, 'Riu Palace Las Americas - 9 noches All Inclusive', 1, NULL, NULL, NULL),
(3, 'FLIGHT', 11, 'Vuelo internacional Buenos Aires - Madrid', 1, NULL, NULL, NULL),
(3, 'FLIGHT', 12, 'Vuelo Madrid - Roma', 6, NULL, NULL, NULL),
(3, 'FLIGHT', 13, 'Vuelo internacional Roma - Buenos Aires', 12, NULL, NULL, NULL),
(3, 'HOTEL', 4, 'The Westin Palace Madrid - 4 noches con desayuno', 2, NULL, NULL, NULL),
(3, 'HOTEL', 6, 'Hotel de Russie Roma - 5 noches con desayuno', 6, NULL, NULL, NULL),
(4, 'FLIGHT', 1, 'Vuelo de ida Buenos Aires - Mendoza', 1, NULL, NULL, NULL),
(4, 'FLIGHT', 2, 'Vuelo de vuelta Mendoza - Buenos Aires', 4, NULL, NULL, NULL),
(4, 'HOTEL', 5, 'Hotel Cordón del Plata - 3 noches con desayuno', 1, NULL, NULL, NULL),
(5, 'FLIGHT', 14, 'Vuelo Buenos Aires - Iguazú', 1, NULL, NULL, NULL),
(5, 'FLIGHT', 15, 'Vuelo Iguazú - Buenos Aires', 5, NULL, NULL, NULL),
(5, 'HOTEL', 7, 'Hotel Meliá Iguazú - 4 noches con desayuno', 1, NULL, NULL, NULL),
(6, 'FLIGHT', 16, 'Vuelo Buenos Aires - Ushuaia', 1, NULL, NULL, NULL),
(6, 'FLIGHT', 17, 'Vuelo Ushuaia - Buenos Aires', 6, NULL, NULL, NULL),
(6, 'HOTEL', 8, 'Los Cauquenes Resort - 5 noches con desayuno', 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `package_tags`
--

CREATE TABLE `package_tags` (
  `package_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `package_tags`
--

INSERT INTO `package_tags` (`package_id`, `tag_id`) VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 4),
(5, 1),
(5, 4),
(6, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT 'credit_card',
  `status` enum('PENDIENTE','COMPLETADO','FALLIDO','REEMBOLSADO') NOT NULL,
  `transaction_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Registro de transacciones de pago';

--
-- Volcado de datos para la tabla `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `payment_date`, `amount`, `payment_method`, `status`, `transaction_id`) VALUES
(1, 1, '2025-06-11 00:10:58', 550000.00, 'credit_card', 'COMPLETADO', 'txn_1a2b3c4d5e6f7g8h9'),
(2, 2, '2025-06-11 00:10:58', 1500000.00, 'credit_card', 'COMPLETADO', 'txn_a9b8c7d6e5f4g3h2i1'),
(3, 3, '2025-06-11 00:10:58', 380000.00, 'credit_card', 'PENDIENTE', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `post_comments`
--

CREATE TABLE `post_comments` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `parent_comment_id` int(11) DEFAULT NULL COMMENT 'Para respuestas anidadas',
  `comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `post_likes`
--

CREATE TABLE `post_likes` (
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `product_availability`
--

CREATE TABLE `product_availability` (
  `id` int(11) NOT NULL,
  `product_table` varchar(20) NOT NULL COMMENT 'ej. "hotels", "packages"',
  `product_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `stock` int(11) NOT NULL COMMENT 'Lugares disponibles para este rango de fechas'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Gestiona el stock por rangos de fechas';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `product_table` varchar(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `rating` tinyint(1) NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Calificaciones y comentarios de los productos';

--
-- Volcado de datos para la tabla `reviews`
--

INSERT INTO `reviews` (`id`, `product_table`, `product_id`, `user_id`, `order_id`, `rating`, `comment`, `created_at`) VALUES
(1, 'packages', 1, 3, 1, 5, '¡El viaje fue increíble! Todo muy bien organizado. Lo recomiendo al 100%.', '2025-06-11 00:10:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seasonal_prices`
--

CREATE TABLE `seasonal_prices` (
  `id` int(11) NOT NULL,
  `product_table` varchar(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `season_name` varchar(100) NOT NULL COMMENT 'ej. "Temporada Alta", "Feriados"',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Gestiona precios diferentes por temporada';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `supplier_type` enum('AIRLINE','HOTEL_CHAIN','CAR_RENTAL_AGENCY','TOUR_OPERATOR') NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `contact_email` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Proveedores de servicios (aerolíneas, hoteles, etc.)';

--
-- Volcado de datos para la tabla `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `supplier_type`, `contact_person`, `contact_email`) VALUES
(1, 'Aerolíneas Argentinas', 'AIRLINE', NULL, NULL),
(2, 'LATAM Airlines', 'AIRLINE', NULL, NULL),
(3, 'Iberia', 'AIRLINE', NULL, NULL),
(4, 'Hilton Hotels & Resorts', 'HOTEL_CHAIN', NULL, NULL),
(5, 'Marriott International', 'HOTEL_CHAIN', NULL, NULL),
(6, 'Hertz', 'CAR_RENTAL_AGENCY', NULL, NULL),
(7, 'Avis', 'CAR_RENTAL_AGENCY', NULL, NULL),
(8, 'Civitatis', 'TOUR_OPERATOR', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `status` enum('ABIERTO','EN_PROGRESO','CERRADO') NOT NULL DEFAULT 'ABIERTO',
  `priority` enum('BAJA','MEDIA','ALTA') NOT NULL DEFAULT 'MEDIA',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tickets de soporte de usuarios';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tags`
--

CREATE TABLE `tags` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `color_class` varchar(50) DEFAULT 'bg-gray-500' COMMENT 'Clase de TailwindCSS para el color de fondo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tags`
--

INSERT INTO `tags` (`id`, `name`, `color_class`) VALUES
(1, 'Oferta', 'bg-red-500'),
(2, 'Últimos Lugares', 'bg-yellow-500'),
(3, 'All Inclusive', 'bg-cyan-500'),
(4, 'Cultural', 'bg-indigo-500');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ticket_responses`
--

CREATE TABLE `ticket_responses` (
  `id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'ID del usuario o admin que responde',
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Respuestas a los tickets de soporte';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `profile_picture_url` varchar(255) DEFAULT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 = Usuario, 1 = Admin',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de usuarios y autenticación';

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `last_name`, `email`, `password_hash`, `google_id`, `profile_picture_url`, `phone_number`, `address`, `is_admin`, `created_at`, `last_login`) VALUES
(1, 'Lautaro', 'Kilimik', 'admin@nosfuimos.com', '$2y$10$wAC8I8i4./GbGqHjH0AN5u8pU8vN1yv0F.uoK2h3.Wq.jHbyVzD7S', NULL, NULL, '+5491122334455', 'Av. Corrientes 123, CABA', 1, '2025-06-11 00:10:58', NULL),
(2, 'Sofia', 'Rivero', 'sofia.rivero@nosfuimos.com', '$2y$10$wAC8I8i4./GbGqHjH0AN5u8pU8vN1yv0F.uoK2h3.Wq.jHbyVzD7S', NULL, NULL, '+5491122334456', 'Calle Falsa 123, Springfield', 1, '2025-06-11 00:10:58', NULL),
(3, 'Juan', 'Pérez', 'juan.perez@email.com', '$2y$10$k3G7C.Xl/5bS4rGf.OqL3u5bF5/b6k3G7C.Xl/5bS4rGf.OqL3u5b', NULL, NULL, '+5492215556677', 'Diag. 74 1234, La Plata', 0, '2025-06-11 00:10:58', NULL),
(4, 'Ana', 'García', 'ana.garcia@email.com', '$2y$10$i8H1d.Nl/8cE9fG.XkL4u6bF6/c7k8H1d.Nl/8cE9fG.XkL4u6b', NULL, NULL, NULL, NULL, 0, '2025-06-11 00:10:58', NULL),
(5, 'Carlos', 'Gomez', 'carlos.gomez@email.com', '$2y$10$i8H1d.Nl/8cE9fG.XkL4u6bF6/c7k8H1d.Nl/8cE9fG.XkL4u6b', NULL, NULL, '+5493512223344', 'Bv. San Juan 500, Córdoba', 0, '2025-06-11 00:10:58', NULL),
(6, 'Lucia', 'Fernandez', 'lucia.fernandez@email.com', '$2y$10$i8H1d.Nl/8cE9fG.XkL4u6bF6/c7k8H1d.Nl/8cE9fG.XkL4u6b', NULL, NULL, NULL, NULL, 0, '2025-06-11 00:10:58', NULL),
(7, 'ADMIN', NULL, 'sivykilimik@gmail.com', '$2y$10$5Bax0GMGQJwPNlD8p8r/2OqRMy.UaxeNgJEkXiYwCr7Zghr9yB7dG', '106791362966767066918', NULL, NULL, NULL, 0, '2025-06-11 00:12:01', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `wishlists`
--

CREATE TABLE `wishlists` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT 'Mi Lista de Deseos',
  `is_public` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Listas de deseos de los usuarios';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `wishlist_items`
--

CREATE TABLE `wishlist_items` (
  `wishlist_id` int(11) NOT NULL,
  `product_table` varchar(20) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `agent_id` (`agent_id`);

--
-- Indices de la tabla `blog_posts`
--
ALTER TABLE `blog_posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `author_id` (`author_id`);

--
-- Indices de la tabla `blog_post_tags`
--
ALTER TABLE `blog_post_tags`
  ADD PRIMARY KEY (`post_id`,`tag_id`),
  ADD KEY `fk_bpt_tag` (`tag_id`);

--
-- Indices de la tabla `blog_tags`
--
ALTER TABLE `blog_tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `car_rentals`
--
ALTER TABLE `car_rentals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `pickup_location_id` (`pickup_location_id`);

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indices de la tabla `flights`
--
ALTER TABLE `flights`
  ADD PRIMARY KEY (`id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `origin_id` (`origin_id`),
  ADD KEY `destination_id` (`destination_id`);

--
-- Indices de la tabla `hotels`
--
ALTER TABLE `hotels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `location_id` (`location_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indices de la tabla `itineraries`
--
ALTER TABLE `itineraries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `package_day` (`package_id`,`day_number`);

--
-- Indices de la tabla `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indices de la tabla `order_passengers`
--
ALTER TABLE `order_passengers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_item_id` (`order_item_id`);

--
-- Indices de la tabla `packages`
--
ALTER TABLE `packages`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `package_categories`
--
ALTER TABLE `package_categories`
  ADD PRIMARY KEY (`package_id`,`category_id`),
  ADD KEY `fk_pcat_category` (`category_id`);

--
-- Indices de la tabla `package_departures`
--
ALTER TABLE `package_departures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `package_id` (`package_id`);

--
-- Indices de la tabla `package_items`
--
ALTER TABLE `package_items`
  ADD PRIMARY KEY (`package_id`,`item_type`,`item_id`);

--
-- Indices de la tabla `package_tags`
--
ALTER TABLE `package_tags`
  ADD PRIMARY KEY (`package_id`,`tag_id`),
  ADD KEY `fk_ptag_tag` (`tag_id`);

--
-- Indices de la tabla `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indices de la tabla `post_comments`
--
ALTER TABLE `post_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `parent_comment_id` (`parent_comment_id`);

--
-- Indices de la tabla `post_likes`
--
ALTER TABLE `post_likes`
  ADD PRIMARY KEY (`post_id`,`user_id`),
  ADD KEY `fk_likes_user` (`user_id`);

--
-- Indices de la tabla `product_availability`
--
ALTER TABLE `product_availability`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_lookup` (`product_table`,`product_id`);

--
-- Indices de la tabla `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indices de la tabla `seasonal_prices`
--
ALTER TABLE `seasonal_prices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_lookup` (`product_table`,`product_id`);

--
-- Indices de la tabla `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `ticket_responses`
--
ALTER TABLE `ticket_responses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticket_id` (`ticket_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `google_id` (`google_id`);

--
-- Indices de la tabla `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `wishlist_items`
--
ALTER TABLE `wishlist_items`
  ADD PRIMARY KEY (`wishlist_id`,`product_table`,`product_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `blog_posts`
--
ALTER TABLE `blog_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `blog_tags`
--
ALTER TABLE `blog_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `car_rentals`
--
ALTER TABLE `car_rentals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `flights`
--
ALTER TABLE `flights`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `hotels`
--
ALTER TABLE `hotels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `itineraries`
--
ALTER TABLE `itineraries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `order_passengers`
--
ALTER TABLE `order_passengers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `packages`
--
ALTER TABLE `packages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `package_departures`
--
ALTER TABLE `package_departures`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de la tabla `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `post_comments`
--
ALTER TABLE `post_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `product_availability`
--
ALTER TABLE `product_availability`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `seasonal_prices`
--
ALTER TABLE `seasonal_prices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `support_tickets`
--
ALTER TABLE `support_tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tags`
--
ALTER TABLE `tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `ticket_responses`
--
ALTER TABLE `ticket_responses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `fk_appointment_agent` FOREIGN KEY (`agent_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_appointment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `blog_posts`
--
ALTER TABLE `blog_posts`
  ADD CONSTRAINT `fk_posts_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `blog_post_tags`
--
ALTER TABLE `blog_post_tags`
  ADD CONSTRAINT `fk_bpt_post` FOREIGN KEY (`post_id`) REFERENCES `blog_posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_bpt_tag` FOREIGN KEY (`tag_id`) REFERENCES `blog_tags` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `car_rentals`
--
ALTER TABLE `car_rentals`
  ADD CONSTRAINT `fk_car_location` FOREIGN KEY (`pickup_location_id`) REFERENCES `locations` (`id`),
  ADD CONSTRAINT `fk_car_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`);

--
-- Filtros para la tabla `flights`
--
ALTER TABLE `flights`
  ADD CONSTRAINT `fk_flight_destination` FOREIGN KEY (`destination_id`) REFERENCES `locations` (`id`),
  ADD CONSTRAINT `fk_flight_origin` FOREIGN KEY (`origin_id`) REFERENCES `locations` (`id`),
  ADD CONSTRAINT `fk_flight_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`);

--
-- Filtros para la tabla `hotels`
--
ALTER TABLE `hotels`
  ADD CONSTRAINT `fk_hotel_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`),
  ADD CONSTRAINT `fk_hotel_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`);

--
-- Filtros para la tabla `itineraries`
--
ALTER TABLE `itineraries`
  ADD CONSTRAINT `fk_itinerary_package` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `order_passengers`
--
ALTER TABLE `order_passengers`
  ADD CONSTRAINT `fk_passenger_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `package_categories`
--
ALTER TABLE `package_categories`
  ADD CONSTRAINT `fk_pcat_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pcat_package` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `package_departures`
--
ALTER TABLE `package_departures`
  ADD CONSTRAINT `fk_departure_package` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `package_items`
--
ALTER TABLE `package_items`
  ADD CONSTRAINT `fk_pi_package` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `package_tags`
--
ALTER TABLE `package_tags`
  ADD CONSTRAINT `fk_ptag_package` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ptag_tag` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Filtros para la tabla `post_comments`
--
ALTER TABLE `post_comments`
  ADD CONSTRAINT `fk_comments_parent` FOREIGN KEY (`parent_comment_id`) REFERENCES `post_comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_comments_post` FOREIGN KEY (`post_id`) REFERENCES `blog_posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `post_likes`
--
ALTER TABLE `post_likes`
  ADD CONSTRAINT `fk_likes_post` FOREIGN KEY (`post_id`) REFERENCES `blog_posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `fk_ticket_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ticket_responses`
--
ALTER TABLE `ticket_responses`
  ADD CONSTRAINT `fk_response_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_response_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `fk_wishlist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `wishlist_items`
--
ALTER TABLE `wishlist_items`
  ADD CONSTRAINT `fk_wi_wishlist` FOREIGN KEY (`wishlist_id`) REFERENCES `wishlists` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
